-- 024_seed_data.sql
-- Seed system data (banks, categories, badges)

-- Insert Egyptian Banks
insert into public.banks (id, name, name_ar, code, country, currency, is_active) values
  (gen_random_uuid(), 'Commercial International Bank (CIB)', 'البنك التجاري الدولي', 'CIB', 'EG', 'EGP', true),
  (gen_random_uuid(), 'National Bank of Egypt', 'البنك الأهلي المصري', 'NBE', 'EG', 'EGP', true),
  (gen_random_uuid(), 'Banque Misr', 'بنك مصر', 'MISR', 'EG', 'EGP', true),
  (gen_random_uuid(), 'QNB Egypt', 'بنك قطر الوطني مصر', 'QNB', 'EG', 'EGP', true),
  (gen_random_uuid(), 'AlexBank', 'بنك الإسكندرية', 'ALEX', 'EG', 'EGP', true),
  (gen_random_uuid(), 'HSBC Egypt', 'بنك HSBC مصر', 'HSBC', 'EG', 'EGP', true),
  (gen_random_uuid(), 'Abu Dhabi Islamic Bank', 'مصرف أبوظبي الإسلامي', 'ADIB', 'EG', 'EGP', true),
  (gen_random_uuid(), 'Emirates NBD', 'بنك الإمارات دبي الوطني', 'ENBD', 'EG', 'EGP', true),
  (gen_random_uuid(), 'FAB Egypt', 'البنك الأول بأبو ظبي', 'FAB', 'EG', 'EGP', true),
  (gen_random_uuid(), 'Bank of Alexandria', 'بنك الإسكندرية', 'ALEX2', 'EG', 'EGP', true),
  (gen_random_uuid(), 'Faisal Bank', 'بنك فيصل', 'FAISAL', 'EG', 'EGP', true);

-- Insert System Categories
insert into public.categories (id, user_id, name, name_ar, type, is_system, is_active) values
  (gen_random_uuid(), null, 'Food & Dining', 'الطعام والمطاعم', 'expense', true, true),
  (gen_random_uuid(), null, 'Transportation', 'المواصلات', 'expense', true, true),
  (gen_random_uuid(), null, 'Groceries', 'البقالة', 'expense', true, true),
  (gen_random_uuid(), null, 'Shopping', 'التسوق', 'expense', true, true),
  (gen_random_uuid(), null, 'Entertainment', 'الترفيه', 'expense', true, true),
  (gen_random_uuid(), null, 'Utilities', 'الفواتير', 'expense', true, true),
  (gen_random_uuid(), null, 'Healthcare', 'الصحة', 'expense', true, true),
  (gen_random_uuid(), null, 'Education', 'التعليم', 'expense', true, true),
  (gen_random_uuid(), null, 'Subscriptions', 'الاشتراكات', 'expense', true, true),
  (gen_random_uuid(), null, 'Other', 'أخرى', 'expense', true, true),
  (gen_random_uuid(), null, 'Salary', 'الراتب', 'income', true, true),
  (gen_random_uuid(), null, 'Freelance', 'عمل حر', 'income', true, true),
  (gen_random_uuid(), null, 'Investment', 'استثمار', 'income', true, true),
  (gen_random_uuid(), null, 'Other Income', 'دخل آخر', 'income', true, true),
  (gen_random_uuid(), null, 'Transfer', 'تحويل', 'transfer', true, true);

-- Insert Badges
insert into public.badges (id, code, name, name_ar, description, description_ar, criteria) values
  (gen_random_uuid(), 'first_expense', 'First Step', 'الخطوة الأولى', 'Record your first expense', 'سجل أول مصروف لك', '{"type": "first_transaction"}'),
  (gen_random_uuid(), 'spending_master', 'Spending Master', 'سيد الإنفاق', 'Track 100 transactions', 'تابع 100 معاملة', '{"type": "transaction_count", "count": 100}'),
  (gen_random_uuid(), 'budget_champion', 'Budget Champion', 'بطل الميزانية', 'Stay within budget for 3 months', 'ابقَ ضمن الميزانية لمدة 3 أشهر', '{"type": "consecutive_months", "count": 3}'),
  (gen_random_uuid(), 'saving_star', 'Saving Star', 'نجم المدخرات', 'Save 10% of income', 'وفر 10% من الدخل', '{"type": "savings_percentage", "percentage": 10}'),
  (gen_random_uuid(), 'reduction_expert', 'Reduction Expert', 'خبير التخفيض', 'Reduce spending by 20%', 'خفض الإنفاق بنسبة 20%', '{"type": "spending_reduction", "percentage": 20}'),
  (gen_random_uuid(), 'consistent_tracker', 'Consistent Tracker', 'المتابع المنتظم', 'Log transactions for 30 days', 'سجل المعاملات لمدة 30 يوم', '{"type": "consecutive_days", "count": 30}'),
  (gen_random_uuid(), 'category_expert', 'Category Expert', 'خبير الفئات', 'Use all expense categories', 'استخدم جميع فئات المصروفات', '{"type": "use_all_categories"}'),
  (gen_random_uuid(), 'pocket_pro', 'Pocket Pro', 'خبير النقد', 'Manage Pocket Cash for 60 days', 'أدر النقد لمدة 60 يوم', '{"type": "pocket_cash_days", "count": 60}');
