#!/bin/bash

# Parse arguments
VERBOSE=false
if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
    VERBOSE=true
fi

echo "========================================"
echo "    DEVELOPMENT ENVIRONMENT STATUS"
echo "========================================"
echo

echo "NODE.JS ENVIRONMENT:"
if command -v volta >/dev/null 2>&1; then
    volta_version=$(volta --version)
    echo "  ✅ Volta: $volta_version"
    
    if [[ "$VERBOSE" == true ]]; then
        echo "      Location: $(which volta)"
        if command -v node >/dev/null 2>&1; then
            echo "      Node: $(node --version)"
            echo "      npm: $(npm --version)"
        fi
    fi
else
    echo "  ❌ Volta: Not installed"
fi

echo

echo "DOCKER ENVIRONMENT:"
if command -v docker >/dev/null 2>&1; then
    docker_version=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    echo "  ✅ Docker: $docker_version"
    
    if [[ "$VERBOSE" == true ]]; then
        echo "      Location: $(which docker)"
        if docker info >/dev/null 2>&1; then
            running_containers=$(docker ps --format "{{.Names}}" | wc -l | tr -d ' ')
            echo "      Running containers: $running_containers"
            if [[ "$running_containers" -gt 0 ]]; then
                echo "      Container list:"
                docker ps --format "        {{.Names}} ({{.Status}})"
            fi
        else
            echo "      Status: Docker daemon not running"
        fi
    fi
else
    echo "  ❌ Docker: Not installed"
fi

echo

echo "DEVELOPMENT TOOLS:"
if command -v code >/dev/null 2>&1; then
    echo "  ✅ VS Code CLI: Available"
    if [[ "$VERBOSE" == true ]]; then
        echo "      Location: $(which code)"
    fi
else
    echo "  ❌ VS Code CLI: Not available"
fi

if command -v git >/dev/null 2>&1; then
    git_version=$(git --version | cut -d' ' -f3)
    echo "  ✅ Git: $git_version"
    if [[ "$VERBOSE" == true ]]; then
        git_user=$(git config --global user.name)
        git_email=$(git config --global user.email)
        echo "      User: $git_user <$git_email>"
    fi
else
    echo "  ❌ Git: Not installed"
fi

echo

echo "ENVIRONMENT VARIABLES:"
if [ -n "$NPM_TOKEN" ]; then
    echo "  ✅ NPM_TOKEN: Set"
else
    echo "  ❌ NPM_TOKEN: Not found"
fi

echo

echo "KEY SERVICES & PORTS:"
check_port() {
    lsof -i ":$1" >/dev/null 2>&1
}

if check_port 3000; then
    echo "  ✅ Port 3000 (Frontend): In use"
else
    echo "  ⚠️  Port 3000 (Frontend): Available"
fi

if check_port 3001; then
    echo "  ✅ Port 3001 (Backend): In use"
else
    echo "  ⚠️  Port 3001 (Backend): Available"
fi

if check_port 5432; then
    echo "  ✅ Port 5432 (PostgreSQL): In use"
else
    echo "  ⚠️  Port 5432 (PostgreSQL): Available"
fi

if check_port 6379; then
    echo "  ✅ Port 6379 (Redis): In use"
else
    echo "  ⚠️  Port 6379 (Redis): Available"
fi

if check_port 9092; then
    echo "  ✅ Port 9092 (Kafka): In use"
else
    echo "  ⚠️  Port 9092 (Kafka): Available"
fi

echo

echo "PROJECT STATUS:"
if [ -d ~/code/work/cdp-ui ]; then
    if [ -f ~/code/work/cdp-ui/package.json ]; then
        echo "  ✅ cdp-ui: Ready"
    else
        echo "  ⚠️  cdp-ui: Missing package.json"
    fi
else
    echo "  ❌ cdp-ui: Not found"
fi

if [ -d ~/code/work/cdp-behind-service ]; then
    if [ -f ~/code/work/cdp-behind-service/package.json ]; then
        echo "  ✅ cdp-behind-service: Ready"
    else
        echo "  ⚠️  cdp-behind-service: Missing package.json"
    fi
else
    echo "  ❌ cdp-behind-service: Not found"
fi

if [[ "$VERBOSE" == true ]]; then
    echo
    echo "SYSTEM RESOURCES:"
    echo "  Disk usage: $(df -h / | awk 'NR==2 {print $5}') of root volume"
    echo "  Current directory: $(pwd)"
fi

echo

echo "Use 'dev-status -v' for detailed information"