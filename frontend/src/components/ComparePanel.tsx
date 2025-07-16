type Props = { before: string; after: string };
export default function ComparePanel({ before, after }: Props) {
  if (!before || !after) return null;
  return (
    <div className="mt-8 w-full max-w-5xl bg-white rounded shadow p-4">
      <h2 className="font-bold mb-2">Comparaison Avant / Après</h2>
      <div className="flex gap-4">
        <div className="w-1/2">
          <h3 className="text-sm font-semibold mb-1">Avant</h3>
          <div className="bg-gray-100 p-2 rounded">{before}</div>
        </div>
        <div className="w-1/2">
          <h3 className="text-sm font-semibold mb-1">Après</h3>
          <div className="bg-green-50 p-2 rounded">{after}</div>
        </div>
      </div>
    </div>
  );
} 