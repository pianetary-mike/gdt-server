#!/bin/bash
set -e

echo "=========================================="
echo "Building gdt-server Docker images"
echo "=========================================="

# Step 1: Compile Java application
echo ""
echo "Step 1: Compiling Java application..."
mvn clean package -DskipTests=true

# Step 2: Download native libraries if needed
echo ""
echo "Step 2: Downloading native libraries..."
mkdir -p build/native/olca-native/0.0.1/x64
if [ ! -d "build/native/olca-native/0.0.1/x64" ] || [ -z "$(ls -A build/native/olca-native/0.0.1/x64 2>/dev/null)" ]; then
    echo "  Downloading native libraries..."
    curl -L https://github.com/GreenDelta/olca-native/releases/download/v0.0.1/olca-native-umfpack-linux-x64.zip -o build/native_linux_x64.zip
    unzip -q build/native_linux_x64.zip -d build/native/olca-native/0.0.1/x64/
    rm build/native_linux_x64.zip
    echo "  ✓ Native libraries downloaded"
else
    echo "  ✓ Native libraries already exist"
fi

# Step 3: Build Docker images
echo ""
echo "Step 3: Building Docker images..."

echo "  Building gdt-server-app..."
docker build -f app.Dockerfile -t gdt-server-app:latest .

echo "  Building gdt-server-lib..."
docker build -f lib.Dockerfile -t gdt-server-lib:latest .

echo "  Building gdt-server-native..."
docker build -f native.Dockerfile -t gdt-server-native:latest .

echo ""
echo "=========================================="
echo "Build complete!"
echo "=========================================="
echo ""
echo "Built images:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep gdt-server
echo ""

