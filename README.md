
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Spark executor failure during job execution.
---

This incident type refers to a failure in one or more Spark executors during the execution of a job. Spark executors are worker processes that run computations and store data in memory or on disk. When an executor fails, it can cause the entire job to fail or result in degraded performance. This type of incident can occur for a variety of reasons, such as hardware or network issues, memory errors, or software bugs.

### Parameters
```shell
export APPLICATION_ID="PLACEHOLDER"

export MASTER_URL="PLACEHOLDER"

export SPARK_HOME="PLACEHOLDER"

export EXECUTOR_ID="PLACEHOLDER"

export DRIVER_ID="PLACEHOLDER"

export EXECUTOR_MEMORY="PLACEHOLDER"

export EXECUTOR_CORES="PLACEHOLDER"

export DISK_LIMIT="PLACEHOLDER"
```

## Debug

### Check the status of the Spark application
```shell
${SPARK_HOME}/bin/spark-submit --master ${MASTER_URL} --status ${APPLICATION_ID}
```

### View the logs for the failed executor
```shell
${SPARK_HOME}/bin/spark-submit --master ${MASTER_URL} --logs ${APPLICATION_ID} ${EXECUTOR_ID}
```

### Check the resource usage of the executor
```shell
${SPARK_HOME}/bin/spark-submit --master ${MASTER_URL} --metrics ${APPLICATION_ID} --executor-id ${EXECUTOR_ID} --driver-id ${DRIVER_ID}
```

### Check the system logs for any relevant error messages
```shell
journalctl -u spark.service | grep ERROR
```

### Insufficient resources allocated to the Spark executor leading to failure during job execution.
```shell


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


```

## Repair

### Check if the executor has sufficient resources such as memory, CPU cores, and disk space. Increase the resources if necessary.
```shell


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


```