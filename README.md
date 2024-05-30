# moniz

A new Flutter project for managing your money.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## TODOs:

- [x] A lot of clean up
- [x] Add testing
- [x] App icon
- [x] Make accounts and categories part of same parent class
  - [ ] Done, but this needs more work
- [ ] Animate transaction amount update
- [x] Support dynamic themes
- [x] Make categories reorderable
- [x] Solve the middle nav icon getting selected on transition - solved by removing the PageView
- [x] Quick filters state inconsistency - still present, hard to reproduce reliably
  - This was due to the loading being done on every call
- [x] Make filters global
  - [x] Make range slider values better, not linear

    Thanks to https://www.howdoi.me/blog/slider-scale.html for the implementation details.
  - [x] Some selection bugs persist when adding or removing transactions
  - [x] Range slider remains global
  - [x] Make filters multi select
- [x] Import databases
- [x] Fix the tutorial after the layout changes
  - [ ] Manage tutorial still has legibility issues
- [ ] Rewrite tests
- [ ] Graph transition animation bugs
- [x] Better no transactions found handling on analysis page
- [ ] A way to add and manage events
  - [ ] Add tags
- [ ] Make entrines multiselect-able
- [x] Make additional info multiline
- [x] Make accounts and categories orderable
  - [ ] Make them archivable or hideable
- [x] Add location to entries (optional)
  - [x] Move to Google Maps because more locations
- [x] Make app restart on data import
- [ ] Add images somehow using rust to use JPEGXL - maybe use Supabase
- [ ] Rewrite LineGraph as it lags with a lot of transactions