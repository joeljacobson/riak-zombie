#!/bin/sh

echo "Terminating all running instances..."

for i in `ec2-describe-instances -F instance-state-name=running | grep INSTANCE | awk {'print $2'}`; do ec2-terminate-instances $i; done

echo "Done."
