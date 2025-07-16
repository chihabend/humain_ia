import { useState } from "react";
import TextArea from "../components/TextArea";
import StatsPanel from "../components/StatsPanel";
import LevelSelector from "../components/LevelSelector";
import StyleSelector from "../components/StyleSelector";
import ComparePanel from "../components/ComparePanel";
import DownloadDocxButton from "../components/DownloadDocxButton";
import useHumanize from "../hooks/useHumanize";

export default function Home() {
  const [input, setInput] = useState("");
  const [level, setLevel] = useState("medium");
  const [style, setStyle] = useState("neutre");
  const [language, setLanguage] = useState("FR");
  const { mutate, data, isLoading } = useHumanize();

  return (
    <div className="flex flex-col items-center py-8">
      <h1 className="text-3xl font-bold mb-6">HumanizeMyText</h1>
      <div className="flex gap-8 w-full max-w-5xl">
        <TextArea value={input} onChange={setInput} label="Texte IA" />
        <TextArea value={data?.humanized || ""} readOnly label="Texte humanisé" />
      </div>
      <div className="flex gap-4 mt-4">
        <LevelSelector value={level} onChange={setLevel} />
        <StyleSelector value={style} onChange={setStyle} />
        <select value={language} onChange={e => setLanguage(e.target.value)} className="border rounded px-2">
          <option value="FR">Français</option>
          <option value="EN">English</option>
          <option value="ES">Español</option>
          <option value="DE">Deutsch</option>
        </select>
        <button
          className="bg-blue-600 text-white px-6 py-2 rounded font-bold"
          onClick={() => mutate({ text: input, level, style, language })}
          disabled={isLoading || !input}
        >
          {isLoading ? "Humanisation..." : "Humaniser"}
        </button>
      </div>
      <StatsPanel stats={data?.stats} />
      <ComparePanel before={input} after={data?.humanized || ""} />
      <DownloadDocxButton text={data?.humanized || ""} />
    </div>
  );
} 