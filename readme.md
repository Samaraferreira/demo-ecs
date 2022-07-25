#### Send 50000 HTTP requests at a rate of 300 requests per second with a timeout of 2s:
httperf --server=url --rate=300 --num-conns=50000 --timeout 2
