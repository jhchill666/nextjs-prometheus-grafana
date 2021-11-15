/* eslint-disable no-restricted-syntax */
import type { NextApiRequest, NextApiResponse } from "next"

let registry

if (process.env.NEXT_PUBLIC_ENABLE_PROMETHEUS === "true") {
  const { collectDefaultMetrics, Registry } = require("prom-client")
  const gcStats = require("prometheus-gc-stats")

  registry = new Registry()

  // Set prom-client to collect default metrics
  collectDefaultMetrics({
    register: registry,
  })

  // Set prometheus-gc-stats to collect GC stats
  gcStats(registry)()
}

// create a global registry

export default async (
  _: NextApiRequest,
  res: NextApiResponse
): Promise<void> => {
  if (process.env.NEXT_PUBLIC_ENABLE_PROMETHEUS === "true") {
    res.setHeader("Content-type", registry.contentType)
    res.send(await registry.metrics())
    return
  }

  res.status(200)
  return res.end()
}
