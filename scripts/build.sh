#!/bin/bash
# Build script for K8S_Test application

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

echo -e "${BLUE}🏗️  K8S_Test Build Script${NC}"
echo "=========================="

# Check Java version
print_info "Checking Java version..."
java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$java_version" -lt 17 ]; then
    print_error "Java 17+ required, found: $java_version"
    exit 1
fi
print_status "Java version check passed"

# Clean and test
print_info "Running tests..."
if [ -f "./mvnw" ]; then
    ./mvnw clean test
else
    mvn clean test
fi
print_status "Tests passed"

# Package application
print_info "Packaging application..."
if [ -f "./mvnw" ]; then
    ./mvnw package -DskipTests
else
    mvn package -DskipTests
fi
print_status "Application packaged"

# Build Docker images
print_info "Building Docker images..."

# Standard Dockerfile
docker build -t k8s-demo/testk8s:latest -f Dockerfile .
print_status "Standard Docker image built"

# Optimized Dockerfile
docker build -t k8s-demo/testk8s:optimized -f Dockerfile.optimized .
print_status "Optimized Docker image built"

# Using Jib (if available)
if [ -f "./mvnw" ]; then
    print_info "Building with Jib..."
    ./mvnw jib:dockerBuild -Djib.to.image=k8s-demo/testk8s:jib
    print_status "Jib image built"
fi

print_status "🎉 Build completed successfully!"
echo
echo "Available images:"
docker images k8s-demo/testk8s