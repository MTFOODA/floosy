"""Build labelled, synthetic SMS regression data from the offline directory.

These fixtures are NOT captured customer messages or verified bank templates.
Public sources establish service facts only; see docs/bank-sms-corpus.md.
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
templates = [
    ('purchase', 'en', 'Purchase of EGP 125.50 using card ending 1234 at TEST SHOP on 20/11/2026 10:30. Available balance EGP 9000.00.', 'purchase', -1, 12550, '1234'),
    ('purchase', 'ar', 'تمت عملية شراء بمبلغ ١٢٥.٥٠ جنيه باستخدام بطاقة تنتهي 1234 عند TEST SHOP بتاريخ 20/11/2026 10:30.', 'purchase', -1, 12550, '1234'),
    ('atm_withdrawal', 'en', 'ATM cash withdrawal of EGP 250.00 using card ending 1234 on 20/11/2026 10:31.', 'atm_withdrawal', -1, 25000, '1234'),
    ('deposit', 'en', 'Cash deposit of EGP 800.00 to your account ending 5678 on 20/11/2026 10:32.', 'income', 1, 80000, None),
    ('salary', 'en', 'Salary credited to your account ending 5678 amount EGP 5000.00 on 20/11/2026 10:33.', 'income', 1, 500000, None),
    ('transfer_in', 'en', 'Transfer received EGP 450.00 credited to your account ending 5678 on 20/11/2026 10:34.', 'transfer_in', 1, 45000, None),
    ('transfer_out', 'en', 'Transfer sent EGP 350.00 debited from your account ending 5678 on 20/11/2026 10:35.', 'transfer_out', -1, 35000, None),
    ('transfer_in', 'ar', 'تم إضافة تحويل IPN إلى حسابكم رقم 5678 بمبلغ ٤٥٠.٠٠ جم بتاريخ 20/11/2026 10:36.', 'transfer_in', 1, 45000, None),
    ('refund', 'en', 'Refund of EGP 125.50 credited to your card ending 1234 on 20/11/2026 10:37.', 'refund', 1, 12550, '1234'),
    ('reversal', 'en', 'Reversal of EGP 125.50 credited to your card ending 1234 on 20/11/2026 10:38.', 'refund', 1, 12550, '1234'),
    ('otp', 'en', 'OTP 999999 to authorize purchase EGP 125.50 using card ending 1234. Do not share this code.', None, 0, 12550, '1234'),
    ('declined', 'en', 'Purchase of EGP 125.50 using card ending 1234 was declined.', None, 0, 12550, '1234'),
    ('marketing', 'en', 'Discover our latest card offers and discounts. Apply now.', None, 0, None, None),
    ('balance_only', 'en', 'Your available balance EGP 9000.00.', None, 0, None, None),
    ('unknown_direction', 'en', 'Transfer amount EGP 350.00. Reference DEMO-0001.', None, 0, 35000, None),
]


def main():
    source = (ROOT / 'lib/domain/entities/bank_directory.dart').read_text(encoding='utf-8')
    entries = re.findall(r"KnownBank\(\s*code: '([^']+)'.*?name: '([^']+)'.*?domain: '([^']+)'", source, re.S)
    samples = []
    institutions = []
    for code, name, domain in entries:
        institutions.append({'code': code, 'name': name, 'website': f'https://{domain}',
                             'template_status': 'synthetic_only', 'verified_live_templates': 0})
        for index, (nature, lang, body, kind, direction, amount, last4) in enumerate(templates):
            samples.append({'id': f'{code.lower()}-{nature}-{lang}-{index}', 'institution_code': code,
                'sender': code, 'sender_status': 'synthetic_identifier', 'language': lang,
                'body': body, 'provenance': 'synthetic', 'nature': nature,
                'expected': {'bank_code': code, 'type': kind, 'direction': direction,
                    'amount_minor': amount, 'currency': 'EGP', 'card_last4': last4,
                    'creates_transaction': kind is not None and amount is not None}})
    corpus = {'schema_version': 1, 'reviewed_on': '2026-11-20',
              'notice': 'Synthetic regression data. Not verified SMS wording from these institutions. Never use as proof that a sender is authentic.',
              'public_sources': [
                {'url': 'https://www.hsbc.com.eg/ways-to-bank/mobile/text-alerts/',
                 'supports': 'HSBC sender, English-only alerts, deposits/withdrawals/card transactions; not exact SMS text.'},
                {'url': 'https://www.cbe.org.eg/en/payment-systems-and-services/instant-payment-network',
                 'supports': 'IPN service and participating banks; not exact SMS text.'},
                {'url': 'https://www.eg.kfh.com/faqs/', 'supports': 'KFH Egypt rebrand; not SMS text.'},
                {'url': 'https://nxtwin.banknxteg.com/pages/about', 'supports': 'aiBANK rebrand to Bank NXT; not SMS text.'},
              ], 'institutions': institutions, 'samples': samples}
    path = ROOT / 'assets/data/bank_sms_corpus.json'
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(corpus, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'{len(institutions)} institutions; {len(samples)} synthetic labelled samples')


if __name__ == '__main__':
    main()
