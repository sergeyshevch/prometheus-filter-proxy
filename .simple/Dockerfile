FROM public.ecr.aws/docker/library/golang:1.18-alpine3.15 as builder

RUN apk update && apk add --no-cache git

WORKDIR /src

ARG CI_JOB_TOKEN

RUN go env -w GOPRIVATE="gitlab.fstr.app" && \
    echo -e "machine gitlab.fstr.app\nlogin gitlab-ci-token\npassword ${CI_JOB_TOKEN}" > ~/.netrc

COPY ["go.mod", "go.sum", "./"]
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' -a \
    -o /prometheus-filter-proxy .

FROM gcr.io/distroless/static AS final

LABEL maintainer="shevchenko@simple.life"
USER nonroot:nonroot

COPY --from=builder --chown=nonroot:nonroot /prometheus-filter-proxy /prometheus-filter-proxy

ENTRYPOINT ["/prometheus-filter-proxy"]