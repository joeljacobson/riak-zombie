#!/bin/sh

ec2-describe-instances -F instance-state-name=running | grep INSTANCE | awk {'print $4'} | grep amazon
