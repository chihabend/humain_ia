import React from "react";

export default function Dashboard() {
  // Ces stats seraient récupérées via une API backend réelle
  const stats = {
    totalRequests: 1234,
    uniqueUsers: 87,
    mostUsedStyle: "neutre",
    avgWords: 57,
    avgScoreBefore: 0.82,
    avgScoreAfter: 0.23,
  };
  return (
    <div className="p-8 max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Dashboard Admin</h1>
      <div className="grid grid-cols-2 gap-6">
        <div className="bg-white rounded shadow p-4">
          <div className="text-gray-500">Requêtes totales</div>
          <div className="text-2xl font-bold">{stats.totalRequests}</div>
        </div>
        <div className="bg-white rounded shadow p-4">
          <div className="text-gray-500">Utilisateurs uniques</div>
          <div className="text-2xl font-bold">{stats.uniqueUsers}</div>
        </div>
        <div className="bg-white rounded shadow p-4">
          <div className="text-gray-500">Style le plus utilisé</div>
          <div className="text-2xl font-bold">{stats.mostUsedStyle}</div>
        </div>
        <div className="bg-white rounded shadow p-4">
          <div className="text-gray-500">Mots moyens</div>
          <div className="text-2xl font-bold">{stats.avgWords}</div>
        </div>
        <div className="bg-white rounded shadow p-4">
          <div className="text-gray-500">Score IA avant (moyen)</div>
          <div className="text-2xl font-bold">{(stats.avgScoreBefore*100).toFixed(1)}%</div>
        </div>
        <div className="bg-white rounded shadow p-4">
          <div className="text-gray-500">Score IA après (moyen)</div>
          <div className="text-2xl font-bold">{(stats.avgScoreAfter*100).toFixed(1)}%</div>
        </div>
      </div>
    </div>
  );
} 