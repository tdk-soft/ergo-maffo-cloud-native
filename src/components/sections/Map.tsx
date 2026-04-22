export default function Map() {
  return (
    <section className="py-16 text-center">
      <h2 className="text-3xl font-bold">Unsere Praxis</h2>

      <div className="mt-6 max-w-4xl mx-auto">
        <iframe
          src="https://www.google.com/maps?q=Hildesheimer+Str.+15,+44143+Dortmund&output=embed"
          className="w-full h-[400px] rounded-xl"
          loading="lazy"
        ></iframe>
      </div>

      <p className="mt-4">
        📍 Hildesheimer Str. 15, 44143 Dortmund
      </p>
    </section>
  );
}