import Link from "next/link";

export default function ServiceCard({
  title,
  subtitle,
  image,
  description,
  slug,
}: any) {
  return (
    <Link href={`/leistungen/${slug}`}>
      <div className="bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition cursor-pointer">
        <img src={image} alt={title} className="w-full h-48 object-cover" />

        <div className="p-6">
          <h3 className="text-xl font-bold">{title}</h3>
          <p className="text-sm text-gray-500">{subtitle}</p>
        </div>
      </div>
    </Link>
  );
}