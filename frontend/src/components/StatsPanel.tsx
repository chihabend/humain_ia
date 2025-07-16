type Props = { stats?: { wordCount: number; scoreBefore: number; scoreAfter: number } };
export default function StatsPanel({ stats }: Props) {
  if (!stats) return null;
  return (
    <div className="mt-4 flex gap-6">
      <div>Mots : <b>{stats.wordCount}</b></div>
      <div>Score IA avant : <b>{(stats.scoreBefore * 100).toFixed(1)}%</b></div>
      <div>Score IA après : <b>{(stats.scoreAfter * 100).toFixed(1)}%</b></div>
    </div>
  );
} 