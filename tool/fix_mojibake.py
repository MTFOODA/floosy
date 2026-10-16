"""Repairs mojibake (UTF-8 text mis-decoded as CP1252/Latin-1) in source files.

Algorithm: find maximal runs of mojibake-suspicious characters, then
repeatedly apply  run -> utf8_decode(cp1252_bytes(run))  until it no longer
decodes (fixes single-, double- and multi-level corruption in one pass).
Legitimate non-ASCII characters (×, ·, £, €, Arabic, •, —) either fail to
re-decode or round-trip to themselves, so they are never touched. Also
strips a stray U+FEFF BOM at the start of a file.
"""
import io
import os

BASE = r"D:\Codeing\Flutter apps\Floosy"
FILES = [
    r"lib\features\settings\presentation\widgets\detected_bank_card.dart",
    r"lib\features\dashboard\presentation\widgets\dashboard_items_section.dart",
    r"lib\features\items\presentation\screens\items_screen.dart",
]

# Characters that are the CP1252 rendering of bytes 0x80-0x9F (€, ‚, ƒ, …,
# ", ", –, — etc.) — the classic mojibake residue. Built programmatically so
# no literal curly quotes are needed in this source.
CP1252_EXTRAS = {bytes([b]).decode("cp1252", errors="ignore")
                 for b in range(0x80, 0xA0)} - {""}


def suspicious(ch):
    o = ord(ch)
    return 0x80 <= o <= 0xFF or ch in CP1252_EXTRAS


def to_byte(ch):
    """CP1252 byte for ch, falling back to the raw Latin-1 byte for the five
    code points CP1252 leaves undefined (U+0081, U+008D, U+008F, U+0090,
    U+009D) — the mojibake producers that wrote them used a fallback."""
    try:
        return ch.encode("cp1252")
    except UnicodeEncodeError:
        o = ord(ch)
        if 0x80 <= o <= 0xFF:
            return bytes([o])
        raise


def repair_run(run):
    """Repeatedly re-decode the run as UTF-8 while possible."""
    rounds = 0
    while rounds < 8:
        try:
            decoded = b"".join(to_byte(c) for c in run).decode("utf-8")
        except (UnicodeEncodeError, UnicodeDecodeError):
            break
        if decoded == run:
            break
        run = decoded
        rounds += 1
    return run, rounds


def repair_text(text):
    out = []
    repairs = 0
    i = 0
    n = len(text)
    while i < n:
        if suspicious(text[i]):
            j = i
            while j < n and suspicious(text[j]):
                j += 1
            run = text[i:j]
            fixed, rounds = repair_run(run)
            if rounds:
                repairs += 1
                print(f"    repaired {run!r} -> {fixed!r} ({rounds} round(s))")
                out.append(fixed)
            else:
                out.append(run)
            i = j
        else:
            out.append(text[i])
            i += 1
    return "".join(out), repairs


changed_any = False
for rel in FILES:
    p = os.path.join(BASE, rel)
    text = io.open(p, encoding="utf-8").read()
    print(f"== {rel}")
    had_bom = text.startswith("\ufeff")
    if had_bom:
        text = text.lstrip("\ufeff")
        print("    removed U+FEFF BOM")
    fixed, repairs = repair_text(text)
    if had_bom or repairs:
        io.open(p, "w", encoding="utf-8", newline="").write(fixed)
        changed_any = True
        print(f"    WRITTEN ({repairs} repair(s))")
    else:
        print("    no changes")
print("DONE", "changes applied" if changed_any else "no changes needed")
