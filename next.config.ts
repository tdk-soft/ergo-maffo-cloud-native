import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* Indispensable pour Docker */
  output: 'standalone',
  
  /* Tes anciennes options du fichier .js */
  images: {
    domains: [],
  },
  compress: true,
};

export default nextConfig;