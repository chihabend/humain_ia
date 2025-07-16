import { Schema, model, Types } from "mongoose";

const historySchema = new Schema({
  user: { type: Types.ObjectId, ref: "User", required: true },
  input: String,
  output: String,
  date: { type: Date, default: Date.now }
});

export default model("History", historySchema); 