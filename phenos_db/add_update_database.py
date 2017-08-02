import logging
import setup_logger
import argparse
import sys
import pandas
import sqlite3
import numpy


logger = logging.getLogger(setup_logger.LOGGER_NAME)

controlled_vocab_columns_table = {"class_id":"class", "pert_type":"pert_type", "perturbagen_id_type":"pert_id_type"}


def build_parser():
	parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
	parser.add_argument("--verbose", "-v", help="Whether to print a bunch of output.", action="store_true", default=False)
	parser.add_argument("--database_file", "-df", help="path to database file", type=str, required=True)
	parser.add_argument("--input_file", "-if", help="path to input file", type=str, required=True)

	parser.add_argument("--dont_commit", help="don't commit any changes to the database", action="store_true", default=False)


	### to potentially use later
	parser.add_argument("-hostname", help="lims db host name", type=str, default="getafix-v")
	parser.add_argument("-queue_choice", "-qc", help="which of the queues to work on - valid values are roast, brew, both", type=str,
		choices=["roast", "brew", "both"], default="both")
	parser.add_argument("-add_to_queue", "-a", help="add the det_plate entries to the roast_queue", type=str, nargs="+", default=None)
	# To make --option1 and --option2 mutually exclusive, one can define mutually_exclusive_group in argparse, 
	# argparse asserts that the options added to the group are not used at the same time and throws exception if otherwise
    	mutually_exclusive_group = parser.add_mutually_exclusive_group()
    	mutually_exclusive_group.add_argument("--option1", action="store", dest="option1", help="provide argument for option1", default=None)
    	mutually_exclusive_group.add_argument("--option2", action="store", dest="option2", help="provide argument for option2", default=None)

	return parser


def main(args):
	logger.info("connecting to args.database_file:  {}".format(args.database_file))
	conn = sqlite3.connect(args.database_file)
	cursor = conn.cursor()

	input_df = read_file(args.input_file)

	add_controlled_vocab(cursor, input_df)

	add_update_signature(cursor, input_df)

	add_update_gsm_signature(cursor, input_df)

	add_update_batch(cursor, input_df)

	cursor.close()
	if args.dont_commit:
		logger.info("rolling back changes to database since args.dont_commit == True")
		conn.rollback()
	else:
		logger.info("committing changes to database")
		conn.commit()


def add_controlled_vocab(cursor, input_df):
	# remove_entries_set = {None}
	# logger.debug("remove_entries_set:  {}".format(remove_entries_set))

	for (column, db_table) in controlled_vocab_columns_table.items():
		logger.debug("column:  {}  db_table:  {}".format(column, db_table))

		unique_df_entries = set(input_df.loc[~pandas.isnull(input_df[column]), column].unique())
		# unique_df_entries = unique_df_entries - {None}
		logger.debug("unique_df_entries:  {}".format(unique_df_entries))

		cursor.execute("select name from {}".format(db_table))
		current_db_entries = set(cursor.fetchall())
		logger.debug("current_db_entries:  {}".format(current_db_entries))

		to_add_entries = unique_df_entries - current_db_entries
		insert_stmt = "insert into {} (name) values (?)".format(db_table)
		logger.debug("insert_stmt:  {}".format(insert_stmt))
		for to_add_entry in to_add_entries:
			cursor.execute(insert_stmt, (to_add_entry, ))


def add_update_signature(cursor, input_df):
	pass

def add_update_gsm_signature(cursor, input_df):
	pass

def add_update_batch(cursor, input_df):
	pass

def read_file(input_file):
	return pandas.read_csv(input_file, sep="\t")


if __name__ == "__main__":
	args = build_parser().parse_args(sys.argv[1:])

	setup_logger.setup(verbose=args.verbose)

	logger.debug("args:  {}".format(args))

	main(args)

