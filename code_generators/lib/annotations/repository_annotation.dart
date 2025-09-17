import 'database_type.dart';

class BaseRepository {
  const BaseRepository({required this.types, this.collectionName, this.model});

  final List<DatabaseType> types;
  final String? collectionName;
  final Type? model;
}
