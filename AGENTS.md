# Pix-Puzzle — Agent guide

Stamp/XOR grid puzzle game, ported from Android to Flutter (iOS, Android, web) with `flutter_bloc`.

## Layout

| Path | Contents |
|------|----------|
| `pix_puzzle/` | Flutter app (source of truth) |
| `pix_puzzle/lib/` | Dart code |
| `pix_puzzle/assets/levels.json` | Level definitions |
| `pix_puzzle/test/` | Unit / widget tests |
| `pix_puzzle_v2.apk` | Original Android APK (Git LFS) — reference only |
| `firebase.json` / `.firebaserc` | Firebase Hosting target `pix-puzzle` → `{project}-pix-puzzle.web.app` |
| `.github/workflows/deploy-web.yml` | Deploy Flutter web to Guerolabs Hosting (dev + prod) via WIF |

App entry: `pix_puzzle/lib/main.dart` → `PixPuzzleApp`.

## Commands

Run from `pix_puzzle/`:

```bash
flutter pub get
flutter run
flutter test
flutter analyze
```

VS Code / Cursor launch configs (debug, profile, release): `.vscode/launch.json`.

## Architecture

Feature-first under `lib/`:

- `data/models/` — `Level`, `BoardCell` (Equatable, JSON, game logic)
- `data/repositories/` — `LevelsRepository` (load levels, persist progress via `shared_preferences`)
- `features/home/` — level list (`LevelsCubit`, `HomePage`)
- `features/game/` — play session (`GameBloc`, `GamePage`, complete dialog)
- `widgets/` — shared UI (e.g. `BoardGrid`)

State management:

- Use **Cubit** for simple load/list state; **Bloc** + sealed events for gameplay.
- Events/states extend `Equatable`. Prefer immutable `copyWith` / deep clones for boards.
- Board indices are **`[x][y]` (column, row)**, matching the original Android app. Do not flip axes when porting or editing levels.

Core puzzle rule: tapping a cell toggles `selected` and runs `Level.recalcFills()` (XOR stamp of the 3×3 brush). Completion when `tableBoard` fills match `tableModel`.

## Conventions

- Keep game rules in models (`Level`), not in widgets.
- Prefer small, focused files colocated by feature.
- Follow `flutter_lints` (`analysis_options.yaml`); run `flutter analyze` before finishing non-trivial changes.
- Do not commit secrets. Treat `pix_puzzle_v2.apk` as binary reference; prefer Git LFS, not re-encoding.
- When changing stamp/XOR or level JSON shape, add or update tests in `test/level_logic_test.dart`.

## Skills de UI (proyecto)

Instalados en `.agents/skills/` (espejo en `.cursor/skills/`; ver `skills-lock.json`):

| Skill | Usar cuando |
|-------|-------------|
| `mobile-ui-ux-designer` | Layout/UX móvil, flujos, a11y, handoff |
| `ui-ux-pro-max` | Estética, design system, paletas, tipografía |
| `game-ui-ux` | HUD, menús, feedback visual, UI de juego |

Antes de cambios visuales no triviales: leer la skill relevante y, si existe, `design-system/pix-puzzle/MASTER.md`. Búsqueda de patrones:

```bash
python3 .agents/skills/ui-ux-pro-max/scripts/search.py "<query>" --domain ux
python3 .agents/skills/ui-ux-pro-max/scripts/search.py "puzzle pixel game" --design-system -p "Pix-Puzzle"
```

## Out of scope for agents

- Do not reverse-engineer or redistribute the APK beyond reading it as a behavioral reference for this port.
- Do not publish the package (`publish_to: 'none'`).
