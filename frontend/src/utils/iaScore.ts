export function estimateIAScore(text: string): number {
  const avgSentenceLength = text.split(/[.!?]/).map(s => s.trim().split(" ").length).reduce((a, b) => a + b, 0) / (text.match(/[.!?]/g)?.length || 1);
  const uniqueWords = new Set(text.split(/\s+/)).size;
  const totalWords = text.split(/\s+/).length;
  const lexicalRichness = uniqueWords / totalWords;
  return Math.min(1, 0.5 + (avgSentenceLength > 18 ? 0.2 : 0) - (lexicalRichness > 0.6 ? 0.2 : 0));
} 