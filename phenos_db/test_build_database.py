import unittest
import logging
import setup_logger
import build_database as bd
import tempfile
import os.path


logger = logging.getLogger(setup_logger.LOGGER_NAME)

# Some notes on testing conventions (more in cuppers convention doc):
#	(1) Use "self.assert..." over "assert"
#		- self.assert* methods: https://docs.python.org/2.7/library/unittest.html#assert-methods
#       - This will ensure that if one assertion fails inside a test method,
#         exectution won't halt and the rest of the test method will be executed
#         and other assertions are also verified in the same run.
# 	(2) For testing exceptions use:
#		with self.assertRaises(some_exception) as context:
#			[call method that should raise some_exception]
#		self.assertEqual(str(context.exception), "expected exception message")
#
#		self.assertAlmostEquals(...) for comparing floats


class TestBuildDatabase(unittest.TestCase):
    def test_build_database(self):
        #happy path just in memory
        conn = bd.build(":memory:")
        self.assertIsNotNone(conn)

        cursor = conn.cursor()
        cursor.execute("select count(*) from pert_type")
        cursor.fetchone()

        cursor.close()
        conn.close()

        #happy path actual file
        db_file = tempfile.NamedTemporaryFile()
        logger.debug("db_file.name:  {}".format(db_file.name))
        conn = bd.build(db_file.name)

        cursor = conn.cursor()
        cursor.execute("select count(*) from pert_id_type")
        cursor.close()
        conn.close()


if __name__ == "__main__":
    setup_logger.setup(verbose=True)

    unittest.main()
