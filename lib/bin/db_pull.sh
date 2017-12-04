#!/bin/sh

# $1: output file path
# $2: bot_ids (ex: '8,11,13')
OUTPUT=$1
BOT_IDS=$2
cd ~
source /var/www/donusagi-bot/shared/.env
echo '[mysqldump]' > .mysqldumpconfig
echo "user=myope" >> .mysqldumpconfig
echo "password=$DB_PASSWORD" >> .mysqldumpconfig
echo "host=$DB_HOST" >> .mysqldumpconfig

function dump() {
  # $1: table name
  # $2: where query
  mysqldump \
    --defaults-file=.mysqldumpconfig \
    myope \
    $1 -t \
    --where="$2" \
    --no-create-info \
    --replace \
    >> $OUTPUT
}

dump 'bots' "id IN (${BOT_IDS})"
dump 'question_answers' "bot_id IN (${BOT_IDS})"
dump 'word_mappings' "word IS NOT NULL"
dump 'word_mapping_synonyms' "value IS NOT NULL"
dump 'accuracy_test_cases' "bot_id IN (${BOT_IDS})"
dump 'decision_branches' "bot_id IN (${BOT_IDS})"
dump 'learning_parameters' "bot_id IN (${BOT_IDS})"
dump 'topic_taggings' "bot_id IN (${BOT_IDS})"
dump 'ratings' "bot_id IN (${BOT_IDS})"

# clean
rm .mysqldumpconfig
