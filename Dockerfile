FROM go:1.16
WORKDIR /app
ADD . /app
RUN go build -o main
CMD ["/main"]
