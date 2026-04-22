export default function WhatsAppButton() {
  return (
    <a
      href="https://wa.me/4923196733160"
      target="_blank"
      rel="noopener noreferrer"
      className="fixed bottom-6 right-6 z-50 flex items-center gap-2 bg-green-500 hover:bg-green-600 text-white px-4 py-3 rounded-full shadow-xl"
    >
      <span>💬</span>
      <span className="hidden md:block">WhatsApp</span>
    </a>
  );
}