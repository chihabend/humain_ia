type Props = {
  value: string;
  onChange?: (v: string) => void;
  label?: string;
  readOnly?: boolean;
};
export default function TextArea({ value, onChange, label, readOnly }: Props) {
  return (
    <div className="flex flex-col w-1/2">
      {label && <label className="mb-1 font-semibold">{label}</label>}
      <textarea
        className="border rounded p-2 min-h-[200px] resize-vertical"
        value={value}
        onChange={e => onChange?.(e.target.value)}
        readOnly={readOnly}
      />
    </div>
  );
} 