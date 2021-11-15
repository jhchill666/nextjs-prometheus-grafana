Monitor NextJS with Prometheus/Grafana
---

To build the image:
```
docker-compose up --build 
```

Otherwise to start prebuilt image:
```
docker-compose --env-file .env -f ./performance/docker-compose.yml up
```

## Grafana

Have enabled anonymous auth, so the following url should take you straight in

`http://localhost:3001`

## Prometheus

`http://localhost:9090/`

## Not running on Mac?

Not sure what this would need to be on your comp @Serle, but the following line current is mac specific:

*./performance/prometheus/prometheus.yml*
```
- targets: ["docker.for.mac.host.internal:3000"]
```
