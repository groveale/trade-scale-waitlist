import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://tradeforge.uk',
  base: '/',
  output: 'static',
  integrations: [sitemap()],
  vite: {
    server: {
      allowedHosts: ['elephant-doorframe-devalue.ngrok-free.dev']
    }
  }
});
