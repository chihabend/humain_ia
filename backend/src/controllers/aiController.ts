import { Request, Response } from "express";
import axios from "axios";
import History from "../models/History";
import jwt from "jsonwebtoken";

export const humanizeText = async (req: Request, res: Response) => {
  const { text, level, style, language } = req.body;
  if (!text || text.split(" ").length > 2000) {
    return res.status(400).json({ error: "Texte manquant ou trop long (max 2000 mots)" });
  }
  try {
    const response = await axios.post("http://localhost:8000/humanize", { text });
    // Sauvegarde historique si JWT présent
    const token = req.headers.authorization?.split(" ")[1];
    let userId = null;
    if (token) {
      try {
        userId = (jwt.verify(token, process.env.JWT_SECRET!) as any).userId;
      } catch {}
    }
    if (userId) {
      await History.create({ user: userId, input: text, output: response.data.humanized });
    }
    res.json({ original: text, humanized: response.data.humanized });
  } catch (err) {
    res.status(500).json({ error: "Erreur du modèle IA" });
  }
}; 