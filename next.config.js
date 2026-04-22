/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: [],
  },
  compress: true,
};

module.exports = {
  turbopack: {
    root: __dirname,
  },
};


