#!/bin/bash

if [ $# -lt 2 ]
then
  echo "Missing arguments. AWS profile name and kinesis stream name are required."
  echo "Usage : $0 <aws profile name> <stream name> [shard index] [shard iterator type]"
  exit
fi

profile_name=$1
stream_name=$2
shard_array_index=${3:-0}
shard_iterator_type=${4:-LATEST}

shard_id=$(aws kinesis describe-stream --profile ${profile_name} --stream-name ${stream_name} --query "StreamDescription.Shards[${shard_array_index}].ShardId" --output text)
shard_iterator=$(aws kinesis get-shard-iterator --profile ${profile_name} --stream-name ${stream_name} --shard-id ${shard_id} --shard-iterator-type ${shard_iterator_type} --query "ShardIterator" --output text)
aws kinesis get-records --limit 1 --shard-iterator ${shard_iterator} --profile ${profile_name}
