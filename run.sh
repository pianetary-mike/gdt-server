#!/bin/bash
java \
  -XX:MaxRAMPercentage=$JAVA_MAX_RAM_PERCENTAGE \
  -jar /app/gdt-server.jar \
  -data /app/data \
  -native /app/native \
  -static /app/static \
  "$@"

