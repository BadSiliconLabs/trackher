# TrackHer

Android app (Flutter) for boyfriends: it tracks your girlfriend's cycle so you can support her better.
Enter a few period start dates (gaps between them are fine) and a Bayesian model works out the rest:
a forecast with uncertainty, the current phase, practical tips, her own notes, and switchable
notifications. Everything stays on the phone.

See [docs/DESIGN.md](docs/DESIGN.md) for the full design and the prediction model.

## Develop

```sh
flutter pub get
flutter test                                          # engine, storage and state tests
flutter test test/screens_test.dart --update-goldens  # re-render screen PNGs in test/goldens
flutter run                                           # on a connected device or emulator
flutter build apk --release                           # build/app/outputs/flutter-apk/app-release.apk
```

Layout: `lib/engine` holds the pure-Dart predictor, phases and tips logic; `lib/state` the app state;
`lib/ui` the screens; `assets/tips.json` the tip library.

Not medical advice and not contraception.
