-- =====================================================================
-- Tabla de propiedades (solo los administradores pueden verla y editarla)
-- Pégalo entero en: Supabase > SQL Editor > New query > Run
-- Requiere haber ejecutado antes supabase-setup.sql (usa public.is_admin())
-- =====================================================================

create table if not exists public.propiedades (
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('Piso','Casa','Local','Terreno','Otro')),
  metros numeric(10,2) not null check (metros > 0),
  ubicacion text not null check (char_length(ubicacion) between 1 and 200),
  ciudad text not null check (char_length(ciudad) between 1 and 100),
  pais text not null check (char_length(pais) between 1 and 80),
  precio numeric(14,2) not null check (precio >= 0),
  moneda text not null default 'EUR' check (moneda in ('EUR','USD')),
  estado text not null default 'borrador' check (estado in ('borrador','publicada')),
  created_at timestamptz not null default now()
);

alter table public.propiedades enable row level security;

drop policy if exists "admin ve propiedades" on public.propiedades;
create policy "admin ve propiedades" on public.propiedades
  for select to authenticated using (public.is_admin());

drop policy if exists "admin crea propiedades" on public.propiedades;
create policy "admin crea propiedades" on public.propiedades
  for insert to authenticated with check (public.is_admin());

drop policy if exists "admin edita propiedades" on public.propiedades;
create policy "admin edita propiedades" on public.propiedades
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "admin borra propiedades" on public.propiedades;
create policy "admin borra propiedades" on public.propiedades
  for delete to authenticated using (public.is_admin());

grant select, insert, update, delete on public.propiedades to authenticated;
