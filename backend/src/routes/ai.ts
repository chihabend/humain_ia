import { Router } from "express";
import { humanizeText } from "../controllers/aiController";
// import auth from "../middlewares/auth";

const router = Router();

router.post("/humanize", /*auth,*/ humanizeText);

export default router; 