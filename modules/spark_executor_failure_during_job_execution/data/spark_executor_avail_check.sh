

#!/bin/bash



# Define parameters

SPARK_EXECUTOR_MEMORY=${EXECUTOR_MEMORY}

SPARK_EXECUTOR_CORES=${EXECUTOR_CORES}



# Check available system memory

SYS_MEM=$(free -m | awk 'NR==2{print $2}')

if (( $SYS_MEM < $SPARK_EXECUTOR_MEMORY )); then

  echo "Insufficient system memory available for Spark executor"

fi



# Check available CPU cores

CORES=$(nproc)

if (( $CORES < $SPARK_EXECUTOR_CORES )); then

  echo "Insufficient CPU cores available for Spark executor"

fi