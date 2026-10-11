# xe GPU busy % from the DRM fdinfo of this user's processes (the PMU route needs root).
# One waybar json line per interval; silent on hosts without xe.
interval=${1:-2}
prev_busy=0 prev_ts=0
while :; do
    # grep -s: fds vanish between glob and open, and other users' procs are unreadable
    read -r busy ts < <(
        grep -sH -E '^drm-(driver|client-id|cycles-rcs|total-cycles-rcs):' /proc/[0-9]*/fdinfo/* |
            awk -F '[:\t]+' '
                $2 == "drm-driver"           { xe[$1] = ($3 == "xe") }
                $2 == "drm-client-id"        { id[$1] = $3 }
                $2 == "drm-cycles-rcs"       { c[$1] = $3 }
                $2 == "drm-total-cycles-rcs" { t[$1] = $3 }
                END {
                    # one DRM client can be open under several fds/pids; count it once
                    for (f in id) if (xe[f] && !(id[f] in seen)) {
                        seen[id[f]] = 1; busy += c[f]; if (t[f] > ts) ts = t[f]
                    }
                    print busy + 0, ts + 0
                }'
    )
    if ((ts > prev_ts)); then
        pct=$(((busy - prev_busy) * 100 / (ts - prev_ts)))
        ((pct < 0)) && pct=0
        ((pct > 100)) && pct=100
        class=""
        ((pct >= 50)) && class=warning
        ((pct >= 80)) && class=critical
        printf '{"text":"%02d","percentage":%d,"class":"%s"}\n' "$pct" "$pct" "$class"
    fi
    prev_busy=$busy prev_ts=$ts
    sleep "$interval"
done
