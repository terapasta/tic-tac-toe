# -*- coding: utf-8 -
from mprpc import RPCClient

client = RPCClient('127.0.0.1', 6000)
print client.call('reply', [0,9], 'SUMAOUとは？')
