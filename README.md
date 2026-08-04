# VEXA — AI Fashion Assistant (Flutter)

High-fidelity Flutter prototype for **VEXA** (client: Amirez) — digital closet, AI outfit
recommendations from clothes the user already owns, and image-based virtual try-on.
No e-commerce: no prices, brands, carts, or shopping.

## Run

```bash
flutter pub get
flutter run              # pick an Android/iOS device or emulator
flutter run -d chrome    # or run in the browser
```

## What's inside

| Flow | Screens |
|---|---|
| Launch | Splash (auto-advance) → Onboarding ×4 → "Start Your Fashion Journey" |
| Auth | Login, Create Account, Forgot Password, OTP (auto-advance + resend timer), Reset Password |
| Setup | Try-on photo upload (simulated quality check + guidelines sheet), Measurements, Style Preferences, Setup Complete |
| Main tabs | Home (Today's Look, quick actions, stats, recent AI results), Closet (masonry grid, search, filter sheet, FAB), Try-On Studio (3 steps), Profile |
| Closet | Add Clothing (AI-detected badge — actually adds the Cream Knit Poncho), Item Detail (edit / replace photo / delete with dialogs) |
| AI | Outfit Recommendation (like/dislike, Another, Save, Try This Look On), Generating (animated orb + staged progress), Generation Failed, Result (draggable before/after slider, share sheet) |
| Account | Edit Profile, Change Password, Privacy, Settings; logout & delete-account dialogs |

**Demo tip:** long-press **Generate My Look** on the try-on review step to preview the
generation-failure state; a normal tap always succeeds.

## Design system (`lib/theme.dart`)

- Background `#F8F8F8`, cards white, primary ink `#0B0B0F`
- Accent iris `#8A5CFF` — reserved for AI moments only (gradient CTAs, active nav, loading orb)
- Plus Jakarta Sans (variable) for UI + Playfair Display italic for editorial accents (bundled in `assets/fonts/`)
- Reusable components in `lib/widgets.dart` (buttons, chips, cards, bottom sheets, dialogs, toasts, empty states)

Demo data lives in `lib/data.dart` (Amira Hassan, 18 wardrobe pieces, 5 outfit recipes,
recent AI results). The matching clickable HTML prototype is `VEXA-Prototype.html` at the
project root.
