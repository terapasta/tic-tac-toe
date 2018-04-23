import io
import os
import csv
import yaml
import boto3
from boto3.session import Session
import pandas as pd
from app.shared.logger import logger
from app.shared.config import Config
from app.shared.base_cls import BaseCls
from app.core.error.invalid_config_error import InvalidConfigError
from app.shared.document_generator import DocumentGenerator

BENCHMARK_CONF_FILE_PATH = 'config/benchmark_config.yml'


class Benchmark(BaseCls):
    def __init__(self, conf_file_path=BENCHMARK_CONF_FILE_PATH):
        conf = None
        with open(conf_file_path) as f:
            conf = yaml.load(f)

        # configファイルが正しくなければエラーを raise
        if not self._is_valid_configuration(conf):
            raise InvalidConfigError(message="benchmark configuration is not valid: %s" % conf_file_path)

        # ベンチマーク設定をパースして保存
        self._set_config(conf)
        logger.info('configuration file loaded')

    @property
    def alg_base_current(self):
        return self._alg_base_current

    @property
    def alg_base_competed(self):
        return self._alg_base_competed

    @property
    def alg_feedback_current(self):
        return self._alg_feedback_current

    @property
    def alg_feedback_competed(self):
        return self._alg_feedback_competed

    @property
    def bot_id(self):
        return self._bot_id

    def _is_valid_configuration(self, conf):
        # 設定ファイルが存在しない場合
        if (conf is None):
            return False

        # bot_id
        if not 'bot_id' in conf:
            return False

        # アルゴリズムに関する設定
        if 'algorithm' in conf:

            # ベースアルゴリズムとフィードバックアルゴリズムそれぞれをチェック
            if 'base' in conf['algorithm'] and 'feedback' in conf['algorithm']:
                base_alg = conf['algorithm']['base']
                feedback_alg = conf['algorithm']['feedback']

                # 提案手法と競合手法の設定
                # 全ての設定が過不足無く入っていなければ False
                if not ('current' in base_alg and 'competed' in base_alg and
                        'current' in feedback_alg and 'competed' in feedback_alg):
                    return False
            else:
                return False
        else:
            return False

        # テストケースに関する設定
        if (conf is None) or (not 'testcase' in conf) or (not 'options' in conf['testcase']):
            return False

        # 全てのテストをパスした場合
        return True

    def _set_config(self, config):
        # アルゴリズムに関する設定
        self._alg_base_current = config['algorithm']['base']['current']
        self._alg_base_competed = config['algorithm']['base']['competed']
        self._alg_feedback_current = config['algorithm']['feedback']['current']
        self._alg_feedback_competed = config['algorithm']['feedback']['competed']

        # bot_id
        self._bot_id = config['bot_id']

        # テストケース生成に関する設定
        options = config['testcase']['options']

        # 出力するテストケースのバージョン
        self._version = config['testcase']['version']

        #  テストケース生成元ファイル
        self._test_src_type = options['src_type']
        self._test_src_path = options['src_path']

        # テストケース生成に使用する辞書ファイル
        self._test_dict_path = options['synonym_path']

        # テストケース生成先
        self._test_dst_type = options['dst_type']
        self._test_dst_path = self._get_versioned_dst_path(options['dst_path'], self._version)
        self._bucket_name = options['bucket_name']

    def is_improved(self, current_value, competed_value, is_error=True):
        if is_error:
            # 計測値が誤差なら、小さい方が良い
            return current_value <= competed_value
        else:
            # そうでなければ、大きいほうが良い
            return current_value >= competed_value

    def generate_testcase(self):
        # 文章生成器
        dg = DocumentGenerator()

        # テストケースを生成するためのソースを取得する
        src_testcase = self._load_testcase_src()
        logger.info('source of testcases loaded')

        src_dict = self._load_dict()
        logger.info('dictionary of synonyms loaded')

        # テストケースを生成
        testcase = self._generate_testcase_by_replacement(
            dg,
            src=src_testcase,
            dict=src_dict,
        )
        logger.info('testcase generated successfully')

        # テストケースを保存する
        self._save_testcase(testcase)
        logger.info('testcase saved to %s:%s' % (self._test_dst_type, self._test_dst_path))

    def get_testcase(self):
        testcase = []

        # ファイルから取得
        if self._test_dst_type == 'file':
            with open(self._test_dst_path) as f:
                reader = csv.DictReader(f, delimiter=",")
                testcase = [x for x in reader]

        # s3 から取得
        elif self._test_dst_type == 's3':
            # s3 からオブジェクトを取得
            s3 = self.aws_session.resource('s3')
            res = s3.Object(self._bucket_name, self._test_dst_path).get()

            # オブジェクトの中身を取得
            data = res['Body'].read().decode('utf-8')

            # csv を読み込む
            reader = csv.DictReader(io.StringIO(data))
            testcase = [x for x in reader]

        else:
            raise NotImplementedError

        # テストケースが未生成だったら、例外を発生させる
        if len(testcase) <= 0:
            logger.critical("testcase not found: required to generate testcase before run benchmarker")
            raise FileNotFoundError

        return testcase

    def _generate_testcase_by_replacement(self, document_generator, src=None, dict=None):
        testcase = [['question', 'question_answer_id', 'bot_id']]
        for row in src:
            docs = document_generator.generate_by_replacement(row['question'], dict=dict)
            for doc in docs:
                testcase.append([doc, row['question_answer_id'], row['bot_id']])
        return testcase

    def _get_versioned_dst_path(self, path, version):
        path_as_tuple = os.path.splitext(path)
        if len(path_as_tuple) != 2:
            raise FileNotFoundError

        return ''.join([path_as_tuple[0], '_v', version, path_as_tuple[1]])

    def _load_testcase_src(self):
        src_testcase = []

        # ファイル入力
        if self._test_src_type == 'file':
            with open(self._test_src_path) as f:
                reader = csv.DictReader(f)
                src_testcase = [x for x in reader]

        # s3から取得
        elif self._test_src_type == 's3':
            if self._bucket_name is None:
                raise NameError

            # s3 からオブジェクトを取得
            s3 = self.aws_session.resource('s3')
            res = s3.Object(self._bucket_name, self._test_src_path).get()

            # オブジェクトの中身を取得
            data = res['Body'].read().decode('utf-8')

            # csv を読み込む
            reader = csv.DictReader(io.StringIO(data))
            src_testcase = [x for x in reader]

        else:
            raise NotImplementedError

        return src_testcase

    def _load_dict(self):
        df = None
        with open(self._test_dict_path, 'r') as f:
            df = pd.io.json.json_normalize(yaml.load(f))
        return df

    def _save_testcase(self, testcase):
        # csv を文字列として格納
        data = '\n'.join([','.join(x) for x in testcase])

        # ファイル出力
        if self._test_dst_type == 'file':
            with open(self._test_dst_path, 'w') as f:
                f.write(data)

        # S3に格納
        elif self._test_dst_type == 's3':
            if self._bucket_name is None:
                raise NameError

            s3 = self.aws_session.resource('s3')
            obj = s3.Object(self._bucket_name, self._test_dst_path)
            obj.put(
                Body=data.encode('utf-8'),
                ContentEncoding='utf-8',
                ContentType='text/plain',
            )

        else:
            raise NotImplementedError

    @property
    def aws_session(self):
        if not hasattr(self, '_aws_session'):
            self._aws_session = Session(
                aws_access_key_id=os.environ.get('AWS_ACCESS_KEY_ID'),
                aws_secret_access_key=os.environ.get('AWS_SECRET_ACCESS_KEY'),
                region_name='ap-northeast-1'
            )
        return self._aws_session

