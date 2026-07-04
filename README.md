# Trade Forge Waitlist (Astro)

Static waitlist/holding site for Trade Forge, deployed with GitHub Pages.

## Stack

- Astro (static output)
- GitHub Actions for CI deploy
- GitHub Pages with custom domain: tradeforge.uk

## Project Layout

- `src/pages/index.astro`: Main waitlist page
- `src/styles/waitlist.css`: Site styles
- `src/config/site.ts`: Central site config (brand, SEO, WhatsApp CTA)
- `public/scripts/animations.js`: Client-side reveal animations
- `public/CNAME`: GitHub Pages custom domain binding
- `.github/workflows/deploy-pages.yml`: Pages deployment workflow
- `archive/waitlist.legacy.html`: Archived pre-Astro standalone HTML page

## Local Development

Requirements:

- Node.js 20.19.5+
- npm 10+

Install dependencies:

```bash
npm install
```

Start the dev server:

```bash
npm run dev
```

Default local URL:

- http://localhost:4321

## Production Build

Build static assets:

```bash
npm run build
```

Preview built output locally:

```bash
npm run preview
```

## Content and Config Updates

Update waitlist settings in `src/config/site.ts`:

- `brandName`
- `siteUrl`
- `whatsappNumber`
- `whatsappMessage`
- `seo.title`
- `seo.description`

## Deployment (GitHub Pages)

Deploys are triggered manually via `.github/workflows/deploy-pages.yml` (`workflow_dispatch`).

This repo should be a **project site** (not your user-site blog repo). Your existing blog at `<your-github-username>.github.io` can stay as-is.

GitHub repo settings:

1. Go to Settings > Pages.
2. Set Source to GitHub Actions.
3. Set custom domain to `tradeforge.uk`.
4. Enable Enforce HTTPS after DNS propagation.

DNS (at your registrar):

- Type: A or ALIAS/ANAME (root/apex domain setup for `tradeforge.uk` with your DNS provider)
- Host: `@`
- Target: GitHub Pages apex records (or your provider's ALIAS target for GitHub Pages)

Why this still works with your blog:

- GitHub routes by hostname, and `tradeforge.uk` is mapped by this repo's `public/CNAME` file.
- Your blog remains on its own hostname/repository.

If you ever deploy this without a custom domain (plain project URL), use:

- URL: `https://<your-github-username>.github.io/<repo-name>/`
- Astro `base`: `/<repo-name>/`

## Notes

- Keep this repo focused on waitlist/marketing only.
- Product/platform app remains in the separate Next.js repository.
