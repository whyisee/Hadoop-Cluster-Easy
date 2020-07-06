#!/bin/bash

HADOOP_CMD=/opt/hadoop-2.8.5/bin/hadoop
STREAM_JAR_PATH=/opt/hadoop-2.8.5/share/hadoop/tools/lib/hadoop-streaming-2.8.5.jar 

INPUT_FILE=$1
OUTPUT_PATH=$2

$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_PATH


$HADOOP_CMD jar $STREAM_JAR_PATH \
        -input $INPUT_FILE \
        -output $OUTPUT_PATH \
        -mapper "python map.py" \
        -reducer "python reduce.py" \
        -file ./map.py \
        -file ./reduce.py
