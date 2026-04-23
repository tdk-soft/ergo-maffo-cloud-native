import Link from "next/link";
import Image from "next/image";

// Define the shape of the props for better type safety
interface ServiceCardProps {
  title: string;
  subtitle: string;
  image: string;
  description: string;
  slug: string;
}

export default function ServiceCard({
  title,
  subtitle,
  image,
  description,
  slug,
}: ServiceCardProps) {
  return (
    <Link href={`/leistungen/${slug}`}>
      <div className="bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition cursor-pointer h-full">
        <div className="relative w-full h-48">
          <Image 
            src={image} 
            alt={title} 
            fill
            className="object-cover"
            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
          />
        </div>

        <div className="p-6">
          <h3 className="text-xl font-bold text-gray-900">{title}</h3>
          <p className="text-sm text-blue-600 font-medium mb-2">{subtitle}</p>
          <p className="text-sm text-gray-600 line-clamp-3">{description}</p>
        </div>
      </div>
    </Link>
  );
}