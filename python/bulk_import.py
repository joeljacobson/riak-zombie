import csv
import json
import riak

client = riak.RiakClient(pb_port=8087, protocol='pbc')
bucket = client.bucket('za')

f = open("ZA10K.csv", "r")
for row in csv.DictReader(f):
    key = row['social'] # Dates are unique, use as keys.
    item = bucket.new(key, data=row)
    item.store()
f.close()
