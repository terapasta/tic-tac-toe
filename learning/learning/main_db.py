# -*- coding: utf-8 -
import dataset

db = dataset.connect('mysql://root@localhost/donusagi_bot')

training_messages = db['training_messages'].all()

for training_message in training_messages:
   print(training_message['body'])
