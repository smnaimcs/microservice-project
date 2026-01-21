#!/bin/bash

# Configuration
COLOR_RESET="\033[0m"
COLOR_INFO="\033[36m"
COLOR_SUCCESS="\033[32m"
COLOR_ERROR="\033[31m"

print_info() { echo -e "${COLOR_INFO}[INFO]${COLOR_RESET} $1"; }
print_success() { echo -e "${COLOR_SUCCESS}[SUCCESS]${COLOR_RESET} $1"; }
print_error() { echo -e "${COLOR_ERROR}[ERROR]${COLOR_RESET} $1"; }

QUICK_MODE=false
if [[ "$1" == "--quick" ]]; then
    QUICK_MODE=true
    print_info "Running in QUICK mode..."
fi

# Check requirements
check_requirement() {
    if ! command -v "$1" &> /dev/null; then
        print_error "$1 is not installed. Please install it to continue."
        exit 1
    fi
}

if [[ "$QUICK_MODE" == false ]]; then
    check_requirement docker
    check_requirement docker-compose
    check_requirement mvn
    check_requirement java
fi

# Setup environment
if [[ ! -f .env ]]; then
    print_info "Creating .env from .env.example..."
    cp .env.example .env
fi

# Start services
print_info "Starting Docker Compose services..."
docker-compose up -d

print_success "Setup complete! Services are running in the background."
print_info "User Service: http://localhost:8081"
print_info "Database: localhost:5432"
