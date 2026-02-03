#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}>>> Start Pipeline${NC}"

 
echo -e "${BLUE}1. loading Docker...${NC}"
docker compose -f dataproc/spark-docker-compose.yml up -d --scale spark-worker=3


echo -e "${BLUE}2. waiting for PostgreSQL...${NC}"

until docker exec postgres_nyc pg_isready -U user_spark -d nyc_taxi; do
  echo "Postgres is loading... waiting 2s"
  sleep 2
done


echo -e "${BLUE}3. loading landing...${NC}"
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/landing/taxi_zone_lookup.py
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/landing/yellow_taxi_trip.py '{"_PROCESS_DATE": "2025-05-01"}'
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/landing/yellow_taxi_trip.py '{"_PROCESS_DATE": "2025-06-01"}'

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Sucess!${NC}"
else
    echo "Error..."
    exit 1
fi


echo -e "${BLUE}3. loading bronze...${NC}"
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/bronze/taxi_zone_lookup.py
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/bronze/yellow_taxi_trip.py '{"_START_DATE": "2025-05-01", "_END_DATE": "2025-06-01"}'

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Sucess!${NC}"
else
    echo "Error..."
    exit 1
fi


echo -e "${BLUE}3. loading silver...${NC}"
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/silver/yellow_taxi_trip.py
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/silver/taxi_zone_lookup.py
docker exec -it spark-master /opt/spark/bin/spark-submit /jobs/process/silver/aux_dim_tables.py

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Sucess!${NC}"
else
    echo "Error..."
    exit 1
fi


echo -e "${BLUE}3. loading gold...${NC}"

docker exec -it spark-master /opt/spark/bin/spark-submit \
    --master spark://spark-master:7077 \
    --packages org.postgresql:postgresql:42.6.0 \
    --conf "spark.driver.extraClassPath=/root/.ivy2/jars/*" \
    --conf "spark.executor.extraClassPath=/root/.ivy2/jars/*" \
    /jobs/process/gold/write_to_db.py

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Sucess!${NC}"
else
    echo "Error..."
    exit 1
fi
