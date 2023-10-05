

#!/bin/bash



# Set the spark version to upgrade to

SPARK_VERSION=${VERSION}



# Download the latest stable release of spark

wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz



# Extract the spark binaries to /opt/spark

sudo tar -xzf spark-$SPARK_VERSION-bin-hadoop2.7.tgz -C /opt/



# Update the symbolic link to point to the new spark version

sudo ln -sf /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark



# Update the PATH variable to include the new spark binaries

echo 'export PATH=$PATH:/opt/spark/bin' >> ~/.bashrc

source ~/.bashrc



# Verify the new spark version is installed and working

spark-submit --version