# Cutzy Lite

Simple dress-up game: pick one of 3 characters, then dress her up.

- 3 characters (لينا، سارة، مايا)
- 6 categories (تسريحات، بلايز، بناطيل، فساتين، أحذية، إكسسوارات)
- 5 pieces per category + "بدون" to remove
- Shuffle and clear-all buttons
- Artwork is drawn in code on a 1080x1920 design canvas, scaled to any screen

## Run

The `android/` folder is generated, so run this once first:

    flutter create --platforms=android --org com.cutzy --project-name cutzy_lite .
    flutter pub get
    flutter run

## Build APK on GitHub

Put the whole folder content at the ROOT of the repo (so `.github/workflows/` sits at the top level), then push. The workflow is in `.github/workflows/build-apk.yml`. Download the APK from the run's Artifacts section.

## Next steps

- Replace the coloured shapes with real PNG layers (same slots, swap `_top`, `_dress`, etc. for images).
- Save/load outfits (shared_preferences).
- More items per category, more characters.
