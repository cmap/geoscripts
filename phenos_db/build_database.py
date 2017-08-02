import sqlite3
import logging
import setup_logger


logger = logging.getLogger(setup_logger.LOGGER_NAME)


def build(connection_str):
    f = open("database/update001_initial_creation_GEO_extraction_schema.sql")
    creation_script = f.read().strip()
    f.close()

    conn = sqlite3.connect(connection_str)
    conn.executescript(creation_script)
    conn.commit()

    return conn