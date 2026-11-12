
create table if not exists public.resources (
    id uuid primary key default gen_random_uuid(),
    title text not null,
    description text,
    education_level text check (
        education_level in (
            'Primary',
            'Junior School',
            'Senior School',
            'University',
            'Professional'
        )
    ),
    subject text not null,
    resource_type text check (
        resource_type in (
            'Notes',
            'Revision Paper',
            'Coursebook',
            'Lesson Plan',
            'Research',
            'Video',
            'Other'
        )
    ),
    curriculum text default 'Kenyan CBC',
    access_tier text default 'Free' check (
        access_tier in ('Free', 'Premium')
    ),
    status text default 'Draft' check (
        status in ('Draft', 'Published', 'Archived')
    ),
    storage_path text,
    created_by uuid references auth.users(id),
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

alter table public.resources enable row level security;

grant select on public.resources to anon, authenticated;

drop policy if exists "Public can read published free resources"
on public.resources;

create policy "Public can read published free resources"
on public.resources
for select
to anon, authenticated
using (
    status = 'Published'
    and access_tier = 'Free'
);
