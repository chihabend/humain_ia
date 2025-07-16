import { Router } from "express";
import History from "../models/History";
import jwt from "jsonwebtoken";

const router = Router();

router.get("/", async (req, res) => {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Non autorisé" });
  let userId;
  try {
    userId = (jwt.verify(token, process.env.JWT_SECRET!) as any).userId;
  } catch {
    return res.status(401).json({ error: "Token invalide" });
  }
  const history = await History.find({ user: userId }).sort({ date: -1 }).limit(20);
  res.json(history);
});

export default router; 