FROM scratch
COPY target/lib /app/lib
COPY licenses/lib.txt /app/THIRDPARTY_README

