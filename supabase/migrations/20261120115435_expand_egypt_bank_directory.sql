-- Extend the bank reference catalog without replacing UUIDs or existing
-- persisted English names. ALEX2 is a historical duplicate: keep it so foreign
-- keys remain valid; the offline identity directory resolves its branding.
-- Logos used in the app are bundled in assets/banks; URLs are reference data.
begin;
insert into public.banks (name, name_ar, code, logo_url, country, currency, is_active)
values
  ('Commercial International Bank', 'البنك التجاري الدولي', 'CIB', 'https://www.google.com/s2/favicons?domain=cibeg.com&sz=128', 'EG', 'EGP', true),
  ('National Bank of Egypt', 'البنك الأهلي المصري', 'NBE', 'https://www.google.com/s2/favicons?domain=nbe.com.eg&sz=128', 'EG', 'EGP', true),
  ('Banque Misr', 'بنك مصر', 'MISR', 'https://www.google.com/s2/favicons?domain=banquemisr.com&sz=128', 'EG', 'EGP', true),
  ('QNB Egypt', 'بنك قطر الوطني مصر', 'QNB', 'https://www.google.com/s2/favicons?domain=qnb.com.eg&sz=128', 'EG', 'EGP', true),
  ('AlexBank', 'بنك الإسكندرية', 'ALEX', 'https://www.google.com/s2/favicons?domain=alexbank.com&sz=128', 'EG', 'EGP', true),
  ('HSBC Egypt', 'بنك HSBC مصر', 'HSBC', 'https://www.google.com/s2/favicons?domain=hsbc.com.eg&sz=128', 'EG', 'EGP', true),
  ('Abu Dhabi Islamic Bank', 'مصرف أبوظبي الإسلامي', 'ADIB', 'https://www.google.com/s2/favicons?domain=adib.eg&sz=128', 'EG', 'EGP', true),
  ('Emirates NBD', 'بنك الإمارات دبي الوطني', 'ENBD', 'https://www.google.com/s2/favicons?domain=emiratesnbd.com.eg&sz=128', 'EG', 'EGP', true),
  ('FAB Egypt', 'البنك الأول بأبو ظبي', 'FAB', 'https://www.fabmisr.com.eg/-/media/Project/FAB2/Fab2/data/media/img/FAB-favicon.ico', 'EG', 'EGP', true),
  ('Arab African International Bank', 'البنك العربي الأفريقي الدولي', 'AAIB', 'https://aaib.com/favicon.ico', 'EG', 'EGP', true),
  ('Faisal Bank', 'بنك فيصل', 'FAISAL', 'https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/45/b1/73/45b17381-89d9-a6ea-05f5-563151c19285/AppIcon-1x_U007emarketing-0-8-0-85-220-0.png/512x512bb.jpg', 'EG', 'EGP', true),
  ('Banque du Caire', 'بنك القاهرة', 'BDC', 'https://www.google.com/s2/favicons?domain=bdc.com.eg&sz=128', 'EG', 'EGP', true),
  ('Credit Agricole Egypt', 'كريدي أجريكول مصر', 'CAE', 'https://www.google.com/s2/favicons?domain=ca-egypt.com&sz=128', 'EG', 'EGP', true),
  ('Abu Dhabi Commercial Bank', 'بنك أبوظبي التجاري', 'ADCB', 'https://www.adcb.com.eg/wp-content/uploads/2020/08/cropped-logo-32x32.png', 'EG', 'EGP', true),
  ('Al Ahli Bank of Kuwait Egypt', 'البنك الأهلي الكويتي مصر', 'ABK', 'https://www.google.com/s2/favicons?domain=abkegypt.com&sz=128', 'EG', 'EGP', true),
  ('National Bank of Kuwait Egypt', 'بنك الكويت الوطني مصر', 'NBK', 'https://www.google.com/s2/favicons?domain=nbk.com&sz=128', 'EG', 'EGP', true),
  ('Kuwait Finance House Egypt', 'بيت التمويل الكويتي مصر', 'KFH', 'https://www.eg.kfh.com/wp-content/uploads/2025/01/cropped-kfh-favicon-192x192.png', 'EG', 'EGP', true),
  ('EG Bank', 'البنك المصري الخليجي', 'EGBANK', 'https://www.google.com/s2/favicons?domain=eg-bank.com&sz=128', 'EG', 'EGP', true),
  ('Export Development Bank of Egypt', 'البنك المصري لتنمية الصادرات', 'EBANK', 'https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/10/14/7e/10147ee1-8231-2eac-1a2f-27f6823f5d02/AppIcon-0-0-1x_U007emarketing-0-11-0-0-85-220.png/512x512bb.jpg', 'EG', 'EGP', true),
  ('Housing and Development Bank', 'بنك التعمير والإسكان', 'HDB', 'https://www.google.com/s2/favicons?domain=www.hdb-egy.com&sz=128', 'EG', 'EGP', true),
  ('SAIB Bank', 'بنك saib', 'SAIB', 'https://www.google.com/s2/favicons?domain=saib.com.eg&sz=128', 'EG', 'EGP', true),
  ('Suez Canal Bank', 'بنك قناة السويس', 'SCB', 'https://scbank.com.eg/images/favicon.png', 'EG', 'EGP', true),
  ('Bank ABC Egypt', 'بنك ABC مصر', 'ABC', 'https://www.google.com/s2/favicons?domain=bank-abc.com&sz=128', 'EG', 'EGP', true),
  ('Arab Bank', 'البنك العربي', 'ARAB', 'https://www.google.com/s2/favicons?domain=arabbank.com.eg&sz=128', 'EG', 'EGP', true),
  ('Arab International Bank', 'المصرف العربي الدولي', 'AIB', 'https://www.google.com/s2/favicons?domain=aib.com.eg&sz=128', 'EG', 'EGP', true),
  ('Bank NXT', 'بنك نكست', 'NXT', 'https://www.google.com/s2/favicons?domain=banknxteg.com&sz=128', 'EG', 'EGP', true),
  ('MIDBANK', 'ميد بنك', 'MIDBANK', 'https://www.logodalil.com.eg/images/Banks_logos/midbank.jpg', 'EG', 'EGP', true),
  ('Egyptian Arab Land Bank', 'البنك العقاري المصري العربي', 'EALB', 'https://www.eal-bank.com/VI/images/logo-icon.png', 'EG', 'EGP', true),
  ('Agricultural Bank of Egypt', 'البنك الزراعي المصري', 'ABE', 'https://abe.com.eg/assets/img/logo.png', 'EG', 'EGP', true),
  ('Industrial Development Bank', 'بنك التنمية الصناعية', 'IDB', 'https://idb.com.eg/media/1yspvaw2/favicon.ico', 'EG', 'EGP', true),
  ('The United Bank', 'المصرف المتحد', 'UB', 'https://www.theubeg.com/favicon.ico', 'EG', 'EGP', true),
  ('Al Baraka Bank Egypt', 'بنك البركة مصر', 'ALBARAKA', 'https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/f0/c9/8d/f0c98d20-d5a5-6789-6c0b-15b74336a262/AppIcon-0-0-1x_U007emarketing-0-11-0-85-220.png/512x512bb.jpg', 'EG', 'EGP', true),
  ('Attijariwafa Bank Egypt', 'التجاري وفا بنك مصر', 'ATTIJARI', 'https://www.google.com/s2/favicons?domain=attijariwafabank.com.eg&sz=128', 'EG', 'EGP', true),
  ('Mashreq Bank Egypt', 'بنك المشرق مصر', 'MASHREQ', 'https://www.google.com/s2/favicons?domain=mashreq.com&sz=128', 'EG', 'EGP', true),
  ('Citibank Egypt', 'سيتي بنك مصر', 'CITI', 'https://www.google.com/s2/favicons?domain=citibank.com&sz=128', 'EG', 'EGP', true),
  ('Standard Chartered Egypt', 'ستاندرد تشارترد مصر', 'SC', 'https://www.google.com/s2/favicons?domain=sc.com&sz=128', 'EG', 'EGP', true),
  ('onebank', 'وان بنك', 'ONEBANK', 'https://www.google.com/s2/favicons?domain=onebank.eg&sz=128', 'EG', 'EGP', true),
  ('Nasser Social Bank', 'بنك ناصر الاجتماعي', 'NASSER', 'https://www.google.com/s2/favicons?domain=nsb.gov.eg&sz=128', 'EG', 'EGP', true)
on conflict (code) do update
set name_ar = excluded.name_ar,
    logo_url = excluded.logo_url;

update public.banks
set logo_url = (select logo_url from public.banks where code = 'ALEX')
where code = 'ALEX2';
commit;
