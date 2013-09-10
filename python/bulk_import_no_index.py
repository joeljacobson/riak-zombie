import csv
import json
import riak

client = riak.RiakClient(pb_port=8087, protocol='pbc')
bucket = client.bucket('za')

f = open("ZA10k.csv", "r")
for row in csv.DictReader(f):
    key = row['social']
    sex = row['sex']
    blood = row['blood']
    weight = row['weight']
    state = row['state']
    item = bucket.new(key, data=row)
     item.store()
f.close()