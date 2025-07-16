const levels = [
  { value: "light", label: "Léger" },
  { value: "medium", label: "Moyen" },
  { value: "strong", label: "Fort" },
];
export default function LevelSelector({ value, onChange }: any) {
  return (
    <select value={value} onChange={e => onChange(e.target.value)} className="border rounded px-2">
      {levels.map(l => <option key={l.value} value={l.value}>{l.label}</option>)}
    </select>
  );
} 