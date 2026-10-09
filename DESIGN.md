# Design Brief

## Direction

Flash Peak Arena — a dark-first, gold-lit competitive home base for the WNU CLUB eSport team, built around biru dongker depth and tournament energy.

## Tone

Gahar (tough) and high-stakes — deep navy-black arena surfaces, hard gold accents, angular edges; competitive and confident, never soft or corporate.

## Differentiation

A gold-on-navy "arena lighting" system: gold glow on active elements, layered navy radial atmosphere, and a subtle hex-grid texture that reads as Flash Peak terrain without any imagery.

## Color Palette

| Token       | OKLCH         | Role                                          |
| ----------- | ------------- | --------------------------------------------- |
| background  | 0.14 0.035 264 | biru dongker near-black arena canvas (dark)  |
| foreground  | 0.96 0.012 258 | near-white text with a cool navy cast        |
| card        | 0.19 0.045 264 | raised player cards, panels, nav surfaces    |
| primary     | 0.8 0.15 82    | WNU gold — CTAs, active states, glow         |
| accent      | 0.72 0.18 52   | orange — secondary highlights, badges        |
| cyan        | 0.62 0.17 258  | electric biru dongker for metrics and tags   |
| muted       | 0.23 0.045 264 | subdued fills, inputs, alternating bands     |
| success     | 0.72 0.16 155  | online / joined states                        |
| warning     | 0.82 0.16 85   | attention states                              |
| destructive | 0.6 0.22 25    | errors and destructive actions                |

## Typography

- Display: Space Grotesk — hero wordmark, section headings, player names, numerals
- Body: Plus Jakarta Sans — paragraphs, nav links, labels, buttons
- Mono: Geist Mono — UIDs, tags, and technical metadata
- Scale: hero `text-5xl md:text-7xl font-bold tracking-tight`, h2 `text-3xl md:text-5xl font-bold tracking-tight`, label `text-sm font-semibold tracking-widest uppercase`, body `text-base md:text-lg`

## Elevation & Depth

Dark-first layered surfaces (background < card < popover) with deep soft shadows and a gold ring shadow for active/hover states; depth comes from navy layer contrast plus radial arena lighting, not heavy borders.

## Structural Zones

| Zone    | Background           | Border     | Notes                                            |
| ------- | -------------------- | ---------- | ------------------------------------------------ |
| Header  | `bg-card/80` glass   | `border-b` | sticky, blur, gold wordmark, gold active link    |
| Content | `bg-arena`           | —          | alternate `bg-muted/30` sections, hex-grid tint  |
| Footer  | `bg-muted/40`        | `border-t` | gold top hairline, muted contact links           |

## Spacing & Rhythm

Spacious arena sections (`py-20 md:py-28`), tight roster grid (`gap-5`), micro-spacing on badges/labels (`gap-1.5`); generous negative space makes gold accents land harder.

## Component Patterns

- Buttons: `rounded-md` (0.5rem), gold `bg-primary` with dark text for primary CTAs, `bg-gradient-primary` for hero, outline/ghost for secondary; hover adds `shadow-gold` and lifts
- Cards: `rounded-lg` `bg-card` `border-border`; player cards get a gold top edge and hover `shadow-gold` + slight lift
- Badges: pill `rounded-full`, gold for Captain, cyan for role/UID, muted for "Belum tersedia"

## Motion

- Entrance: `animate-fade-in` / `animate-slide-up` staggered 0.5–0.6s cubic-bezier, hero first
- Hover: `transition-smooth` 0.3s; cards lift and gain gold glow, buttons brighten
- Decorative: `glow-pulse` for ambient gold orbs, `pulse-gold` for live/CTA emphasis, `shimmer` for skeletons, `float` for accents

## Constraints

- Dark mode is the only mode; no light inversion required
- Tokens only — no raw hex/rgb or arbitrary Tailwind color classes in components
- 3 core accents max (gold, orange, electric navy); semantic states reserved
- Roster is the centerpiece; no news page or media gallery zones (out of scope)

## Signature Detail

The gold "arena glow" — a soft gold text-shadow plus hex-grid navy background that lights the hero and player cards, giving WNU CLUB a single recognizable competitive signature.
