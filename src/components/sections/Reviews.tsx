const reviews = [
  {
    name: "Maria K.",
    text: "Sehr professionelle Betreuung. Hausbesuch war sehr hilfreich.",
  },
  {
    name: "Thomas L.",
    text: "Kompetent und freundlich. Sehr empfehlenswert.",
  },
  {
    name: "Sophie W.",
    text: "Meine Tochter wurde hervorragend betreut.",
  },
];

export default function Reviews() {
  return (
    <section className="bg-gray-100 py-16 text-center">
      <h2 className="text-3xl font-bold">Patientenbewertungen</h2>

      <div className="grid md:grid-cols-3 gap-6 mt-10 px-10">
        {reviews.map((r, i) => (
          <div key={i} className="bg-white p-6 rounded-xl shadow-md">
            <p>"{r.text}"</p>
            <p className="mt-4 font-semibold">{r.name}</p>
          </div>
        ))}
      </div>
    </section>
  );
}