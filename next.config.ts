import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* Enable standalone output to significantly reduce Docker image size 
     by only including necessary files for production. */
  output: 'standalone',
};

export default nextConfig;