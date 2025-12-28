#!/bin/bash

# Usage: publish-post.sh <path-to-markdown-file> [category]
# Example: publish-post.sh ~/drafts/my-new-post.md coding

set -e

# Check if file argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-markdown-file> [category]"
    echo "Example: $0 ~/drafts/my-new-post.md coding"
    exit 1
fi

SOURCE_FILE="$1"
CATEGORY="${2:-general}"

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: File '$SOURCE_FILE' not found"
    exit 1
fi

# Get the script's directory and navigate to the blog root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_ROOT="$(dirname "$SCRIPT_DIR")"
POSTS_DIR="$BLOG_ROOT/_posts"

# Extract just the filename without path
BASENAME=$(basename "$SOURCE_FILE")

# Remove any existing date prefix (yyyy-mm-dd-) if present
BASENAME_NO_DATE=$(echo "$BASENAME" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//')

# Get today's date in yyyy-mm-dd format
TODAY=$(date +%Y-%m-%d)

# Create new filename with today's date
NEW_FILENAME="${TODAY}-${BASENAME_NO_DATE}"

# Generate title from filename (remove .md, replace hyphens with spaces, title case)
TITLE_RAW=$(echo "$BASENAME_NO_DATE" | sed 's/\.md$//' | sed 's/-/ /g')
# Title case: capitalize first letter of each word
TITLE=$(echo "$TITLE_RAW" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Destination file
DEST_FILE="$POSTS_DIR/$NEW_FILENAME"

# Create the new frontmatter
cat > "$DEST_FILE" << EOF
---
title: "$TITLE"
layout: post
categories: $CATEGORY
---
EOF

# Check if source file has frontmatter (starts with ---)
if head -1 "$SOURCE_FILE" | grep -q '^---[[:space:]]*$'; then
    # File has frontmatter - extract content after the second ---
    awk '
        /^---[[:space:]]*$/ { count++; next }
        count >= 2 { print }
    ' "$SOURCE_FILE" >> "$DEST_FILE"
else
    # No frontmatter - copy entire file content
    cat "$SOURCE_FILE" >> "$DEST_FILE"
fi

echo "✓ Published: $NEW_FILENAME"
echo "  Title: $TITLE"
echo "  Category: $CATEGORY"
echo "  Location: $DEST_FILE"
