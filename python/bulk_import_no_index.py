import csv
import json
import riak

client = riak.RiakClient(http_port=10018, protocol='http')
bucket = client.bucket('za')

f = open("za10k.csv", "r")
for row in csv.DictReader(f):
    key = row['social']
    sex = row['sex']
    blood = row['blood']
    weight = row['weight']
    state = row['state']
    item = bucket.new(key, data=row)
   
    item.store()
f.close()