import Link from "next/link";

export default function Navbar() {
  return (
    <nav className="flex justify-between items-center p-5 bg-white shadow-md sticky top-0 z-50">
      <h1 className="font-bold text-xl">
        Ergotherapie Praxis Maffo
      </h1>

      <div className="space-x-6 hidden md:flex">
        <Link href="/">Start</Link>
        <Link href="/leistungen">Leistungen</Link>
        <Link href="/uber-mich">Über mich</Link>
        <Link href="/kontakt">Kontakt</Link>
      </div>

      <Link
        href="/termin"
        className="bg-green-600 text-white px-4 py-2 rounded-lg"
      >
        Termin buchen
      </Link>
    </nav>
  );
}