# TrackHer: Design Doc

_Status: v1 draft, 2026-11-23_

## 1. What it is

An Android app (Flutter) that helps someone keep track of their girlfriend's menstrual cycle
so they can be more supportive. You enter a few period start dates, from any months and
with gaps allowed, and the app works out the rest:

- a **probabilistic forecast** of upcoming periods (most likely day plus an uncertainty band,
  shown as a bell curve),
- the **current phase** (period, follicular, ovulation, luteal/PMS), with how confident it is,
- **practical tips** for each phase (food, affection, space, plans, words),
- **her own notes** ("hates being touched on day 1", "loves ramen"), shown at the right time,
- **notifications**, each one switchable in settings.

Design rules: **you only need to enter dates. Everything else is optional, automatic,
local-only and quick.**

> Every person is different. The tips are suggestions, not rules, and the best source is
> always her. The app says this during onboarding and on the tips screen, and it points out
> that it works best when she knows about it and helps fill it in.
> It is **not** contraception and **not** medical advice. The fertile window is informational only.

## 2. Decisions made

| Topic | Decision |
|---|---|
| Platform | Flutter, Android first (min SDK 23) |
| Storage | **Local only.** One JSON file in app storage. No account, no network, no analytics |
| Backup | Manual JSON export/import (share sheet / file picker) |
| Tips | **Built-in curated library** (bundled JSON asset), works offline |
| Notifications | Period coming soon, PMS window, daily tip, fertile window. **Each one can be turned on or off**, plus time of day and lead days |
| Docs | This file, kept in the repo |

## 3. User flows

### 3.1 First run (aim: under 30 seconds)
1. Welcome, with a short "be respectful, every person is different" note.
2. "What's her name?" (optional, used to personalise text; the default is "her").
3. "When did her last period(s) start?" A calendar where you tap one or more days. You can
   skip months. **One date is enough**, and each extra date makes the forecast better.
4. Done. You land on Home.

### 3.2 Everyday use
- **Home**: a big phase card ("Day 24 · PMS likely · period in ~4 days (±2)"), today's tip,
  a reminder from her notes if one applies, and a quick button: **"Her period started today"**.
- **Calendar**: month view. Logged periods are solid. Predicted periods are shaded by
  probability, and fertile and PMS windows are tinted.
- **Forecast**: a bell curve chart for the next start date, plus a list of the next 6 predicted
  starts with ±range. It also shows the learned stats: average cycle length, variability, and
  how many cycles the model used.
- **Tips**: browse by phase and category. Thumbs up/down hides or boosts tips.
- **Her notes**: free-text notes, each tagged with a phase (or "always"). Examples: "Day 1–2:
  wants space", "PMS: craves chocolate, dark only".
- **Settings**: notification toggles, time of day, lead days, her name, typical period
  length, export/import, delete everything.

### 3.3 Optional data (never required)
- Period **end** dates, used to learn her period length (default 5 days).
- A daily log of mood, symptoms (cramps, headache, fatigue, bloating, acne, cravings) and a
  short note. In v1 this is shown in history only. A later version may correlate it with phases.

### 3.4 Late or missing periods
- If today is past the predicted start but inside the uncertainty band: "Period may start any
  day now", with a one-tap confirm.
- If today is past the band (more than about 2σ late) and nothing was logged, the app
  **assumes you just didn't log it**. It projects forward whole cycles and shows a small
  banner: "Haven't logged in a while: did her period start?" A sparse log never breaks the
  forecast.

## 4. The prediction model

### 4.1 Problem
We have period start dates `d₁ < d₂ < … < dₙ`. These are **not necessarily consecutive**,
for example this month, last month and 5 months ago. Each gap `gᵢ = dᵢ₊₁ − dᵢ` therefore
covers an **unknown whole number of cycles** `kᵢ ≥ 1`.

Cycle model: each cycle length is independent and follows `L ~ Normal(μ, σ²)`.
So a gap made of `k` cycles follows `g | k ~ Normal(kμ, kσ²)`.

### 4.2 Inference: Bayesian grid posterior
This is cheap enough to compute exactly on a phone, and there's no fitting code to debug.

- **Grid**: μ ∈ [20, 45] days, step 0.1 (251 values) × σ ∈ [0.75, 10] days, step 0.25
  (38 values), about 9.5k points.
- **Priors** (population studies give a mean of about 28–29 days, typical SD between people
  about 2–4 days):
  - `μ ~ Normal(28.5, 3.5²)`
  - `σ ~ LogNormal(ln 2.5, 0.5²)`, so most of the mass is between 1.5 and 4.5 days.
- **Likelihood** of each gap, with `k` marginalised out:
  `p(gᵢ | μ,σ) = Σₖ p(k) · N(gᵢ; kμ, kσ²)` for `k = 1..K`, where `K = ceil(gᵢ / 18)`
  (capped at 24). `p(k)` is uniform. The data then decides whether a 58-day gap was
  2 cycles or 1 long one.
- Gaps of **more than 365 days** are ignored, because old history may be stale. Gaps of
  **less than 15 days** are treated as a likely duplicate or spotting and flagged.
- **Recency weighting**: each gap's log-likelihood is multiplied by `w = 0.5^(age/365d)`,
  so recent behaviour counts more.
- Work in log-space and normalise. This gives a posterior `P(μ,σ)` over the grid.

Results:
- With **1 date** the posterior is the prior. The forecast still works, it's just wide.
- With **2+ dates** it tightens quickly, especially when the gaps are consecutive (k=1).

### 4.3 Forecast
Let `A` be the anchor (the last logged start). The `n`-th next start is:

`S_n | μ,σ ~ Normal(A + nμ, nσ²)`

The **posterior predictive** is a mixture over the grid. We evaluate it as a **daily
probability mass** (integrate each Gaussian over `[day−0.5, day+0.5]` and add them up,
weighted by `P(μ,σ)`). From that we report:
- **most likely day** (mode), **mean**, and an **80% / 95% interval** from the CDF,
- an **effective σ** (the predictive SD, which includes uncertainty about μ, so it grows faster than √n).

**Which `n` is "next"**: the smallest `n` whose predictive 97.5th percentile is ≥ today,
so the latest still-plausible start hasn't passed yet. We also compute
`P(already started)` = predictive mass before today, which drives the "any day now" and
"late" wording.

### 4.4 Phases
Phases are measured relative to the **next start** `S` and the **last start** `A'`
(the most recent actual or assumed start):

| Phase | Definition (days) |
|---|---|
| Period | `A'` … `A' + periodLength − 1` |
| Follicular | after period … ovulation − 3 |
| Fertile window | ovulation − 5 … ovulation + 1 |
| Ovulation | `S − 14` (the luteal phase is fairly fixed at about 14 ± 2 days) |
| Luteal | ovulation + 1 … `S − 1` |
| PMS (inside luteal) | `S − 6` … `S − 1` |

Because `S` is a distribution, the phase for any day is also a distribution. We take the
probability of each phase per day by averaging over the predictive `S`. The UI shows the
most probable phase, and says "likely" when its probability is below 0.7.

### 4.5 Learned stats shown to the user
Posterior mean ± SD of μ, posterior mean of σ ("her cycle varies by about ±σ days"),
a regularity label (σ<2 very regular, <4 regular, <7 somewhat irregular, else irregular),
and the number of gaps used and how many were inferred to span more than one cycle.

### 4.6 Validation
Unit tests on synthetic data: generate cycles with known μ and σ, keep random subsets of
dates, and check that the posterior covers the truth and that the 80% intervals hold about
80% of held-out starts.

## 5. Tips system

`assets/tips.json`, a list of:
```json
{ "id": "pms-iron-dinner", "phases": ["pms","period"], "category": "food",
  "title": "Iron-rich dinner", "text": "Cook steak, lentils or spinach..." }
```
- **Phases**: `period, follicular, ovulation, luteal, pms, any`.
- **Categories**: food, comfort, affection, space, plans, words, practical.
- **Daily tip**: the choice is deterministic per day (a hash of the date), drawn from tips
  that match today's most likely phase. Disliked tips are excluded and liked tips weighted ×3.
  The same tip appears in the notification and on Home.
- **Her notes**: notes tagged with today's phase (or "always") are shown above the generic
  tips, because what she actually told you beats generic advice.
- v1 ships with about 60 tips. The wording is inclusive and practical, and avoids clichés.

## 6. Notifications

Uses `flutter_local_notifications` with *inexact while-idle* alarms, so no exact-alarm
permission is needed (reminders don't need minute precision). Notifications are scheduled ahead, about 45 days and
at most 60, and **rescheduled whenever data or settings change, and when the app opens**.

| Notification | Default | When |
|---|---|---|
| Period coming soon | on, 2 days before | `mode − lead` days, at the chosen time |
| PMS window starting | on | start of PMS window |
| Daily tip | on | every day at the chosen time (default 09:00) |
| Fertile window | **off** | start of the fertile window |

There's also a master switch. Notification text uses neutral wording, so it doesn't reveal
details on a lock screen: "TrackHer: a heads-up for the next few days".

## 7. Architecture

```
lib/
  main.dart                    app entry, theme, router
  model/                       plain data classes + JSON (Cycle data, Note, Settings, DayLog)
  engine/
    predictor.dart             Bayesian grid posterior + predictive (pure Dart, no Flutter)
    phases.dart                phase computation
    tips_engine.dart           daily tip selection
  data/
    store.dart                 single JSON file persistence (path_provider), export/import
  services/
    notifications.dart         scheduling
  state/
    app_state.dart             ChangeNotifier holding data + derived forecast
  ui/
    onboarding/ home/ calendar/ forecast/ tips/ notes/ settings/ widgets/
assets/tips.json
test/                          predictor tests (synthetic), phases, tips, store round-trip
```

- **State**: a single `ChangeNotifier` (`AppState`) with `provider`. The app is small, so it
  doesn't need heavier frameworks.
- **Engine** is pure Dart and fully unit-tested. The forecast is recomputed on every data
  change, which takes milliseconds.
- **Packages**: `material_ui`, `provider`, `path_provider`, `flutter_local_notifications`, `timezone`,
  `flutter_timezone`, `intl`, `share_plus`, `file_picker`. The month calendar and bell-curve chart
  are custom widgets. Third-party calendar and chart packages still depend on the deprecated
  `flutter/material.dart`, and their theming wouldn't match the app.
- **Data file** `trackher.json` has a schema version for migrations.
- **UI**: Material 3, warm rose/plum palette, light and dark.

## 8. Privacy
- No internet permission is requested.
- Data is never sent anywhere. Export happens only when you trigger it.
- "Delete all data" in settings wipes the file and cancels all notifications.
- Lock-screen notification text stays generic.
- _Later:_ an optional app lock (biometric/PIN).

## 9. Milestones
1. ✅ **M1 engine**: predictor + phases + tests
2. ✅ **M2 app skeleton**: storage, state, onboarding, Home, log period
3. ✅ **M3 views**: calendar, forecast chart, tips, notes
4. ✅ **M4 notifications + settings**, export/import
5. 🔄 **M5 polish**: icon ✅, empty states ✅, release build, real-device testing, Play Store signing

## 10. Later ideas
- App lock, home-screen widget, symptom correlations, a "shared mode" where she logs and
  you get read-only sync (would need a backend), multiple languages.
