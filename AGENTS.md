# Project Guidance

## User Preferences

- Skema warna: Biru Dongker/Navy, Hitam, Emas/Oranye khas logo WNU CLUB
- Nuansa modern, gahar, kompetitif dengan sentuhan efek visual khas game Flash Peak
- Menu navigasi: Home, Roster, TikTok, Join Us, Contact
- Nomor WhatsApp Admin: +62 831-8346-8485
- Akun TikTok resmi: WNU CLUB
- Bahasa konten: Indonesia
- Logo resmi WNU CLUB dipakai di header (src/frontend/public/assets/images/wnu-club-logo.png)

## Verified Commands

- **typecheck**: `pnpm typecheck`
- **fix**: `pnpm fix`
- **build**: `pnpm build`

## Learnings

- The app is a single-page WNU CLUB eSport site: App.tsx renders AppLayout wrapping LandingPage with no router.
- Roster data, WhatsApp draft URL, and TikTok URL live in src/frontend/src/lib/constants.ts.
- The frontend test suite is Vitest + React Testing Library under src/frontend/src/__tests__/; run it with pnpm --dir app test.
- The project uses Tailwind v3.4.17, so only colors registered in tailwind.config.js generate utilities; the @theme block in index.css is v4 syntax and is ignored.
- Local preflight passed: the landing page loads with hero title/tagline, sticky navbar smooth-scrolls to Roster (9 cards, ILHAMSYAH Captain, Diki UID 'Belum tersedia', placeholder photos, gold/navy frames), TikTok, Join Us, and Contact sections; mobile hamburger opens and closes; footer shows admin contact and 2026 copyright.
- The header brand mark is now an <img src='/assets/images/wnu-club-logo.png'> in NavBar.tsx, replacing the old text-only 'WNU' square badge.
- TEAM_STATS in src/frontend/src/lib/constants.ts drives the hero stat grid in LandingPage.tsx; the grid column count must match the array length.
