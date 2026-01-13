FROM alpine:latest AS builder
COPY build/native /tmp/native

# Flatten the deeply nested .so files to /app/native/
# NativeLib expects: /app/native/olca-native/VERSION/PLATFORM/*.so
RUN mkdir -p /app/native/olca-native/0.0.1/x64 && \
    find /tmp/native -name "*.so*" -exec cp {} /app/native/olca-native/0.0.1/x64/ \; && \
    find /tmp/native -name "*.json" -exec cp {} /app/native/olca-native/0.0.1/x64/ \; && \
    find /tmp/native -name "LICENSE*" -exec cp {} /app/native/olca-native/0.0.1/x64/ \; && \
    ls -la /app/native/olca-native/0.0.1/x64/

FROM scratch
COPY --from=builder /app/native /app/native
COPY licenses/native.txt /app/THIRDPARTY_README
