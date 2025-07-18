import client from "prom-client";
import express from "express";

const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

const router = express.Router();

router.get("/", async (req, res) => {
  res.set("Content-Type", client.register.contentType);
  res.end(await client.register.metrics());
});

export default router; 