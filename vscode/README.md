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

# Duplicate extensions to new machine
```bash
# On old machine:
code --list-extensions >> vs_code_extensions_list.txt

# On new machine, install each extension:
# Unix-based machine:
cat vs_code_extensions_list.txt | xargs -n 1 code --install-extension

# Windows:
get-content c:\exportedlist.txt | % { code --install-extension $_ }
```


# References
 * https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
 * https://superuser.com/questions/1080682/how-do-i-back-up-my-vs-code-settings-and-list-of-installed-extensions
