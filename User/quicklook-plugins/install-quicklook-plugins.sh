#!/usr/bin/env bash
# Script adapted from: https://mths.be/macos
# Original plugins list: https://github.com/sindresorhus/quick-look-plugins


###############################################################################
# Homebrew
###############################################################################

# Preview source code files with syntax highlighting (like colored .JS files)
brew install qlcolorcode &&

# Preview Markdown files
brew install qlstephen &&

# Preview JSON files with syntax highlighting
brew install quicklook-json &&

# Preview plaintext files with unknown extensions, like README, CHANGELOG, etc.
brew install qlstephen &&

# Display image size and resolution in windo titlebar of Quick Look
# Doesn't work due to API change from Apple
# https://github.com/Nyx0uf/qlImageSize/issues/45#issuecomment-610852166
#brew install qlimagesize &&

# Preview Adobe ASE color swatch files from Photoshop, Illustrator
# Doesn't work in macOS Catalina
#brew install quicklookase &&

# Preview the content of .IPA files
# Installs inside /Applications folder
brew install suspicious-package &&

# Preview the content of Android .APK files
# Doesn't work in macOS Catalina
#brew install quicklookapk

# Preview iOS/macOS provisioning information for .ipa and .xcarchive
# For 'mobileprovision' files, Xcode has Quick Look plugin collision:
# https://github.com/ealeksandrov/ProvisionQL/issues/20
brew install provisionql &&

# Preview the content of macOS apps
# Installs inside /Applications folder
brew install apparency &&

# Preview WebP images
brew install webpquicklook

# Preview ZIP archives
# Installs inside /Applications folder
# Run BetterZip to enable Quick Look plugin
brew install betterzip

# Preview videos files as single frames
# I don't like the presentation as it doesn't play the movie.
# Finder can natively play the movie through QuickLook.
#brew install qlvideo

# Remove quarantine attribute for macOS Catalina and above
xattr -d -r com.apple.quarantine ~/Library/QuickLook/QLColorCode.qlgenerator &&
xattr -d -r com.apple.quarantine ~/Library/QuickLook/QLMarkdown.qlgenerator &&
xattr -d -r com.apple.quarantine ~/Library/QuickLook/QuickLookJSON.qlgenerator &&
xattr -d -r com.apple.quarantine ~/Library/QuickLook/QLStephen.qlgenerator &&
#xattr -d -r com.apple.quarantine ~/Library/QuickLook/qlImageSize.qlgenerator &&
#xattr -d -r com.apple.quarantine ~/Library/QuickLook/QuickLookASE.qlgenerator &&
xattr -d -r com.apple.quarantine ~/Library/QuickLook/ProvisionQL.qlgenerator &&
#xattr -d -r com.apple.quarantine ~/Library/QuickLook/QuickLookAPK.qlgenerator &&
xattr -d -r com.apple.quarantine ~/Library/QuickLook/WebpQuickLook.qlgenerator

# Restart Quick Look Server
qlmanage -r &&

echo ''
echo 'To see some of the new Quick Look features, you may need to either:'
echo '1. Log out the current user and log in again, or'
echo '2. Switch user to another macOS account, then switch back'
echo ''
echo 'This script will not log you out'
echo 'to avoid disrupting your current session.'
echo ''
