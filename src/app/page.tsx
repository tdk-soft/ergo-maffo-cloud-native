import Hero from "@/components/sections/Hero";
import Services from "@/components/sections/Services";
import About from "@/components/sections/About";
import Contact from "@/components/sections/Contact";
import Reviews from "@/components/sections/Reviews";
import Map from "@/components/sections/Map";


const jsonLd = {
  "@context": "https://schema.org",
  "@type": "MedicalBusiness",
  name: "Ergotherapie Praxis Maffo",
  address: {
    "@type": "PostalAddress",
    streetAddress: "Hildesheimer Str. 15",
    addressLocality: "Dortmund",
    postalCode: "44143",
    addressCountry: "DE",
  },
  telephone: "+49 231 96733160",
  url: "https://ergo.tdksoftconsulting.de",
};

export default function Home() {
  return (
    <>
      {/* SEO STRUCTURED DATA */}
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <main>
        <Hero />
        
        {/* 🔥 AJOUT IMPORTANT */}
        <Reviews /> 
        <Map />
        <Contact />
      </main>
    </>
  );
}