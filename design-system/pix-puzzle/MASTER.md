# Pix-Puzzle Design System — MASTER

**Product:** Pix-Puzzle (Flutter stamp/XOR puzzle)  
**Direction:** Paper + ink pixel grids — calm puzzle table, not neon arcade shell  
**Source override:** `ui-ux-pro-max --design-system` suggested dark neon red/blue + Press Start 2P — **rejected** as unfit for the existing black/white board DNA and Android port readability. Kept the *pixel-grid* metaphor; restyled as light paper surfaces with ink cells.  
**Skills:** `ui-ux-pro-max`, `mobile-ui-ux-designer`, `game-ui-ux` (see `.agents/skills/`)

---

## 1. Brand & mood

| Token | Value |
|-------|--------|
| Mood | Focused, tactile, quiet confidence |
| Metaphor | Graph paper + rubber stamp (XOR brush) |
| Density | One play surface dominates; chrome stays thin |
| Avoid | Neon on dark, emoji icons, purple SaaS gradients, dense Material chrome fighting the grids |

---

## 2. Color tokens

| Role | Token | Hex | Use |
|------|-------|-----|-----|
| App background | `color.surface.app` | `#F4F1EC` | Scaffold |
| Surface | `color.surface.raised` | `#FFFCF8` | Cards / tiles |
| Ink | `color.ink.primary` | `#1A1A1A` | Filled cells, titles |
| Ink muted | `color.ink.muted` | `#5C5A56` | Secondary labels |
| Cell empty | `color.cell.empty` | `#FFFFFF` | Unfilled board cells |
| Cell border | `color.cell.border` | `#B8B4AC` | Grid lines |
| Accent | `color.accent.stamp` | `#2F6F6A` | Selected difficulty, primary actions |
| On accent | `color.accent.onStamp` | `#FFFFFF` | Text on accent |
| Success | `color.accent.done` | `#3D8B6E` | Level complete / done check |
| Danger soft | `color.accent.reset` | `#8B4A3D` | Reset (not destructive red scream) |
| Focus | `color.accent.focus` | `#2F6F6A` | Visible focus / ring |

**Contrast:** body text on app ≥4.5:1; filled cells stay pure black/white for puzzle legibility.

---

## 3. Typography

- **UI:** system / Material 3 defaults (no pixel fonts — boards already carry the pixel signal).
- Title: `titleLarge` / `titleMedium`, weight 600.
- Level names: `bodyMedium`; truncate with ellipsis.
- Game labels (“Target” / “Board”): `labelLarge`, muted ink.

---

## 4. Spacing & touch

| Token | Value |
|-------|--------|
| `space.xs` | 4 |
| `space.sm` | 8 |
| `space.md` | 16 |
| `space.lg` | 24 |
| Touch minimum | 48×48 for icon actions (Undo / Reset / dialog) |
| Level row min height | ≥56 |

---

## 5. Motion

- List / page transitions: 200–300ms ease-out.
- Board cell paint: instant (puzzle feedback must feel crisp).
- Respect `MediaQuery.disableAnimations` / reduced motion: skip non-essential fades.

---

## 6. Screen contracts

### Home

- P0: difficulty filter + level list with target preview + brush chip.
- Done state: check + muted “Done” (not color alone).
- Empty / error: message + retry path.

### Game

- P0: target grid + play board; brush preview always visible.
- Labels distinguish Target vs Board.
- Undo / Reset: 48px targets, tooltips + semantics.
- Complete: one primary (Next), secondary Restart / Home — labeled, not icon-only.

---

## 7. Implementation map

| Concern | File |
|---------|------|
| Theme tokens | `pix_puzzle/lib/theme/pix_theme.dart` |
| Home list | `features/home/home_page.dart` |
| Game HUD | `features/game/game_page.dart` |
| Win dialog | `features/game/complete_dialog.dart` |
| Grid paint | `widgets/board_grid.dart` |
