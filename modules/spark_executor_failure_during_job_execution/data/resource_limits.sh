

#!/bin/bash



# Set the resource limits

MEMORY=${EXECUTOR_MEMORY}

CPU=${EXECUTOR_CORES}

DISK=${DISK_LIMIT}



# Get the current executor resources

CURRENT_MEMORY=$(grep -oP 'spark\.executor\.memory\s*\K\S+' $SPARK_HOME/conf/spark-defaults.conf)

CURRENT_CPU=$(grep -oP 'spark\.executor\.cores\s*\K\S+' $SPARK_HOME/conf/spark-defaults.conf)

CURRENT_DISK=$(grep -oP 'spark\.executor\.dir\s*\K\S+' $SPARK_HOME/conf/spark-defaults.conf)



# Check if the current resources are less than the desired limits

if [ $CURRENT_MEMORY -lt $MEMORY ] || [ $CURRENT_CPU -lt $CPU ] || [ $CURRENT_DISK -lt $DISK ]; then

  # Increase the resources

  sed -i "s/spark\.executor\.memory.*/spark\.executor\.memory $MEMORY/" $SPARK_HOME/conf/spark-defaults.conf

  sed -i "s/spark\.executor\.cores.*/spark\.executor\.cores $CPU/" $SPARK_HOME/conf/spark-defaults.conf

  sed -i "s/spark\.executor\.dir.*/spark\.executor\.dir $DISK/" $SPARK_HOME/conf/spark-defaults.conf

  echo "Executor resources updated"

else

  echo "Executor resources are sufficient"

fi