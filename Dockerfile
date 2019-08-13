# Builder image
FROM alpine:3.10 AS builder

RUN apk add --no-cache --update \
        autoconf \
        automake \
        build-base \
        git \
        libaio-dev \
        libtool \
        pkgconf

RUN git clone https://github.com/akopytov/sysbench.git

WORKDIR /sysbench
RUN ./autogen.sh && \
    ./configure --without-mysql && \
    make -j && \
    make install


# Target image
FROM alpine:3.10

RUN apk add --no-cache --update libaio libgcc
COPY --from=builder /usr/local/share/sysbench /usr/local/share/sysbench
COPY --from=builder /usr/local/bin/sysbench   /usr/local/bin/sysbench

CMD ["/usr/local/bin/sysbench"]
