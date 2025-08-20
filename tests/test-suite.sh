#!/bin/bash

# WordPress Docker Development Setup - Test Suite
# Tests all functionality of the development environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test function
test_function() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -e "${BLUE}🧪 Testing: $test_name${NC}"
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS: $test_name${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        echo -e "${RED}❌ FAIL: $test_name${NC}"
        echo -e "${YELLOW}Expected: $expected_result${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# Header
echo -e "${BLUE}🚀 WordPress Docker Development Setup - Test Suite${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Test 1: Check if Docker is running
test_function "Docker is running" "docker info > /dev/null 2>&1" "Docker daemon should be running"

# Test 2: Check if containers are running
test_function "WordPress container is running" "docker ps --format 'table {{.Names}}' | grep -q '^wp$'" "WordPress container should be running"

# Test 3: Check if database container is running
test_function "Database container is running" "docker ps --format 'table {{.Names}}' | grep -q '^wp-db$'" "Database container should be running"

# Test 4: Check if WordPress is accessible
test_function "WordPress is accessible" "curl -s -o /dev/null -w '%{http_code}' http://localhost:8000 | grep -q '200\|301'" "WordPress should respond with HTTP 200 or 301"

# Test 5: Check if WordPress admin is accessible
test_function "WordPress admin is accessible" "curl -s -o /dev/null -w '%{http_code}' http://localhost:8000/wp-admin | grep -q '200\|301'" "WordPress admin should be accessible"

# Test 6: Check if database is connected
test_function "Database connection works" "docker exec wp-db mysql -u wp_user -pwp_password -e 'SELECT 1;' > /dev/null 2>&1" "Database should be accessible"

# Test 7: Check if theme directory exists
test_function "Theme directory exists" "test -d 'themes/my-theme'" "Theme directory should exist"

# Test 8: Check if theme files exist
test_function "Theme files exist" "test -f 'themes/my-theme/style.css' && test -f 'themes/my-theme/index.php'" "Theme files should exist"

# Test 9: Check if .env file exists
test_function ".env file exists" "test -f '.env'" ".env file should exist"

# Test 10: Check if docker-compose.yml exists
test_function "docker-compose.yml exists" "test -f 'docker-compose.yml'" "docker-compose.yml should exist"

# Test 11: Check if taskfile exists
test_function "taskfile.yml exists" "test -f 'taskfile.yml'" "taskfile.yml should exist"

# Test 12: Check if WordPress CLI is available
test_function "WP-CLI is available" "docker exec wp wp --version --allow-root > /dev/null 2>&1" "WP-CLI should be available"

# Test 13: Check if theme is activated
test_function "Theme is activated" "docker exec wp wp theme list --status=active --format=csv --allow-root | grep -q 'my-theme'" "Theme should be activated"

# Test 14: Check if WordPress is properly installed
test_function "WordPress is installed" "docker exec wp wp core is-installed --allow-root" "WordPress should be installed"

# Test 15: Check if admin user exists
test_function "Admin user exists" "docker exec wp wp user list --role=administrator --format=csv --allow-root | grep -q 'admin'" "Admin user should exist"

# Test 16: Check if media directory is writable
test_function "Media directory is writable" "docker exec wp test -w /var/www/html/wp-content/uploads" "Media directory should be writable"

# Test 17: Check if theme directory is mounted
test_function "Theme directory is mounted" "docker exec wp test -f /var/www/html/wp-content/themes/my-theme/style.css" "Theme should be mounted in container"

# Test 18: Check if PHP extensions are loaded
test_function "PHP extensions are loaded" "docker exec wp php -m | grep -q 'mysqli'" "PHP mysqli extension should be loaded"

# Test 19: Check if Apache modules are enabled
test_function "Apache modules are enabled" "docker exec wp apache2ctl -M | grep -q 'rewrite'" "Apache rewrite module should be enabled"

# Test 20: Check if health check is working
test_function "Health check is working" "docker exec wp curl -f http://localhost/ > /dev/null 2>&1" "Health check should pass"

echo ""
echo -e "${BLUE}📊 Test Results Summary${NC}"
echo -e "${BLUE}=======================${NC}"
echo -e "Total Tests: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
echo -e "${RED}Failed: $FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! Your WordPress setup is working correctly.${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed. Please check the setup.${NC}"
    exit 1
fi
