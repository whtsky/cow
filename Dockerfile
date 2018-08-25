FROM golang AS build-env
RUN mkdir -p /go/src/github.com/whtsky/cow
ADD . /go/src/github.com/whtsky/cow
WORKDIR /go/src/github.com/whtsky/cow
RUN go get .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o cow .

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /go/src/github.com/whtsky/cow/cow /app/cow
COPY --from=build-env /go/src/github.com/whtsky/cow/doc/sample-config/rc /etc/cow/rc
CMD ["/app/cow", "-rc", "/etc/cow/rc"]