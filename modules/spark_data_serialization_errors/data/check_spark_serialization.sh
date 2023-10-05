

#!/bin/bash



# Set variables

SPARK_VERSION=${VERSION}

SERIALIZATION_LIBRARY=${LIBRARY}



# Check Spark version

if [[ "$SPARK_VERSION" != "2.4" ]]; then

  echo "Spark version $SPARK_VERSION is not compatible with this script."

  exit 1

fi



# Check serialization library

if [[ "$SERIALIZATION_LIBRARY" != "Kryo" ]]; then

  echo "Serialization library $SERIALIZATION_LIBRARY is not compatible with this script."

  exit 1

fi



# Check if data serialization errors are occurring

if grep -q "java.io.IOException: Failed to serialize" ${PATH_TO_SPARK_LOGS}; then

  echo "Data serialization errors are occurring."

else

  echo "No data serialization errors found."

fi