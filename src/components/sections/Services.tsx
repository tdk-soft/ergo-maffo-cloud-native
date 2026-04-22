const services = [
  "Neurologie",
  "Pädiatrie",
  "Geriatrie",
  "Handtherapie",
];

export default function Services() {
  return (
    <section className="py-16 text-center">
      <h2 className="text-3xl font-bold">Leistungen</h2>

      <div className="grid md:grid-cols-4 gap-6 mt-10 px-10">
        {services.map((s) => (
          <div
            key={s}
            className="p-6 bg-white rounded-xl shadow-md"
          >
            <h3 className="font-semibold">{s}</h3>
          </div>
        ))}
      </div>
    </section>
  );
}