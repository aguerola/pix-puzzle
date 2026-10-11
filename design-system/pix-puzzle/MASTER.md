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
| App background | `color.surface.app` | `#FAF7F0` | Scaffold |
| Surface | `color.surface.raised` | `#FFFCF7` | Cards / tiles |
| Ink | `color.ink.primary` | `#20252B` | Filled cells, titles |
| Ink muted | `color.ink.muted` | `#575D64` | Secondary labels |
| Cell empty | `color.cell.empty` | `#FFFCF7` | Unfilled board cells |
| Cell border | `color.cell.border` | `#73736F` | Grid lines |
| Accent | `color.accent.stamp` | `#B84433` | Selected difficulty, primary actions |
| On accent | `color.accent.onStamp` | `#FFFFFF` | Text on accent |
| Success | `color.accent.done` | `#30654E` | Level complete / done check |
| Danger soft | `color.accent.reset` | `#9B4033` | Reset (not destructive red scream) |
| Focus | `color.accent.focus` | `#EF7D68` | Visible focus / ring |

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


## Approved editorial redesign

User approved the mobile concept on 2026-10-11. Warm paper, charcoal grids, large editorial headings, coral focus (`PixColors.focus` = `#EF7D68`) and dark coral actions. White text on filled actions remains `#FFFFFF`. No gradients, illustrations or raster assets required.

- Mobile catalogue: difficulty chips above full-width list; meaningful display titles without changing stored IDs; completion count and first pending level.
- Game: brand/help header, title/difficulty, compact objective and stamp, dominant play board, labeled Undo/Reset controls and levels footer. Spanish interface.
- Tap commits on release; each cell exposes a native button and row/column state. Last move receives a coral inset ring.
- Boards larger than 7×7 offer a fullscreen pan/zoom view with at least 48px cells at base scale; drag does not stamp.
- Reset requires confirmation after moves. Completion offers a correctly labeled final-level action.
- Content scrolls on short screens or enlarged text; actions stack when required. Layout checked at 320px with 100% and 200% text scale.
