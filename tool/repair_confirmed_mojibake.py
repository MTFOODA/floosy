from pathlib import Path

replacements = {
    'â†’': '→',
    'â€”': '—',
    'â€¦': '…',
    'â”€': '-',
}
for name in [
    'lib/data/services/sms_transaction_processor.dart',
    'lib/core/localization/preferences_provider.dart',
]:
    path = Path(name)
    text = path.read_text(encoding='utf-8-sig')
    for old, new in replacements.items():
        text = text.replace(old, new)
    path.write_text(text, encoding='utf-8', newline='\n')
