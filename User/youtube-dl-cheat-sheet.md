# list all formats
youtube-dl -F https://www.youtube.com/watch?v=

# download best format and download subtitle as .vtt
youtube-dl -f 22 --write-auto-sub https://www.youtube.com/watch?v=

# download only subtitle
youtube-dl --skip-download --write-auto-sub https://www.youtube.com/watch?v=

# download a playlist
Use single quotes to escape the ampersand.
The option `-f 18` is for 480p.
youtube-dl -f 18 --write-auto-sub 'https://www.youtube.com/watch?v=QCv87K_y97w&list=PLd19WvC9yqUeAD3MyBvXKG706OwtA8_sY'
