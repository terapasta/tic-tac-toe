import os
import csv
import yaml
import boto3
import logging
import argparse
import pandas as pd

from app.shared.logger import logger
from app.shared.benchmark import Benchmark


def generate_testcase():
    logger.info('start')

    bench = Benchmark()
    bench.generate_testcase()

if __name__ == "__main__":
    generate_testcase()
