# list all formats
Remember to enclose the link in single quotes to avoid escaping the '?v=' url parameter.
```bash
youtube-dl -F 'https://www.youtube.com/watch?v='
```

# download best format and download subtitle as .vtt
```bash
youtube-dl -f 22 --write-auto-sub https://www.youtube.com/watch?v=
```

# download only subtitle
```bash
youtube-dl --skip-download --write-auto-sub https://www.youtube.com/watch?v=
```

# download a playlist
Use single quotes to escape the ampersand.
The option `-f 18` is for 480p.

```bash
youtube-dl -f 18 --write-auto-sub 'https://www.youtube.com/watch?v=QCv87K_y97w&list=PLd19WvC9yqUeAD3MyBvXKG706OwtA8_sY'
```

# download vimeo with password
`youtube-dlc` is a fork that sometimes is more up-to-date than `youtube-dl`.

```bash
youtube-dlc -v "https://vimeo.com/URL" --video-password thepassword
yt-dlp -v "https://vimeo.com/URL" --video-password thepassword
```

# update yt-dlp to newest version
```bash
python3 -m pip install --upgrade yt-dlp
```
