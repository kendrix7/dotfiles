#!/bin/bash

# Find the most recent screenshot in the Work/Screenshots folder
LATEST_SCREENSHOT=$(find ~/Documents/Work/Screenshots -name "Screenshot*.png" -type f -exec stat -f "%m %N" {} \; 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2-)

# Check if a screenshot was found
if [ -z "$LATEST_SCREENSHOT" ]; then
    echo "❌ No screenshots found in ~/Documents/Work/Screenshots"
    exit 1
fi

# Copy to clipboard using osascript
osascript -e "set the clipboard to (read (POSIX file \"$LATEST_SCREENSHOT\") as JPEG picture)"

if [ $? -eq 0 ]; then
    echo "✅ Copied latest screenshot to clipboard: $(basename "$LATEST_SCREENSHOT")"
else
    echo "❌ Failed to copy screenshot to clipboard"
    exit 1
fi
