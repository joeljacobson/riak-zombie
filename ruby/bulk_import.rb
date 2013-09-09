#!/usr/bin/env ruby

require 'csv'
require 'riak'
require 'ruby-progressbar'
require 'multi_json'
require 'oj'

RIAK_HOST      = '127.0.0.1'
RIAK_PB_PORT   = 11087
RIAK_HTTP_PORT = 11098
ZOMBIE_BUCKET  = 'za'
DATA_FILE      = 'data/ZA5c.csv'

def client(host = nil)
  @client ||= Riak::Client.new(:host => riak_host(host), :protocol => 'pbc', :pb_port => RIAK_PB_PORT)
end

## Get the number of rows to feed to the progressbar.
def row_count(infile)
  `wc -l #{infile}`.chomp.strip.split(' ').first.to_i
end

def riak_host(host = nil) 
  host || RIAK_HOST
end

def endpoint(opts = {})
  opts = { :bucket  => ZOMBIE_BUCKET, :http_port => RIAK_HTTP_PORT }.merge(opts)

  "http://#{riak_host}:#{opts[:http_port]}/buckets/#{opts[:bucket]}/keys/#{opts[:key]}"
end

def bucket
  @bucket ||= client.bucket(ZOMBIE_BUCKET)
end

def progress
  @progress ||= ProgressBar.create(:title => 'Rows', :total => row_count(DATA_FILE), :format => '%e |%b>>%i| %p%% %t')
end

def endpoints(ep = nil)
  @endpoints ||= []

  [@endpoints << ep].flatten.compact
end

def build_indices(record, snack)
  record.indexes['sex_bin']    << snack[:sex]    if snack[:sex]
  record.indexes['blood_bin']  << snack[:blood]  if snack[:blood]
  record.indexes['weight_bin'] << snack[:weight] if snack[:weight]
  record.indexes['state_bin']  << snack[:state]  if snack[:state]
end

def store!
  CSV.table(DATA_FILE, :headers => true).each_with_index do |snack, i|
    progress.increment
    key                 = snack[:social]
    record              = bucket.get_or_new(key)

    record.data         = snack

    build_indices(record, snack)

    record.store
    endpoints(endpoint(:key => key))
  end
end

progress
store!

puts endpoints
