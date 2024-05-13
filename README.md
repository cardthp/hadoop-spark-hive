## Deploy hive
all script in 1_deploy.sh(spark,hive)
```bash
$ cd hadoop-spark-hive
$ docker-compose up -d
$ chmod 775 main.sh
$ ./main.sh
```

## Check data in hive table
```bash
$ docker-compose exec hive-server bash
$ beeline -u jdbc:hive2://localhost:10000 -n root
$ select * from order_detail limit 5;
$ select * from restaurant_detail limit 5; 
$ select * from order_detail_new limit 5;
$ select * from restaurant_detail_new limit 5;
$ SHOW COLUMNS from order_detail
$ SHOW COLUMNS from restaurant_detail
$ SHOW COLUMNS from order_detail_new
$ SHOW COLUMNS from restaurant_detail_new
```

## hive output
[1. cooking.csv](hive/data_input/cooking.csv)<br/>
[2. discount.csv](hive/data_output/discount.csv)