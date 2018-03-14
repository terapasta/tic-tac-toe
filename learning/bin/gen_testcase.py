import csv
import yaml
import logging
import argparse

from app.controllers.evaluate_controller import EvaluateController
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.context import Context
from app.shared.document_generator import DocumentGenerator

DEFAULT_CONFIG_FILE_PATH = 'config/evaluate_config.yml'
DEFAULT_DOCUMENT_GENERATOR = Constants.DOCUMENT_GENERATOR_REPLACEMENT

def generate_testcase():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', default=DEFAULT_CONFIG_FILE_PATH, type=str)
    args = parser.parse_args()

    # 設定ファイルを読み込む
    conf = None
    with open(args.config) as f:
        buf = yaml.load(f)
        if 'current' in buf:
            conf = buf['current']

    if conf is None:
        raise FileNotFoundError

    # 文章生成器
    dg = DocumentGenerator()

    if not 'testcase' in conf:
        logging.fatal("%s must include key 'testcase'" % args.config)
        if not 'options' in conf['testcase']:
            logging.fatal("%s must include key 'options' as child of 'testcase'" % args.config)

    options = conf['testcase']['options']
    test_src_type = options['src_type']
    test_src_path = options['src_path']
    test_dict_path = options['synonym_path']
    test_dst_type = options['dst_type']
    test_dst_path = options['dst_path']

    testcase = _generate_testcase_by_replacement(
        dg,
        src_type=test_src_type,
        src_path=test_src_path,
        dict_path=test_dict_path
    )

    _save_testcase(testcase, dst_type=test_dst_type, dst_path=test_dst_path)


def _generate_testcase_by_replacement(document_generator, src_type=None, src_path=None, dict_path=None):
    testcase = []
    if src_type == 'file':
        with open(src_path) as f:
            reader = csv.DictReader(f, delimiter=',')
            testcase = _generate_testcase_by_replacement_from_reader(document_generator, reader, dict_path)
    return testcase


def _generate_testcase_by_replacement_from_reader(document_generator=None, reader=None, dict_path=None):
    testcase = []
    for row in reader:
        docs = document_generator.generate_by_replacement(row['question'], dict_file_path=dict_path)
        for doc in docs:
            testcase.append({
                'question': doc,
                'question_answer_id': row['question_answer_id'],
                'bot_id': row['bot_id'],
            })
    return testcase


def _save_testcase(testcase, dst_type=None, dst_path=None):
    if dst_type == 'file':
        with open(dst_path, 'w') as f:
            writer = csv.DictWriter(f, fieldnames=['question', 'question_answer_id', 'bot_id'])
            writer.writerows(testcase)
    else:
        raise NotImplementedError


if __name__ == "__main__":
    generate_testcase()
