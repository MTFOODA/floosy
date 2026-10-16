"""Audits source files for mojibake (UTF-8 text mis-decoded as CP1252/Latin-1).

Legit Arabic/Unicode text (U+0600-U+06FF, arrows, etc.) is fine. What we flag:
  * any char in the Latin-1 supplement range U+0080-U+00FF (mojibake residue
    like Ã, â, Ø, Ù, Â, ¨, © ...) — these should never appear in source,
  * a stray U+FEFF BOM that is not at position 0 of the file.
"""
import io
import os
import sys

# Windows console may default to a legacy code page; force UTF-8 output so
# legitimate Arabic characters in scanned lines never crash the audit itself.
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except AttributeError:
    pass

ROOTS = [
    r"D:\Codeing\Flutter apps\Floosy\lib",
    r"D:\Codeing\Flutter apps\Floosy\test",
    r"D:\Codeing\Flutter apps\Floosy\android\app\src\main\kotlin",
    r"D:\Codeing\Flutter apps\Floosy\assets\translations",
]
EXTS = (".dart", ".kt", ".arb")

# Char -> most likely intended char (single-level UTF-8→CP1252 mojibake)
FIXES = {
    "â€”": "—",   # em dash
    "â€“": "–",   # en dash
    "â€¢": "•",   # bullet
    "â€˜": "'", "â€™": "'",
    "â€œ": '"', "â€\x9d": '"',
    "â€¦": "…",
    "Ã—": "×",
    "Ã·": "÷",
    "Â«": "«", "Â»": "»",
    "Â·": "·",
    "Â©": "©",
    "Â®": "®",
    "Â°": "°",
}

def is_suspicious(ch):
    o = ord(ch)
    return 0x80 <= o <= 0xFF or ch == "\ufeff"

findings = []
for root in ROOTS:
    if not os.path.isdir(root):
        continue
    for dirpath, _dirs, files in os.walk(root):
        for fn in files:
            if not fn.endswith(EXTS):
                continue
            p = os.path.join(dirpath, fn)
            text = io.open(p, encoding="utf-8").read()
            if text.startswith("\ufeff"):
                findings.append((p, 1, "BOM at start of file", "\ufeff"))
            for lineno, line in enumerate(text.splitlines(), 1):
                for seq, fix in FIXES.items():
                    if seq in line:
                        findings.append((p, lineno, f"mojibake {seq!r} -> {fix!r}", line.strip()[:100]))
                        break
                else:
                    bad = [ch for ch in line if is_suspicious(ch)]
                    if bad:
                        findings.append((p, lineno, "suspicious chars " + "".join(sorted(set(bad))), line.strip()[:100]))

if not findings:
    print("CLEAN: no mojibake found")
else:
    for p, ln, msg, ctx in findings:
        rel = os.path.relpath(p, r"D:\Codeing\Flutter apps\Floosy")
        print(f"{rel}:{ln}: {msg} | {ctx}")
    print(f"TOTAL: {len(findings)} findings")
