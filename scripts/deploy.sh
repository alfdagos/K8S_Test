#!/bin/bash
# Deploy script for K8S_Test application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NAMESPACE=${NAMESPACE:-default}
IMAGE_TAG=${IMAGE_TAG:-1.0.0}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-k8s-demo}

echo -e "${BLUE}🚀 K8S_Test Deployment Script${NC}"
echo "================================"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        print_error "docker is not installed"
        exit 1
    fi
    
    # Check kubectl connectivity
    if ! kubectl cluster-info &> /dev/null; then
        print_error "kubectl cannot connect to cluster"
        exit 1
    fi
    
    print_status "Prerequisites check passed"
}

# Build application
build_app() {
    print_info "Building Spring Boot application..."
    
    if [ -f "./mvnw" ]; then
        ./mvnw clean package -DskipTests
    else
        mvn clean package -DskipTests
    fi
    
    print_status "Application built successfully"
}

# Build Docker image
build_image() {
    print_info "Building Docker image..."
    
    local image_name="${DOCKER_REGISTRY}/testk8s:${IMAGE_TAG}"
    
    docker build -t "${image_name}" .
    
    print_status "Docker image built: ${image_name}"
}

# Deploy to Kubernetes
deploy_k8s() {
    print_info "Deploying to Kubernetes namespace: ${NAMESPACE}"
    
    # Create namespace if it doesn't exist
    kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -
    
    # Update image tag in deployment
    sed "s|k8s-demo/testk8s:1.0.0|${DOCKER_REGISTRY}/testk8s:${IMAGE_TAG}|g" k8s/deployment.yaml > /tmp/deployment-updated.yaml
    
    # Apply all manifests
    kubectl apply -f k8s/configmap.yaml -n "${NAMESPACE}"
    kubectl apply -f k8s/rbac.yaml -n "${NAMESPACE}"
    kubectl apply -f /tmp/deployment-updated.yaml -n "${NAMESPACE}"
    kubectl apply -f k8s/service.yaml -n "${NAMESPACE}"
    
    # Clean up temporary file
    rm -f /tmp/deployment-updated.yaml
    
    print_status "Kubernetes manifests applied"
}

# Wait for deployment
wait_for_deployment() {
    print_info "Waiting for deployment to be ready..."
    
    kubectl rollout status deployment/testk8s -n "${NAMESPACE}" --timeout=300s
    
    print_status "Deployment is ready"
}

# Get service information
get_service_info() {
    print_info "Getting service information..."
    
    local nodeport=$(kubectl get svc testk8s -n "${NAMESPACE}" -o jsonpath='{.spec.ports[0].nodePort}')
    local nodes=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}')
    
    if [ -z "$nodes" ]; then
        nodes=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
        print_warning "Using internal IPs (for local clusters)"
    fi
    
    echo "🌐 Service Access Information:"
    echo "   Namespace: ${NAMESPACE}"
    echo "   NodePort: ${nodeport}"
    echo "   Nodes: ${nodes}"
    echo
    echo "🔗 Access URLs:"
    for node in $nodes; do
        echo "   http://${node}:${nodeport}/"
        echo "   http://${node}:${nodeport}/actuator/health"
    done
}

# Test deployment
test_deployment() {
    print_info "Testing deployment..."
    
    local pod_name=$(kubectl get pods -l app=testk8s -n "${NAMESPACE}" -o jsonpath='{.items[0].metadata.name}')
    
    if [ -n "$pod_name" ]; then
        # Port forward for testing
        kubectl port-forward "$pod_name" 8080:8080 -n "${NAMESPACE}" &
        local port_forward_pid=$!
        
        sleep 3
        
        # Test health endpoint
        if curl -sf http://localhost:8080/actuator/health > /dev/null; then
            print_status "Health check passed"
        else
            print_error "Health check failed"
        fi
        
        # Test main endpoint
        if curl -sf http://localhost:8080/ > /dev/null; then
            print_status "Main endpoint test passed"
        else
            print_error "Main endpoint test failed"
        fi
        
        # Kill port forward
        kill $port_forward_pid 2>/dev/null || true
    else
        print_warning "No pod found for testing"
    fi
}

# Main deployment function
main() {
    local skip_build=false
    local skip_tests=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-build)
                skip_build=true
                shift
                ;;
            --skip-tests)
                skip_tests=true
                shift
                ;;
            --namespace)
                NAMESPACE="$2"
                shift 2
                ;;
            --image-tag)
                IMAGE_TAG="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --skip-build      Skip application and Docker image build"
                echo "  --skip-tests      Skip deployment tests"
                echo "  --namespace NAME  Deploy to specific namespace (default: default)"
                echo "  --image-tag TAG   Use specific image tag (default: 1.0.0)"
                echo "  -h, --help        Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    print_info "Starting deployment with:"
    print_info "  Namespace: ${NAMESPACE}"
    print_info "  Image Tag: ${IMAGE_TAG}"
    print_info "  Registry: ${DOCKER_REGISTRY}"
    echo
    
    check_prerequisites
    
    if [ "$skip_build" = false ]; then
        build_app
        build_image
    else
        print_warning "Skipping build steps"
    fi
    
    deploy_k8s
    wait_for_deployment
    get_service_info
    
    if [ "$skip_tests" = false ]; then
        test_deployment
    else
        print_warning "Skipping deployment tests"
    fi
    
    echo
    print_status "🎉 Deployment completed successfully!"
    print_info "Use 'kubectl get all -n ${NAMESPACE}' to see all resources"
}

# Run main function
main "$@"