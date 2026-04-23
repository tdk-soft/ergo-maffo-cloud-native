
import { services } from "@/data/services";
import ServiceCard from "@/components/ui/ServiceCard";

export default function Leistungen() {
  return (
    <main className="p-10">
      <h1 className="text-3xl font-bold text-center">
        Unsere Leistungen
      </h1>

      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mt-10">
        {services.map((service, index) => (
          <ServiceCard key={index} {...service} />
        ))}
      </div>
    </main>
  );
}