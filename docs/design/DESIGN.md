---
name: Nocturne Editorial
colors:
  surface: '#131317'
  surface-dim: '#131317'
  surface-bright: '#39393d'
  surface-container-lowest: '#0e0e12'
  surface-container-low: '#1b1b1f'
  surface-container: '#1f1f23'
  surface-container-high: '#2a2a2e'
  surface-container-highest: '#353439'
  on-surface: '#e4e1e7'
  on-surface-variant: '#d0c5af'
  inverse-surface: '#e4e1e7'
  inverse-on-surface: '#303034'
  outline: '#99907c'
  outline-variant: '#4d4635'
  surface-tint: '#e9c349'
  primary: '#f2ca50'
  on-primary: '#3c2f00'
  primary-container: '#d4af37'
  on-primary-container: '#554300'
  inverse-primary: '#735c00'
  secondary: '#e6b4ff'
  on-secondary: '#4f0077'
  secondary-container: '#6b1b99'
  on-secondary-container: '#dc9cff'
  tertiary: '#96e266'
  on-tertiary: '#153800'
  tertiary-container: '#7cc54d'
  on-tertiary-container: '#214f00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffe088'
  primary-fixed-dim: '#e9c349'
  on-primary-fixed: '#241a00'
  on-primary-fixed-variant: '#574500'
  secondary-fixed: '#f5d9ff'
  secondary-fixed-dim: '#e6b4ff'
  on-secondary-fixed: '#30004a'
  on-secondary-fixed-variant: '#6b1b99'
  tertiary-fixed: '#aaf778'
  tertiary-fixed-dim: '#8fda5f'
  on-tertiary-fixed: '#0a2100'
  on-tertiary-fixed-variant: '#225100'
  background: '#131317'
  on-background: '#e4e1e7'
  surface-variant: '#353439'
  surface-base: '#121214'
  surface-raised: '#1C1C20'
  surface-elevated: '#26262C'
  border-subtle: '#2E2E36'
  text-parchment: '#F4EFEA'
  text-muted: '#9E9EA8'
  accent-brass-hover: '#E5C158'
typography:
  display-lg:
    fontFamily: Newsreader
    fontSize: 40px
    fontWeight: '400'
    lineHeight: 48px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Newsreader
    fontSize: 32px
    fontWeight: '400'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Newsreader
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Newsreader
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  headline-sm:
    fontFamily: Newsreader
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Newsreader
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: DM Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-sm:
    fontFamily: DM Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: DM Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: DM Sans
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 12px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  margin: 1rem
  margin-tablet: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system crafts an immersive, contemplative reading environment tailored for digital bibliophiles and collectors. Designed primarily around a nocturnal experience, it blends classical literary heritage with modern tactile digital interfaces. The visual language evokes the hush of a private library at midnight: deep charcoal backdrops, warm parchment-inspired type, and muted brass luminescence.

The aesthetic philosophy fuses **Editorial Refinement** with **Tactile Minimalism**:
- **Literary Depth:** High-contrast typographic tension pairing an authoritative, literary serif for titles and long-form prose with a crisp, neutral grotesque for functional instrumentation.
- **Ambient Focus:** Dark, desaturated surfaces ensure cover artwork and typographic passages command maximum visual attention without eye strain.
- **Craftsmanship:** Delicately illuminated surface containers, hairline borders, and subdued amber reflections substitute loud flat fills with subtle physical depth.

## Colors

The palette is engineered around low-luminance visual comfort, avoiding harsh pure black in favor of deep slate-charcoal gradations (`surface-base` `#121214` to `surface-elevated` `#26262C`). 

- **Primary (`#D4AF37` Muted Brass):** The signature accent color representing bookbindery foil, active reading highlights, primary actions, and navigational waypoints.
- **Secondary (`#8B3FB8` Akademia Imperial Amethyst):** Preserved from the brand lineage as an editorial accent for special collections, literary annotations, and premium tags.
- **Tertiary (`#71B943` Sage Leaf):** Used sparingly for progress bars, goal completions, and positive reading statistics.
- **Neutral (`#1A1A1E` Deep Slate):** The architectural bedrock from which all container surfaces, dividers, and scrims are constructed.

Text legibility prioritizes soft contrast over stark glare: titles and body copy use `#F4EFEA` (warm parchment), while meta-labels and inactive icons settle into `#9E9EA8`.

## Typography

Typographic structure relies on a deliberate balance of editorial serif storytelling and utilitarian sans-serif precision:

- **Newsreader** handles book titles, author credits, shelf headers, and long-form e-reader text. Its organic optical curves bring warmth and literary provenance to the dark display.
- **DM Sans** commands navigational labels, metrics, search inputs, chapter listings, and interactive components. Its clean geometric clarity prevents visual noise across dense mobile surfaces.

Body styles split functionally: `body-lg` is set in Newsreader for in-app excerpts and narrative annotations, whereas `body-md` and `body-sm` rely on DM Sans for UI clarity.

## Layout & Spacing

The layout is built for fluid, thumb-driven interaction across Android devices:

- **Mobile Rhythm (Phone):** Uses a 4-column layout with `0.75rem` (12px) gutters and `1rem` (16px) margins. Standard vertical spacing follows a strict 4px/8px modular scale.
- **Tablet Reflow:** Expands to an 8-column layout with `1.5rem` margins, allowing cover grids to expand dynamically while reading panes maintain a constrained maximum line length of 65 characters.
- **Safe Zones & Action Anchors:** Bottom navigation bars, persistent reading player drawers, and floating book actions respect system insets, anchored within sticky lower regions with `space-md` internal clearance.

## Elevation & Depth

Visual hierarchy uses a refined blend of **tonal surface stacking** and **subtle brass-tinted shadows**:

- **Layer 0 (Canvas Base):** `#121214`. The foundational background for pages, shelves, and reading canvas.
- **Layer 1 (Card & List Tile):** `#1C1C20` bordered with a 1px solid hairline of `#2E2E36`. Shadow: `0 2px 8px rgba(0, 0, 0, 0.45)`.
- **Layer 2 (Floating Modals & Bottom Sheets):** `#26262C` bordered with `rgba(212, 175, 55, 0.12)`. Shadow: `0 8px 24px rgba(0, 0, 0, 0.65), 0 1px 2px rgba(212, 175, 55, 0.05)`.
- **Layer 3 (Book Cover Realism):** Dynamic elevation for cover artwork consisting of a two-stage shadow (`0 4px 12px rgba(0,0,0,0.7)` and a 1px vertical spine highlight overlay) mimicking a bound physical volume resting on slate.

## Shapes

The interface balances soft geometry with structured rectangular framing:

- **Interactive Controls & Cards:** Follow Level 2 roundedness (`0.5rem` / 8px border radius) ensuring components feel friendly and comfortable for tactile mobile tapping.
- **Pills & Status Chips:** Fully pill-shaped (`9999px`) to immediately distinguish contextual tags from content cards.
- **Book Cover Artwork:** Constrained to a subtle `0.25rem` (4px) radius to preserve the authentic silhouette of hardcovers and paperbacks without clipping cover typography.

## Components

### Buttons
- **Primary:** Filled `#D4AF37` with `#121214` typography (DM Sans Bold), `0.5rem` radius, minimum 48px touch target height. Subtle amber glow on tap.
- **Secondary / Ghost:** Transparent surface with 1px `#2E2E36` border and `#F4EFEA` text. Shifts to `rgba(212, 175, 55, 0.08)` background on active press.
- **Floating Action Button (Reading Quick-Resume):** Circular 56px brass surface positioned above the bottom navigation bar.

### Chips & Tags
- **Filter Chips:** Capsule (`9999px`) pill shape. Inactive: `#1C1C20` background with `#9E9EA8` text. Active: `#D4AF37` border and text with `rgba(212, 175, 55, 0.12)` fill.
- **Genre & Metadata Chips:** Compact typography (`label-sm`), `#26262C` background, subtle uppercase letter spacing.

### Cards
- **Book Vault Card:** Vertical orientation highlighting high-resolution book cover artwork with a 1px inner border. Below the cover: Newsreader title in `#F4EFEA`, DM Sans author name in `#9E9EA8`, and reading progress indicated via a 3px brass linear track.
- **Shelf Row Card:** Horizontal layout with cover thumbnail, page count, reading status indicator, and bookmark icon button.

### Lists
- **TOC & History Lists:** Inset grouped layout separated by hairline dividers (`#2E2E36`). Left-aligned serif chapter titles, right-aligned sans-serif page numbers in `#9E9EA8`. Row height 56px for optimal Android touch targets.

### Input Fields
- **Search Bar:** Elevated pill or `0.5rem` container with `#1C1C20` fill, hairline border, inset magnifying glass icon, and `#F4EFEA` input text. Focus state illuminates the border with a warm gold ring (`#D4AF37` at 50% opacity).

### Checkboxes & Radio Buttons
- Custom circular/rounded controls in `#2E2E36`. Checked state fills with `#D4AF37` and displays an obsidian `#121214` inner checkmark.

### Mobile Bottom Navigation
- Anchored 64px bar resting on `#161619` with a top 1px border (`#2E2E36`) and background blur. Features 4–5 core destinations (Library, Discover, Currently Reading, Vault, Profile). Active tab glows in muted brass (`#D4AF37`) with an animated indicator dot.