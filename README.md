# Homebrew Tap for Kandev

Homebrew tap for [kandev](https://github.com/kdlbs/kandev).

## Install

```bash
brew install kdlbs/kandev/kandev
```

Or tap first:

```bash
brew tap kdlbs/kandev
brew install kandev
```

## Updates

```bash
brew upgrade kandev
```

## How this tap is published

The `Formula/kandev.rb` file is updated automatically by [`scripts/release/update-homebrew-tap.sh`](https://github.com/kdlbs/kandev/blob/main/scripts/release/update-homebrew-tap.sh) during each kandev release. The formula always points at the matching GitHub release assets.
