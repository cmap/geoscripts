import unittest
import logging
import setup_logger
import add_update_database as aud
import pandas
import tempfile
import build_database


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


class TestAddUpdateDatabase(unittest.TestCase):
	def test_build_parser(self):
		#simple happy path
		args_list = ["-df", "a", "-if", "b"]
		args = aud.build_parser().parse_args(args_list)
		logger.debug("simple happy path - args:  {}".format(args))

	def test_main(self):
		db_file = tempfile.NamedTemporaryFile()
		logger.debug("db_file.name:  {}".format(db_file.name))

		build_database.build(db_file.name).close()

		args_list = ["-df", db_file.name, "-if",
					 "functional_tests/test_add_update_database/example_input.txt"]
		args = aud.build_parser().parse_args(args_list)
		aud.main(args)

	def test_read_input_file(self):
		df = aud.read_file("functional_tests/test_add_update_database/example_input.txt")
		logger.debug("df.shape:  {}".format(df.shape))
		logger.debug("df.columns:  {}".format(df.columns))
		self.assertLess(0, df.shape[0])
		self.assertIn("gsm", df.columns)

	def test_add_controlled_vocab(self):
		conn = build_database.build(":memory:")
		cursor = conn.cursor()

		#happy path - add initial values
		df = pandas.DataFrame({"class_id":["A", "B"], "perturbagen_id_type":["entrez_id", "mesh"], "pert_type":[None, float('nan')]})
		aud.add_controlled_vocab(cursor, df)

		cursor.execute("select count(*) from class where name = 'A'")
		r = cursor.fetchone()[0]
		logger.debug("class A count - r:  {}".format(r))
		self.assertEqual(1, r)

		cursor.execute("select count(*) from pert_id_type")
		r = cursor.fetchone()[0]
		logger.debug("pert_id_type count - r:  {}".format(r))
		self.assertEqual(2, r)

		cursor.close()
		conn.close()

if __name__ == "__main__":
	setup_logger.setup(verbose=True)

	unittest.main()
