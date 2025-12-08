#!/bin/bash
# Komprimiert Bilder für PocketBase - HOHE QUALITÄT
# WebP 95% Qualität, volle Auflösung beibehalten

SRC_DIR="seed_images"
OUT_DIR="seed_images_compressed"

mkdir -p "$OUT_DIR"

echo "=== Bild-Komprimierung (Hohe Qualität) ==="
echo "Quelle: $SRC_DIR"
echo "Ziel: $OUT_DIR"
echo "Format: WebP, 95% Qualität, volle Auflösung"
echo ""

shopt -s nullglob
count=0
for img in "$SRC_DIR"/*.png "$SRC_DIR"/*.jpg "$SRC_DIR"/*.jpeg; do
    filename=$(basename "$img")
    name="${filename%.*}"
    outfile="$OUT_DIR/${name}.webp"

    echo -n "[$((++count))] $filename ... "

    # WebP mit 95% Qualität - visuell identisch zum Original
    # Keine Grössenänderung - volle Auflösung behalten
    convert "$img" -quality 95 "$outfile"

    # Grössen vergleichen
    orig_size=$(stat -c%s "$img" 2>/dev/null || stat -f%z "$img")
    new_size=$(stat -c%s "$outfile" 2>/dev/null || stat -f%z "$outfile")
    orig_kb=$((orig_size / 1024))
    new_kb=$((new_size / 1024))
    savings=$(( (orig_size - new_size) * 100 / orig_size ))

    echo "${orig_kb}KB -> ${new_kb}KB (-${savings}%)"
done

echo ""
echo "=== Fertig! ==="
echo "Anzahl Bilder: $count"
echo ""
echo "Vergleich:"
echo -n "  Original:    " && du -sh "$SRC_DIR"
echo -n "  Komprimiert: " && du -sh "$OUT_DIR"
