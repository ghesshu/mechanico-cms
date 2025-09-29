export default ({ env }) => ({
  host: env("HOST", "0.0.0.0"),
  port: env.int("PORT", 1337),
  // 🔑 Crucial for internal security and token handling
  app: {
    keys: env.array("APP_KEYS"),
  },

  // 🌐 CRUCIAL: Absolute public URL for your deployed API/Admin
  // Used for redirects, password resets, and admin assets.
  url: env("URL"),

  // 🔄 CRUCIAL: Enable proxy support if you are behind a load balancer (NGINX, AWS, etc.)
  // This allows Strapi to trust headers like 'X-Forwarded-Proto: https'
  proxy: env.bool("IS_PROXIED", false),
});
