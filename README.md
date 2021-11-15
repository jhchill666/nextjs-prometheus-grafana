Monitor NextJS with Prometheus/Grafana
---

You'll need to add the metrics exporters to the `frontend` repo to get this working.  To do this there are a couple of steps:

1.  Install prometheus metrics exporters in frontend project:
```
yarn add prom-client@14.0.1 prometheus-gc-stats@0.6.3
```

2. Copy the `./metrics.ts` file to `./src/pages/api` in your `frontend` project.

3. Add the following env var to enable the metrics:

```
NEXT_PUBLIC_ENABLE_PROMETHEUS=true
```

4. Build this image:


This all runs against your local instance of the frontend app on port 3000, and will scrape internal metrics from NextJS.

```
docker-compose up --build 
```

## Grafana

Yoou should now see Grafana on the following url, and my use `admin` as user and pass to login for first time:

`http://localhost:3001/d/3_8qvI57k/frontend-allocations?orgId=1&refresh=5s`

## Prometheus

You should also see prometheus on port 9090.  

`http://localhost:9090/`

## Not running on Mac?

Not sure what this would need to be on your comp @Serle, but the following line current is mac specific:

*./performance/prometheus/prometheus.yml*
```
- targets: ["docker.for.mac.host.internal:3000"]
```

From reading, think this needs to be `127.0.0.1` on Linux but haven't tried.