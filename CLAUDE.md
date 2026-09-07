# Project pic-swiper

## objective

pic-swiper is a simple mobile app that read the gallery on the phone to help you choosing which one you keep or delete.
To allow you choosing, the app is a single page like tinder.
You have the current pic in the center:

- if you swipe left, you delete it
- if you swipe right, you keep it
  There is 2 button at the bottom page, a red heart on the right to keep it, a yellow cross on the left to delete.

## Stack

- Flutter only
- We target IOS and Android distribution.

## Commands

- `flutter pub get` — install dependencies
- `dart run build_runner build --delete-conflicting-outputs` — generate code
- `flutter analyze` — run linter
- `flutter test` — run tests
- `flutter run` — start dev build

## Architecture

- Feature-first folder structure. Each feature lives in lib/features/<name>/.
- State management: Riverpod with @riverpod code generation (AsyncNotifier pattern).
- HTTP: Dio with interceptors in lib/core/network/.
- Navigation: GoRouter with named routes defined in lib/core/router/.
- Models: Freezed + JsonSerializable. Run build_runner after any model change.

## Conventions

- All monetary amounts in the smallest unit (e.g. kobo for NGN), stored as int — never use doubles for money
- Use ref.invalidate() not ref.refresh()
- No business logic in widgets — all logic goes in notifiers or repositories
- Widget files contain only one public widget per file
- Barrel exports via feature.dart in each feature root
- Prefix private widgets with an underscore

## What NOT to do

- Do not add new packages without asking first
- Do not modify _.g.dart or_.freezed.dart files directly — regenerate with build_runner
- Do not put API calls directly in notifiers — always go through the repository layer
- Do not update this file.
