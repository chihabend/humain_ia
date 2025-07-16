import { saveAs } from "file-saver";
import { Document, Packer, Paragraph } from "docx";

export default function DownloadDocxButton({ text }: { text: string }) {
  const handleDownload = async () => {
    const doc = new Document({
      sections: [{ children: [new Paragraph(text)] }],
    });
    const blob = await Packer.toBlob(doc);
    saveAs(blob, "humanized.docx");
  };
  if (!text) return null;
  return (
    <button className="mt-4 bg-green-600 text-white px-4 py-2 rounded" onClick={handleDownload}>
      Télécharger en DOCX
    </button>
  );
} 