PATH="$(
    echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++' | while IFS= read -r line || [ "$line" ]; do
        [ -d "$line" ] && echo "$line"
    done | paste -sd:
)"

export PATH