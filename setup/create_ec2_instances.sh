#!/bin/sh

echo "Creating $$i EC2 instances..."
ec2-run-instances ami-ce7b6fba -k ricardomontalban -g riak-training -n $1 -t m1.large
echo "Done."
