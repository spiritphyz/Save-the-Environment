# VSCode personal settings
Copy `settings.json` to this location:
```bash
# Windows
%APPDATA%\Code\User\settings.json

# macOS
$HOME/Library/Application Support/Code/User/settings.json

# Linux
$HOME/.config/Code/User/settings.json
```

# Install extensions on new machine

### Installing the terminal helper
On both the source and destination machines, make sure the terminal helper is installed:

```bash
# This command on all platforms should return a valid number
code --version
```

If the helper isn't installed, here are the instructions:
 1. In VS Code, press Shift-Ctrl-P (or Shift-⌘-P) to open the Command Palette
 2. Type `shell command` to find:
    `Shell Command: Install 'code' command in PATH`
 3. Press Enter to install the helper

### Export the extensions
On the source machine, export the extension list to a text file. (Or, use `vs_code_extensions_list.txt` in this repository.)
```bash
# Export the extension list
code --list-extensions > vs_code_extensions_list.txt
```

### Import each extension and install
Then install each extension from the source `txt` file:
```bash
# Windows PowerShell
get-content c:\vs_code_extensions_list.txt | % { code --install-extension $_ }

# macOS and Linux
cat vs_code_extensions_list.txt | xargs -n 1 code --install-extension
```

# References
 * https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
 * https://superuser.com/questions/1080682/how-do-i-back-up-my-vs-code-settings-and-list-of-installed-extensions
 * https://stackoverflow.com/questions/29971053/how-to-open-visual-studio-code-from-the-command-line-on-osx
