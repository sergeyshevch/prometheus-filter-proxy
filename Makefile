

all:
	go build
	./prometheus-filter-proxy --proxy.listen-addr 0.0.0.0:8888 --upstream.addr vmselect.fstr.app --upstream.prefix-path /select/0/prometheus
