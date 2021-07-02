#!/usr/bin/env python3

# Simple script to list databases in a mongodb

import argparse
from pymongo import MongoClient
from urllib.parse import quote_plus

parser = argparse.ArgumentParser(description='Connect to MongoDB')
parser.add_argument('--username')
parser.add_argument('--password')
parser.add_argument('--host', required=True)
parser.add_argument('--port', default=27017, type=int)
args = parser.parse_args()

client = MongoClient(host=args.host, port=args.port, username=args.username, password=args.password)

for db in client.list_databases():
    print(db['name'])
