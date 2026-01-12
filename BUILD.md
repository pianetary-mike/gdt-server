# Building gdt-server Docker Images

This guide explains how to build the `gdt-server` Docker images, including `gdt-server-native` which is needed for `olca-ipc-container`.

## Prerequisites

- Docker installed and running
- Maven installed (for compiling Java)
- The `gdt-server` repository cloned locally

## Quick Build

Run the automated build script:

```bash
cd /Users/mike/dev/gdt-server
./build-images.sh
```

This will:
1. Compile the Java application with Maven
2. Download native libraries
3. Build three Docker images: `gdt-server-app`, `gdt-server-lib`, and `gdt-server-native`

## Manual Build Steps

If you prefer to run the commands manually:

### Step 1: Compile Java Application
```bash
cd /Users/mike/dev/gdt-server
mvn clean package -DskipTests=true
```

### Step 2: Download Native Libraries
```bash
mkdir -p build/native/olca-native/0.0.1/x64
curl -L https://github.com/GreenDelta/olca-native/releases/download/v0.0.1/olca-native-umfpack-linux-x64.zip -o build/native_linux_x64.zip
unzip build/native_linux_x64.zip -d build/native/olca-native/0.0.1/x64/
rm build/native_linux_x64.zip
```

### Step 3: Build Docker Images
```bash
# Build gdt-server-app
docker build -f app.Dockerfile -t gdt-server-app:latest .

# Build gdt-server-lib
docker build -f lib.Dockerfile -t gdt-server-lib:latest .

# Build gdt-server-native
docker build -f native.Dockerfile -t gdt-server-native:latest .
```

### Step 4: Build Complete gdt-server (Optional)
If you want to build the complete `gdt-server` image that combines all three:

```bash
docker build -t gdt-server .
```

## What Gets Built

The build process creates three Docker images:

- `gdt-server-app`: Contains the server application JAR
- `gdt-server-lib`: Contains Java dependencies
- `gdt-server-native`: Contains native calculation libraries (this is what olca-ipc-container needs)

## Using the Built Image

Once `gdt-server-native:latest` is built, you can use it in `olca-ipc-container`:

```bash
cd /Users/mike/dev/olca-ipc-container
docker build --pull=never -t olca-ipc-server:latest .
```

The `--pull=never` flag ensures Docker uses your local `gdt-server-native:latest` image instead of trying to pull it from a registry.

## Troubleshooting

- **Maven build fails**: Make sure you have Java 21 installed and `olca-core` 2.6.0 is available in your Maven repository
- **Docker images not created**: Check that Docker is running and you have permissions to use it
- **Native libraries not found**: The build downloads them automatically from GitHub releases
