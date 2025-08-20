#!/bin/bash

# WordPress Performance Test Suite
# Tests performance and load times

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 WordPress Performance Test Suite${NC}"
echo -e "${BLUE}==================================${NC}"
echo ""

# Test WordPress homepage load time
echo -e "${BLUE}📊 Testing homepage load time...${NC}"
START_TIME=$(date +%s.%N)
curl -s -o /dev/null http://localhost:8000
END_TIME=$(date +%s.%N)
LOAD_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)

if (( $(echo "$LOAD_TIME < 2.0" | bc -l) )); then
    echo -e "${GREEN}✅ Homepage load time: ${LOAD_TIME}s (Good)${NC}"
else
    echo -e "${YELLOW}⚠️ Homepage load time: ${LOAD_TIME}s (Slow)${NC}"
fi

# Test WordPress admin load time
echo -e "${BLUE}📊 Testing admin load time...${NC}"
START_TIME=$(date +%s.%N)
curl -s -o /dev/null http://localhost:8000/wp-admin
END_TIME=$(date +%s.%N)
LOAD_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)

if (( $(echo "$LOAD_TIME < 3.0" | bc -l) )); then
    echo -e "${GREEN}✅ Admin load time: ${LOAD_TIME}s (Good)${NC}"
else
    echo -e "${YELLOW}⚠️ Admin load time: ${LOAD_TIME}s (Slow)${NC}"
fi

# Test database connection speed
echo -e "${BLUE}📊 Testing database connection speed...${NC}"
START_TIME=$(date +%s.%N)
docker exec wp-db mysql -u wp_user -pwp_password -e 'SELECT 1;' > /dev/null 2>&1
END_TIME=$(date +%s.%N)
DB_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)

if (( $(echo "$DB_TIME < 0.5" | bc -l) )); then
    echo -e "${GREEN}✅ Database response time: ${DB_TIME}s (Good)${NC}"
else
    echo -e "${YELLOW}⚠️ Database response time: ${DB_TIME}s (Slow)${NC}"
fi

# Test container resource usage
echo -e "${BLUE}📊 Testing container resource usage...${NC}"
MEMORY_USAGE=$(docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}" | grep wp | awk '{print $2}' | sed 's/MiB//')
CPU_USAGE=$(docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}" | grep wp | awk '{print $2}' | sed 's/%//')

echo -e "${BLUE}📈 WordPress Container:${NC}"
echo -e "   Memory: ${MEMORY_USAGE}MiB"
echo -e "   CPU: ${CPU_USAGE}%"

# Test concurrent requests
echo -e "${BLUE}📊 Testing concurrent requests...${NC}"
for i in {1..5}; do
    START_TIME=$(date +%s.%N)
    curl -s -o /dev/null http://localhost:8000
    END_TIME=$(date +%s.%N)
    CONCURRENT_TIME=$(echo "$END_TIME - $START_TIME" | bc -l)
    echo -e "   Request $i: ${CONCURRENT_TIME}s"
done

echo ""
echo -e "${GREEN}✅ Performance tests completed!${NC}"
