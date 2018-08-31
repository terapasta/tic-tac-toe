from app.shared.datasource.database.database import Database
from app.shared.constants import Constants
from app.shared.base_cls import BaseCls


class Synonyms(BaseCls):
    def __init__(self):
        self.database = Database()

    def all(self):
        return self.database.select(
            'SELECT wm.id, wm.word, wm.bot_id, wms.value \
                FROM word_mappings as wm \
                INNER JOIN word_mapping_synonyms as wms \
                ON wm.id = wms.word_mapping_id;',
            params={},
        )

    def by_bot(self, bot_id):
        return self.database.select(
            'SELECT wm.id, wm.word, wm.bot_id, wms.value \
                FROM word_mappings as wm \
                INNER JOIN word_mapping_synonyms as wms \
                ON wm.id = wms.word_mapping_id \
                WHERE wm.bot_id IS NULL OR bot_id = %(bot_id)s;',
            params={"bot_id": bot_id},
        )
