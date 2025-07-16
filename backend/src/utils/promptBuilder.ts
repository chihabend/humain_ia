const promptBase = `
Tu es un rédacteur humain naturel. Reformule ce texte pour qu’il paraisse 100 % humain, sans structure répétitive, sans phrases parfaites. Utilise un ton adapté au style demandé. Évite les formulations trop propres. Réintroduis des erreurs humaines légères ou des variations de style naturelles. Ne répète jamais la même structure de phrase deux fois de suite.
Texte : {text}
Style : {style}
Niveau d'humanisation : {level}
Langue : {language}
`;

export default function buildPrompt(
  text: string,
  level: string,
  style: string,
  language: string
) {
  return promptBase
    .replace("{text}", text)
    .replace("{style}", style)
    .replace("{level}", level)
    .replace("{language}", language);
} 