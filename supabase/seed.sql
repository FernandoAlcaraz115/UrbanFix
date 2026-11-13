-- ========================================================
-- UrbanFix: Seed Data para H. Ayuntamiento de Morelia, Michoacán
-- ========================================================

-- Categorías
INSERT INTO categories (id, name, slug, icon, color, department, sla_hours) VALUES
('cat_bache', 'Bache / Asfalto Dañado', 'bache', 'Cone', '#F59E0B', 'Secretaría de Obras Públicas de Morelia', 72),
('cat_luminaria', 'Luminaria Fundida / Apagada', 'luminaria', 'Lightbulb', '#EAB308', 'Dirección de Alumbrado Público de Morelia', 48),
('cat_fuga', 'Fuga de Agua Potable / Drenaje', 'fuga', 'Droplets', '#06B6D4', 'OOAPAS Morelia (Agua Potable y Alcantarillado)', 24),
('cat_semaforo', 'Semáforo Averiado', 'semaforo', 'TrafficLight', '#EF4444', 'Secretaría de Movilidad Urbana (SEMOV Morelia)', 12),
('cat_basura', 'Basura Acumulada / Escombros', 'basura', 'Trash2', '#10B981', 'Secretaría de Servicios Públicos y Limpia', 36)
ON CONFLICT (id) DO NOTHING;

-- Cuadrillas Municipales de Morelia
INSERT INTO crews (id, name, department, lead_technician, phone, status, active_tasks) VALUES
('b1000000-0000-0000-0000-000000000001', 'Obras Públicas — Cuadrilla Bacheo Centro Histórico', 'Obras Públicas Morelia', 'Ing. Carlos Mendoza Rangel', '443-312-4580', 'busy', 2),
('b1000000-0000-0000-0000-000000000002', 'Alumbrado Morelia — Brigada Camelinas y Acueducto', 'Alumbrado Público', 'Tec. Roberto Gómez Pantoja', '443-324-1188', 'available', 1),
('b1000000-0000-0000-0000-000000000003', 'OOAPAS Morelia — Brigada Hidráulica 24/7', 'OOAPAS Morelia', 'Ing. Sofía Valdés Cárdenas', '443-113-2200', 'busy', 2),
('b1000000-0000-0000-0000-000000000004', 'SEMOV Morelia — Control Semafórico Poniente', 'Movilidad Morelia', 'Téc. Fernando Ruiz Bedolla', '443-317-9022', 'available', 1),
('b1000000-0000-0000-0000-000000000005', 'Limpia Morelia — Cuadrilla La Huerta y Parques', 'Servicios Públicos', 'Marcos Peralta Villaseñor', '443-322-0600', 'available', 0)
ON CONFLICT (id) DO NOTHING;

-- Reportes iniciales con coordenadas reales en Morelia, Michoacán
INSERT INTO reports (
    id, ticket_number, title, description, category_id, status, priority, 
    latitude, longitude, address, neighborhood, photo_url, citizen_name, 
    assigned_crew_id, upvotes_count, created_at
) VALUES
(
    'c1000000-0000-0000-0000-000000000001',
    'UF-MOR-0101',
    'Bache profundo frente a Plaza de Armas',
    'Bache de aprox. 45cm de diámetro que causa ponchaduras constantes sobre Av. Madero Poniente.',
    'cat_bache',
    'in_progress',
    'high',
    19.702750, -101.194100,
    'Av. Francisco I. Madero Poniente #250',
    'Centro Histórico',
    'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=600&auto=format&fit=crop&q=80',
    'Alejandro Silva',
    'b1000000-0000-0000-0000-000000000001',
    18,
    NOW() - INTERVAL '1 day'
),
(
    'c1000000-0000-0000-0000-000000000002',
    'UF-MOR-0102',
    'Fuga abundante de agua potable en banqueta rumbo a Pátzcuaro',
    'Tubería rota bajo banqueta brotando agua potable a presión sobre carril lateral de Calzada La Huerta.',
    'cat_fuga',
    'assigned',
    'critical',
    19.679200, -101.207800,
    'Calzada La Huerta #840',
    'Col. Los Pinos',
    'https://images.unsplash.com/photo-1541888946425-d0fbb18615f3?w=600&auto=format&fit=crop&q=80',
    'Mariana López Tinoco',
    'b1000000-0000-0000-0000-000000000003',
    34,
    NOW() - INTERVAL '4 hours'
),
(
    'c1000000-0000-0000-0000-000000000003',
    'UF-MOR-0103',
    'Luminaria apagada en Calzada San Diego / Las Tarascas',
    'Lámpara fundida dejando el andador peatonal colonial a oscuras e inseguro por la noche.',
    'cat_luminaria',
    'pending',
    'medium',
    19.701500, -101.177200,
    'Calzada Fray Antonio de San Miguel esq. Acueducto',
    'Centro / San Diego',
    'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?w=600&auto=format&fit=crop&q=80',
    'Esteban Morales Hinojosa',
    NULL,
    9,
    NOW() - INTERVAL '2 days'
),
(
    'c1000000-0000-0000-0000-000000000004',
    'UF-MOR-0104',
    'Semáforo apagado en cruce transitado Camelinas y Ventura Puente',
    'Semáforo intermitente frente a Ceconexpo, alto riesgo de choques y atropellamiento.',
    'cat_semaforo',
    'in_review',
    'critical',
    19.684500, -101.183400,
    'Av. Camelinas esq. Av. Ventura Puente',
    'Col. Félix Ireta / Ceconexpo',
    'https://images.unsplash.com/photo-1572970725354-93ff912a208c?w=600&auto=format&fit=crop&q=80',
    'Rodrigo Casas Medina',
    NULL,
    42,
    NOW() - INTERVAL '1 hour'
),
(
    'c1000000-0000-0000-0000-000000000005',
    'UF-MOR-0105',
    'Bache reparado y reencarpetado en Av. Acueducto',
    'Reparación concluida con asfalto AC-20 pasando el Bosque Cuauhtémoc.',
    'cat_bache',
    'resolved',
    'medium',
    19.700800, -101.171200,
    'Av. Acueducto #1050',
    'Col. Chapultepec Norte',
    'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=600&auto=format&fit=crop&q=80',
    'Patricio Vega Ruiz',
    'b1000000-0000-0000-0000-000000000001',
    11,
    NOW() - INTERVAL '5 days'
)
ON CONFLICT (id) DO NOTHING;
