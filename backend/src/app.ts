import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import mongoose from "mongoose";
import aiRoutes from "./routes/ai";
import rateLimit from "./middlewares/rateLimit";
import authRoutes from "./routes/auth";
import historyRoutes from "./routes/history";
import metricsRouter from "./metrics";

dotenv.config();

mongoose.connect(process.env.MONGO_URI!);

const app = express();
app.use(cors());
app.use(express.json());
app.use(rateLimit);

app.use("/ai", aiRoutes);
app.use("/auth", authRoutes);
app.use("/history", historyRoutes);
app.use("/metrics", metricsRouter);

export default app; 