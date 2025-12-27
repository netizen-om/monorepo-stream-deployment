import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@repo/db"],
  eslint: {
    ignoreDuringBuilds: true,
  },
  output: "standalone"
};

export default nextConfig;