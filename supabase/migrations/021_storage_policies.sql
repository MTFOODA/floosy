-- 021_storage_policies.sql
-- Supabase Storage buckets and policies

-- Note: Buckets are typically created via the Supabase dashboard or CLI
-- This SQL creates the access policies

-- Policies for avatars bucket
create policy "Users can view avatars"
  on storage.objects for select
  using (bucket_id = 'avatars');

create policy "Users can upload own avatars"
  on storage.objects for insert
  with check (
    bucket_id = 'avatars' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can update own avatars"
  on storage.objects for update
  using (
    bucket_id = 'avatars' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can delete own avatars"
  on storage.objects for delete
  using (
    bucket_id = 'avatars' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Policies for item-images bucket
create policy "Users can view item images"
  on storage.objects for select
  using (
    bucket_id = 'item-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can upload item images"
  on storage.objects for insert
  with check (
    bucket_id = 'item-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can update item images"
  on storage.objects for update
  using (
    bucket_id = 'item-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can delete item images"
  on storage.objects for delete
  using (
    bucket_id = 'item-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Policies for receipt-images bucket
create policy "Users can view receipt images"
  on storage.objects for select
  using (
    bucket_id = 'receipt-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can upload receipt images"
  on storage.objects for insert
  with check (
    bucket_id = 'receipt-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can update receipt images"
  on storage.objects for update
  using (
    bucket_id = 'receipt-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can delete receipt images"
  on storage.objects for delete
  using (
    bucket_id = 'receipt-images' 
    and (storage.foldername(name))[1] = auth.uid()::text
  );
