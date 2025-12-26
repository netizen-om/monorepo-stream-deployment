import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@repo/db"],
  eslint: {
    ignoreDuringBuilds: true,
  },
};

export default nextConfig;