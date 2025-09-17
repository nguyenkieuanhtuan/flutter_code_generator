import 'database_type.dart';

class BaseModel {
  const BaseModel({required this.types});

  final List<DatabaseType> types;
}

// Annotation cho các trường độc nhất
class UniqueField {
  const UniqueField();
}

class IdField {
  const IdField();
}

// Annotation cho các trường tham chiếu
class TableRef {
  const TableRef(this.table);

  final String table;
}

const firestoreBaseModel = BaseModel(types: [DatabaseType.firestore]);
const driftBaseModel = BaseModel(types: [DatabaseType.drift]);
const realtimeBaseModel = BaseModel(types: [DatabaseType.realtime]);
const serverBaseModel = BaseModel(types: [DatabaseType.server]);
const driftAndServerBaseModel =
    BaseModel(types: [DatabaseType.drift, DatabaseType.server]);
const allBaseModel = BaseModel(types: [
  DatabaseType.drift,
  DatabaseType.realtime,
  DatabaseType.server,
  DatabaseType.firestore,
]);
