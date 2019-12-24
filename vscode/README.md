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
# On source machine:
code --list-extensions >> vs_code_extensions_list.txt

# On destination machine, install each extension:
# Windows:
get-content c:\exportedlist.txt | % { code --install-extension $_ }

# macOS and Linux
cat vs_code_extensions_list.txt | xargs -n 1 code --install-extension

```


# References
 * https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
 * https://superuser.com/questions/1080682/how-do-i-back-up-my-vs-code-settings-and-list-of-installed-extensions
