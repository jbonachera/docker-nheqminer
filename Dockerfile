FROM alpine
RUN apk -U add gcc make git boost-dev cmake g++ && \
    git clone --depth 1 -b Linux https://github.com/nicehash/nheqminer.git /usr/local/src/nheqminer
RUN cd /usr/local/src/nheqminer/cpu_xenoncat/Linux/asm/ && \
    sh assemble.sh && \
    cd ../../../Linux_cmake/nheqminer_cpu && \
    cmake . && \
    make -j $(nproc)
RUN chmod +x  /usr/local/src/nheqminer/Linux_cmake/nheqminer_cpu/nheqminer_cpu
RUN mv /usr/local/src/nheqminer/Linux_cmake/nheqminer_cpu/nheqminer_cpu /usr/local/bin/nheqminer_cpu

FROM alpine
RUN adduser  -S miner
RUN apk -U add boost bash && rm -rf /var/cache/apk
USER miner
COPY --from=0 /usr/local/bin/nheqminer_cpu /usr/local/bin/nheqminer_cpu
COPY entrypoint /sbin/entrypoint
ENTRYPOINT ["/sbin/entrypoint"]
