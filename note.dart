class EquipoFutbolFields {
  static const List<String> values = [
    id,
    name,
    year,
    dateTime,
  ];
  static const String tableName = 'equipo_futbol';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String name = 'name';
  static const String year = 'year';
  static const String dateTime = 'date_time';
}

class EquipoFutbolModel {
  int? id;
  final String name;
  final int year;
  final DateTime dateTime;

  EquipoFutbolModel({
    this.id,
    required this.name,
    required this.year,
    required this.dateTime,
  });

  Map<String, Object?> toJson() => {
        EquipoFutbolFields.id: id,
        EquipoFutbolFields.name: name,
        EquipoFutbolFields.year: year,
        EquipoFutbolFields.dateTime: dateTime.toIso8601String(),
      };

  factory EquipoFutbolModel.fromJson(Map<String, Object?> json) => EquipoFutbolModel(
        id: json[EquipoFutbolFields.id] as int?,
        name: json[EquipoFutbolFields.name] as String,
        year: json[EquipoFutbolFields.year] as int,
        dateTime: DateTime.tryParse(json[EquipoFutbolFields.dateTime] as String ?? '') ?? DateTime.now(),
      );

  EquipoFutbolModel copy({
    int? id,
    String? name,
    int? year,
    DateTime? dateTime,
  }) =>
      EquipoFutbolModel(
        id: id ?? this.id,
        name: name ?? this.name,
        year: year ?? this.year,
        dateTime: dateTime ?? this.dateTime,
      );
}
