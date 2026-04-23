// Define an interface for the review object
interface Review {
  name: string;
  text: string;
}

const reviews: Review[] = [
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
      <h2 className="text-3xl font-bold text-gray-900">Patientenbewertungen</h2>

      <div className="grid md:grid-cols-3 gap-6 mt-10 px-10">
        {reviews.map((r, i) => (
          <div key={i} className="bg-white p-6 rounded-xl shadow-md flex flex-col justify-between">
            {/* Use &quot; instead of raw " to satisfy ESLint */}
            <p className="text-gray-700 italic">
              &quot;{r.text}&quot;
            </p>
            <p className="mt-4 font-semibold text-blue-600">{r.name}</p>
          </div>
        ))}
      </div>
    </section>
  );
}