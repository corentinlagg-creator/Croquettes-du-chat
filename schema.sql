-- Journal santé : une ligne par jour et par utilisateur.
-- À coller dans Supabase > SQL Editor > New query, puis "Run".

create table if not exists public.journal (
  user_id    uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  date       date        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);

-- Sécurité : chacun ne voit et ne modifie que ses propres lignes.
alter table public.journal enable row level security;

drop policy if exists "lecture perso"      on public.journal;
drop policy if exists "ajout perso"        on public.journal;
drop policy if exists "modification perso" on public.journal;
drop policy if exists "suppression perso"  on public.journal;

create policy "lecture perso"      on public.journal for select using (auth.uid() = user_id);
create policy "ajout perso"        on public.journal for insert with check (auth.uid() = user_id);
create policy "modification perso" on public.journal for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "suppression perso"  on public.journal for delete using (auth.uid() = user_id);

-- Vue à plat pour interroger directement en SQL (Supabase > Table Editor ou SQL Editor).
create or replace view public.journal_plat with (security_invoker = true) as
select
  j.date,
  (j.data->'sommeil'->>'score')::numeric        as sommeil_score,
  j.data->'sommeil'->>'coucher'                 as coucher,
  j.data->'sommeil'->>'lever'                   as lever,
  (j.data->'sommeil'->>'duree_min')::numeric    as sommeil_duree_min,
  (j.data->'fc'->>'repos')::numeric             as fc_repos,
  (j.data->'fc'->>'vfc')::numeric               as vfc,
  j.data->>'type_jour'                          as type_jour,
  (j.data->>'sport')::boolean                   as sport,
  jsonb_array_length(coalesce(j.data->'activites','[]'::jsonb)) as nb_activites,
  (j.data->>'pas')::numeric                     as pas,
  (j.data->>'cafes')::numeric                   as cafes,
  (j.data->>'alcool')::numeric                  as alcool,
  (j.data->>'sieste')::boolean                  as sieste,
  (j.data->>'sieste_min')::numeric              as sieste_min,
  (j.data->>'stress')::numeric                  as stress,
  j.data->>'symptomes'                          as symptomes,
  j.data                                        as brut
from public.journal j;
