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
- [ ] Solve the middle nav icon getting selected on transition
- [x] Quick filters state inconsistency - still present, hard to reproduce reliably
  - This was due to the loading being done on every call
- [ ] Make filters global
  - [x] Make range slider values better, not linear

    Thanks to https://www.howdoi.me/blog/slider-scale.html for the implementation details. Some selection bugs persist when adding or removing transactions
- [x] Import databases
- [x] Fix the tutorial after the layout changes
  - [ ] Manage tutorial still has legibility issues
- [ ] Rewrite tests
- [ ] Graph transition animation bugs
- [ ] Better no transactions found handling on analysis page
- [ ] A way to add and manage events
  - [ ] Add transactions to events
- [x] Make additional info multiline
- [x] Make accounts and categories orderable
  - [ ] Make them archivable or hideable
- [x] Add location to entries (optional)
  - [ ] Move to Google Maps because more locations