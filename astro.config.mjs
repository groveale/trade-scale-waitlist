import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://waitlist.tradeforge.uk',
  base: '/',
  output: 'static',
  vite: {
    server: {
      allowedHosts: ['elephant-doorframe-devalue.ngrok-free.dev']
    }
  }
});
