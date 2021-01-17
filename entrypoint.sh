#!/bin/bash

# Expecting arguemnts (LIVY_HOME, SPARK_HOME)
LIVY_HOME=$1
SPARK_HOME=$2
LIVY_ENV=$LIVY_HOME/conf/livy-env.sh
LIVY_CONF=$LIVY_HOME/conf/livy.conf
LIVY_LOGS=$LIVY_HOME/logs

# Create `livy-env.sh` file
echo '#!/bin/bash' >> $LIVY_ENV
echo 'export SPARK_HOME='$SPARK_HOME >> $LIVY_ENV

# Use `livy.conf.extra` as extra parameters to build `livy.conf`
LIVY_CONF_EXTRA_VOLUME='livy.conf.extra'
LIVY_CONF_EXTRA_LOCAL='livy.conf.extra.local'

cp $LIVY_CONF_EXTRA_VOLUME $LIVY_CONF_EXTRA_LOCAL
mkdir $LIVY_LOGS

# Override `livy.conf` with environment variables
if [[ -n $SPARK_MASTER_ENDPOINT ]] && [[ -n $SPARK_MASTER_PORT ]]; then
  sed -i "/livy.spark.master/d" $LIVY_CONF_EXTRA_LOCAL
  echo "[ 'livy.conf' from environment variable ] livy.spark.master = spark://$SPARK_MASTER_ENDPOINT:$SPARK_MASTER_PORT"
  echo livy.spark.master = spark://$SPARK_MASTER_ENDPOINT:$SPARK_MASTER_PORT >> $LIVY_CONF
fi

if [[ -n $LIVY_FILE_LOCAL_DIR_WHITELIST ]]; then
  sed -i "/livy.file.local-dir-whitelist/d" $LIVY_CONF_EXTRA_LOCAL
  echo "[ 'livy.conf' from environment variable ] livy.file.local-dir-whitelist = $LIVY_FILE_LOCAL_DIR_WHITELIST"
  echo livy.file.local-dir-whitelist = $LIVY_FILE_LOCAL_DIR_WHITELIST >> $LIVY_CONF
fi

while read line; do
  echo "[   'livy.conf' from 'livy.conf.extra'  ] $line"
  echo $line >> $LIVY_CONF
done < $LIVY_CONF_EXTRA_LOCAL

# Run Livy Server
$LIVY_HOME/bin/livy-server
