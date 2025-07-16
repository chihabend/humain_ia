import rateLimit from "express-rate-limit";

export default rateLimit({
  windowMs: 60 * 60 * 1000, // 1h
  max: 50, // 50 requêtes/h
  message: "Trop de requêtes, réessayez plus tard.",
}); 