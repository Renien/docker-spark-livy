<h1 align="center">
  <h4 align="center">Docker Spark & Livy</h4>
</h1>

<p align="center">
       <a href="">
           <img src="https://img.shields.io/npm/l/express.svg?maxAge=2592000&style=flat-square"
                alt="License">
         </a>
    </p>

## Summary

Spark 2.4.7 with Livy 0.7.0

This is a docker image of [Apache Spark](https://spark.apache.org/) & [Apache Livy](https://livy.apache.org/)

## Requirements

|Package|Version|  
|:-----:|:-----:|  
|python3|3.8.5|  
|docker|20.10.2|
|docker-compose|1.27.4|
|spark|2.4.7|
|Livy|0.7.0|
|Java|1.8.0_271|

## How to run

This image can be used to run using the [docker-compose file](docker-compose.yml)

1. Install docker-compose.
2. Run `docker-compose up`.

```sh
~/projects/personal/docker-spark-livy$ sudo docker-compose up
Creating network "docker-spark-livy_default" with the default driver
Creating spark-master   ... done
Creating spark-worker-1 ... done
Creating livy           ... done
Attaching to spark-master, spark-worker-1, livy
```

Spark Docker Master/Work Image : [Spark Standalone Image](https://hub.docker.com/r/renien/spark-stand-alone)  

Access the UIs:
1. Spark Master at spark://master:7077 (http://localhost:8080/).
2. Spark Worker at 172.20.0.2:8881 (http://localhost:8081/).
3. Livy UI at 172.20.0.3:8998 (http://localhost:8998/).

Test Spark and Livy using `API`.
```sh
# CREATING A LIVY SESSION
curl -X POST -d '{"kind": "spark","driverMemory":"512M","executorMemory":"512M"}' -H "Content-Type: application/json" http://localhost:8998/sessions/

# SUBMITTING A SIMPLE LOGIC TO TEST SPARK SHELL
curl -X POST -d '{"code": "1 + 1"}' -H "Content-Type: application/json" http://localhost:8998/sessions/0/statements

# SUBMITTING A SPARK CODE
curl -X POST -d '{"code": "val data = Array(1,2,3); sc.parallelize(data).count"}' -H "Content-Type: application/json" http://localhost:8998/sessions/0/statements
```

Livy UI:

![LivyUI](https://raw.githubusercontent.com/Renien/docker-spark-livy/master/doc/livy-ui.png "LivyUI")

Spark Master UI:

![SparkMaster](https://raw.githubusercontent.com/Renien/docker-spark-livy/master/doc/spark-master.png "SparkMaster")

Spark Worker UI:

![SparkWorker](https://raw.githubusercontent.com/Renien/docker-spark-livy/master/doc/spark-worker.png "SparkWorker")

## License
[Docker Spark Livy](https://github.com/Renien/docker-spark-livy) is released under the [MIT](https://opensource.org/licenses/MIT) © [Renien](https://github.com/Renien).

