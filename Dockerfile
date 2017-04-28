FROM golang:1.8.1 as BUILD
ARG version=v1.6.0-x3

RUN mkdir -p /go/src/github.com/hairyhenderson \
 && git clone https://github.com/rhuss/gomplate.git /go/src/github.com/hairyhenderson/gomplate
 
WORKDIR /go/src/github.com/hairyhenderson/gomplate 
ENV CGO_ENABLED=0
RUN git checkout tags/${version} \
 && make build

FROM scratch
COPY --from=BUILD /go/src/github.com/hairyhenderson/gomplate/bin/gomplate /gomplate
WORKDIR /
ENTRYPOINT [ "/gomplate" ]
CMD [ "--input-dir",  "/in",    \
      "--output-dir", "/out",   \
      "--datasource", "/params" ]
