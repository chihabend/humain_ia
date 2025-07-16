import { useMutation } from "@tanstack/react-query";
import axios from "axios";

export default function useHumanize() {
  return useMutation({
    mutationFn: async ({ text, level, style, language }: any) => {
      const res = await axios.post("/api/ai/humanize", { text, level, style, language });
      return res.data;
    },
  });
} 