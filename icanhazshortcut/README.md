# iCanHazShortcut

I use this utility to get single-key access to common apps. I can switch instantly between multiple apps without relying on Mission Control to visually inspect windows or pressing command-tab repeatedly to get to the right app.

For example, I can switch between Chrome, Kitty (terminal emulator), and Finder in any order using single keystrokes.

iCanHazShortcut is a simple shortcut manager for macOS 10.8 or higher. It lets you execute any command that works in your terminal by pressing a combination of keyboard keys. No rocket science involved!

https://github.com/deseven/iCanHazShortcut?tab=readme-ov-file

![Screenshot of Shortcuts](https://camo.githubusercontent.com/5ed8065dc4fd84784f4e6bf0aad5c46d9814454a39f96b98e0217657d05d5760/68747470733a2f2f64372e7774662f53636865736973446f646563616e6543756e61726465722e706e67)

Downsides: there is no arm64 release yet, so this utility requires conversion through Rosetta 2.


# Example entry for "Focus Finder"
 ⌥ w means "option w"

```
Shortcut: ⌥w
Action: Focus Finder
Command: osascript /Users/tonyle/.myscripts/focus-finder.scpt
Workdir: (empty)
```
