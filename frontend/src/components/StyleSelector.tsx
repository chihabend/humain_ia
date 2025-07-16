const styles = [
  { value: "academique", label: "Académique" },
  { value: "blog", label: "Blog" },
  { value: "jeune", label: "Jeune" },
  { value: "neutre", label: "Neutre" },
  { value: "franc_parle", label: "Franc parlé" },
];
export default function StyleSelector({ value, onChange }: any) {
  return (
    <select value={value} onChange={e => onChange(e.target.value)} className="border rounded px-2">
      {styles.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
    </select>
  );
} 