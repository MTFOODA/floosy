import json, io, os

BASE = r"D:\Codeing\Flutter apps\Floosy\assets\translations"

for name in ("app_en.arb", "app_ar.arb"):
    p = os.path.join(BASE, name)
    data = io.open(p, encoding="utf-8").read()
    lines = data.splitlines()
    print("=" * 20, name, "lines:", len(lines))
    depth = 0
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith("//"):
            continue
        d0 = depth
        instr = False
        esc = False
        for ch in stripped:
            if esc:
                esc = False
                continue
            if ch == "\\":
                esc = True
                continue
            if ch == '"':
                instr = not instr
                continue
            if not instr:
                if ch == "{":
                    depth += 1
                elif ch == "}":
                    depth -= 1
        if d0 != depth:
            print(f"{i}: depth {d0}->{depth} | {stripped[:70]}")
    print("final depth:", depth)
    try:
        json.loads(data)
        print("PARSE: OK")
    except Exception as e:
        print("PARSE ERROR:", e)
