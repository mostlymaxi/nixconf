cache=${XDG_RUNTIME_DIR:-/tmp}/spotify-notify
mkdir -p "$cache"
sep=$'\t'
last="" id=0
playerctl -p spotify -F metadata --format "{{status}}${sep}{{artist}}${sep}{{title}}${sep}{{album}}${sep}{{mpris:artUrl}}" |
    while IFS=$sep read -r status artist title album art; do
        [[ $status == Playing && "$artist$title" != "$last" ]] || continue
        last="$artist$title"
        icon=spotify
        if [[ -n $art ]]; then
            file="$cache/${art##*/}"
            [[ -f $file ]] || curl -sSfL --max-time 5 -o "$file" "$art" || true
            [[ -f $file ]] && icon=$file
        fi
        id=$(notify-send -p -r "$id" -t 5000 -a Spotify -i "$icon" "$title" "$artist · $album" || echo 0)
    done
