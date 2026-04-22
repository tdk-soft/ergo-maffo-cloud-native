import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Termin buchen | Ergotherapie Praxis Maffo",
  description:
    "Vereinbaren Sie einfach online einen Termin für einen Hausbesuch.",
};

export default function TerminPage() {
  return (
    <div className="h-screen">
      <iframe
        src="https://calendly.com/TON-LIEN"
        className="w-full h-full"
      />
    </div>
  );
}