class MoreliaLocation {
  final String name;
  final String address;
  final String neighborhood;
  final double latitude;
  final double longitude;

  const MoreliaLocation({
    required this.name,
    required this.address,
    required this.neighborhood,
    required this.latitude,
    required this.longitude,
  });
}

class MoreliaLocations {
  // Centro Histórico - Catedral de Morelia
  static const MoreliaLocation catedral = MoreliaLocation(
    name: 'Catedral de Morelia / Plaza de Armas',
    address: 'Av. Francisco I. Madero Poniente #250',
    neighborhood: 'Centro Histórico',
    latitude: 19.702750,
    longitude: -101.194100,
  );

  // Acueducto / Las Tarascas
  static const MoreliaLocation acueducto = MoreliaLocation(
    name: 'Las Tarascas / Acueducto',
    address: 'Calzada Fray Antonio de San Miguel esq. Acueducto',
    neighborhood: 'Centro / San Diego',
    latitude: 19.701500,
    longitude: -101.177200,
  );

  // Salida Pátzcuaro / La Huerta
  static const MoreliaLocation laHuerta = MoreliaLocation(
    name: 'Calzada La Huerta',
    address: 'Calzada La Huerta #840',
    neighborhood: 'Col. Los Pinos',
    latitude: 19.679200,
    longitude: -101.207800,
  );

  // Ceconexpo / Camelinas
  static const MoreliaLocation camelinas = MoreliaLocation(
    name: 'Av. Camelinas esq. Ventura Puente',
    address: 'Av. Camelinas #2400',
    neighborhood: 'Col. Félix Ireta / Ceconexpo',
    latitude: 19.684500,
    longitude: -101.183400,
  );

  // Las Américas
  static const MoreliaLocation lasAmericas = MoreliaLocation(
    name: 'Plaza Las Américas',
    address: 'Av. Enrique Ramírez Miguel #310',
    neighborhood: 'Col. Chapultepec Oriente',
    latitude: 19.688500,
    longitude: -101.162800,
  );

  // Zoológico de Morelia
  static const MoreliaLocation zoologico = MoreliaLocation(
    name: 'Zoológico Benito Juárez',
    address: 'Calzada Juárez #340',
    neighborhood: 'Col. Villa Universidad',
    latitude: 19.682800,
    longitude: -101.196500,
  );

  // Estadio Morelos
  static const MoreliaLocation estadioMorelos = MoreliaLocation(
    name: 'Estadio Morelos',
    address: 'Periférico Paseo de la República Norte km 14',
    neighborhood: 'Sector Revolución',
    latitude: 19.728500,
    longitude: -101.231000,
  );

  static const List<MoreliaLocation> all = [
    catedral,
    acueducto,
    laHuerta,
    camelinas,
    lasAmericas,
    zoologico,
    estadioMorelos,
  ];
}
