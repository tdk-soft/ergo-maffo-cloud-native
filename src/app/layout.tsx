import "./globals.css";
import Navbar from "@/components/layout/Navbar";
import Footer from "@/components/layout/Footer";
import type { Metadata } from "next";
import WhatsAppButton from "@/components/layout/WhatsAppButton";


export const metadata: Metadata = {
  title: "Ergotherapie Praxis Maffo | Hausbesuche in Dortmund",
  description:
    "Ergotherapie Praxis Maffo bietet individuelle Therapie für Kinder und Erwachsene in Dortmund. Hausbesuche möglich. Jetzt Termin vereinbaren.",
  keywords: [
    "Ergotherapie Dortmund",
    "Hausbesuch Ergotherapie",
    "Ergotherapie Kinder",
    "Neurologie Therapie Dortmund",
  ],
  authors: [{ name: "Ergotherapie Praxis Maffo" }],
  openGraph: {
    title: "Ergotherapie Praxis Maffo",
    description:
      "Individuelle Ergotherapie bei Ihnen zu Hause in Dortmund.",
    url: "https://ergo.tdksoftconsulting.de",
    siteName: "Ergotherapie Praxis Maffo",
    locale: "de_DE",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="de">
      <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXX"/>
      <body className="bg-gray-50 text-gray-800">
        <Navbar />
        {children}
  
        <Footer />
        <WhatsAppButton />
      </body>
    </html>
  );
}