import argparse

from app.controllers.benchmark_controller import BenchmarkController
from app.shared.config import Config
from app.shared.benchmark import Benchmark
from app.shared.context import Context
from app.shared.logger import logger

def benchmark(exit_on_finished=False):
    # ベンチマーク用のクラス
    bm = Benchmark()

    # コマンドライン引数
    parser = argparse.ArgumentParser()
    parser.add_argument('--env', type=str, default='development')
    args = parser.parse_args()

    Config().init(args.env)

    # ベンチマーク（提案手法）
    class LearningParameterCurrent:
        algorithm = bm.alg_base_current
        feedback_algorithm = bm.alg_feedback_current
    context_current = Context(bm.bot_id, LearningParameterCurrent(), {})
    result_current = BenchmarkController(context=context_current).perform()

    # ベンチマーク（競合手法）
    class LearningParameterCompeted:
        algorithm = bm.alg_base_competed
        feedback_algorithm = bm.alg_feedback_competed
    context_competed = Context(bm.bot_id, LearningParameterCompeted(), {})
    result_competed = BenchmarkController(context=context_competed).perform()

    # 精度の比較
    result_accuracy = bm.is_improved(result_current['accuracy'], result_competed['accuracy'], is_error=False)
    result_mcll = bm.is_improved(result_current['mcll'], result_competed['mcll'])

    logger.info('accracy improved: %s' % result_accuracy)
    logger.info('mcll improved: %s' % result_mcll)

    # どちらかの精度が上がっていれば良しとする
    if result_accuracy and result_competed:
        logger.info('proposed method improves all evaluation values')
        if exit_on_finished:
            exit(0)
    elif result_accuracy or result_competed:
        logger.info('proposed method improves a part of evaluation values')
        if exit_on_finished:
            exit(0)
    else:
        logger.critical('proposed method falls all evalation values')
        if exit_on_finished:
            exit(1)


if __name__ == "__main__":
    benchmark(exit_on_finished=True)
