# Install instructions for older Ubuntu versions (less than 19)
Use a local package to and gdebi to install it.

## Get latest `.deb` file from Releases page
https://github.com/sharkdp/bat/releases
https://github.com/sharkdp/bat/releases/download/v0.18.1/bat-musl_0.18.1_amd64.deb

## Install gdebi utility
gdebi lets you install local deb packages, resolving and installing its dependencies. apt does the same, but only for remote (http, ftp) located packages.
```bash
sudo apt install gdebi
```

## Install local package
```bash
sudo gdebi bat-musl_0.18.1_amd64.deb
```

