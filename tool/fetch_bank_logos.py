"""Cache bank website icons for offline display; retain each source URL.

Run explicitly when refreshing brands. No network is used by the app.
"""
import concurrent.futures
import io
import json
import re
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.parse import urljoin
from html.parser import HTMLParser
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
DIRECTORY = ROOT / 'assets' / 'banks'


class IconLinks(HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == 'link' and 'icon' in attrs.get('rel', '') and attrs.get('href'):
            self.links.append(attrs['href'])


def fetch(entry):
    code, domain = entry
    target = DIRECTORY / f'{code.lower()}.png'
    existing = json.loads((DIRECTORY / 'sources.json').read_text(encoding='utf-8')) if (DIRECTORY / 'sources.json').exists() else {}
    same_website = existing.get(code, {}).get('website') == f'https://{domain}'
    if target.exists() and 'asset' in existing.get(code, {}) and same_website:
        return code, existing[code]
    candidates = [f'https://www.google.com/s2/favicons?domain={domain}&sz=128',
                  f'https://www.google.com/s2/favicons?domain=www.{domain}&sz=128']
    if existing.get(code, {}).get('source') and same_website:
        candidates.insert(0, existing[code]['source'])
    for origin in [f'https://{domain}', f'https://www.{domain}']:
        try:
            with urlopen(Request(origin, headers={'User-Agent': 'Mozilla/5.0'}), timeout=15) as response:
                parser = IconLinks()
                parser.feed(response.read(2000000).decode('utf-8', errors='replace'))
                candidates.extend(urljoin(response.url, link) for link in parser.links)
        except Exception:
            pass
        candidates.append(origin + '/favicon.ico')
    error = 'No raster icon found'
    for url in candidates:
        try:
            with urlopen(Request(url, headers={'User-Agent': 'Mozilla/5.0'}), timeout=12) as response:
                content = response.read()
            icon = Image.open(io.BytesIO(content)).convert('RGBA')
            if icon.width < 16:
                continue
            icon.save(target)
            return code, {'website': f'https://{domain}', 'source': url, 'width': icon.width, 'asset': str(target.relative_to(ROOT)).replace('\\', '/')}
        except Exception as problem:
            error = str(problem)
    return code, {'website': f'https://{domain}', 'error': error}


if __name__ == '__main__':
    DIRECTORY.mkdir(parents=True, exist_ok=True)
    source = (ROOT / 'lib/domain/entities/bank_directory.dart').read_text(encoding='utf-8')
    entries = re.findall(r"KnownBank\(\s*code: '([^']+)'.*?domain: '([^']+)'", source, re.S)
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as pool:
        result = dict(pool.map(fetch, entries))
    (DIRECTORY / 'sources.json').write_text(json.dumps(result, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(json.dumps({'downloaded': sum('asset' in v for v in result.values()), 'failed': {k: v['error'] for k, v in result.items() if 'error' in v}}))
