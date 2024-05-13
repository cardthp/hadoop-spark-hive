echo "copy data to docker"
docker cp data_input/order_detail.csv namenode:order_detail.csv
docker cp data_input/restaurant_detail.csv namenode:restaurant_detail.csv

echo "put data to hdfs"
docker exec -it namenode hdfs dfs -mkdir /data # If error show no such file
docker exec -it namenode hdfs dfs -put order_detail.csv /data/
docker exec -it namenode hdfs dfs -put restaurant_detail.csv /data/
# Check file if exist by (you will not found on docker bash) > $docker exec -it namenode hdfs dfs -ls /data/
# Case remove : docker exec -it namenode hdfs dfs -rm -r /<path/filename>

echo "pyspark write partition for hive table"
docker cp script/etl_spark.py spark-master:etl_spark.py
docker exec -it spark-master /spark/bin/spark-submit --master spark://spark-master:7077 etl_spark.py

echo "hive prepare table"
docker cp script/etl_hive.sql hive-server:/opt/etl_hive.sql
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 -f etl_hive.sql

echo "hive query" # !! It's work when you run on GitBash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 --outputformat=csv2 -e 'select category,avg(discount_no_null) as average_discount from order_detail_new o join restaurant_detail_new r on (r.id == o.restaurant_id) group by category;' > data_output/discount.csv
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000 --outputformat=csv2 -e 'select cooking_bin,count(cooking_bin) as count_cooking_bin from order_detail_new o join restaurant_detail_new r on (r.id == o.restaurant_id) group by cooking_bin;' > data_output/cooking.csv


# docker exec -it hive-server /bin/bash > hive > select * from testdb.employee;