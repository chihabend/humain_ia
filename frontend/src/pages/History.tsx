import React from "react";

const mockHistory = [
  { date: "2024-07-08", input: "Texte IA exemple", output: "Texte humanisé exemple" },
  { date: "2024-07-07", input: "Another AI text", output: "A more human version" },
];

export default function History() {
  return (
    <div className="p-8 max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">Historique</h1>
      <table className="w-full bg-white rounded shadow">
        <thead>
          <tr className="bg-gray-100">
            <th className="p-2 text-left">Date</th>
            <th className="p-2 text-left">Entrée</th>
            <th className="p-2 text-left">Sortie</th>
          </tr>
        </thead>
        <tbody>
          {mockHistory.map((item, i) => (
            <tr key={i} className="border-t">
              <td className="p-2">{item.date}</td>
              <td className="p-2">{item.input}</td>
              <td className="p-2">{item.output}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
} 