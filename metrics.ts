/* eslint-disable no-restricted-syntax */
import type { NextApiRequest, NextApiResponse } from "next"
import { collectDefaultMetrics, Registry } from "prom-client"
import gcStats from "prometheus-gc-stats"

// create a global registry
const registry = new Registry()

// Set prom-client to collect default metrics
collectDefaultMetrics({
  register: registry,
})

// Set prometheus-gc-stats to collect GC stats
gcStats(registry)()

export default async (
  _: NextApiRequest,
  res: NextApiResponse
): Promise<void> => {
  res.setHeader("Content-type", registry.contentType)
  res.send(await registry.metrics())
}
