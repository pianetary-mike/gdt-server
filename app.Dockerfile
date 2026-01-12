FROM scratch
COPY target/gdt-server.jar /app/gdt-server.jar
COPY run.sh /app/run.sh
COPY LICENSE /app/LICENSE
