
drop policy if exists "Allow access to published free MASTERBOOK files"
on storage.objects;

create policy "Allow access to published free MASTERBOOK files"
on storage.objects
for select
to anon, authenticated
using (
    bucket_id = 'masterbook-resources'
    and exists (
        select 1
        from public.resources
        where resources.storage_path = storage.objects.name
          and resources.status = 'Published'
          and resources.access_tier = 'Free'
    )
);
