enum BaseModelOptions { drift, realtime, server, firestore }

class BaseModel {
  const BaseModel({required this.options});

  final List<BaseModelOptions> options;
}

// Annotation cho các trường độc nhất
class UniqueField {
  const UniqueField();
}

// Annotation cho các trường tham chiếu
class TableRef {
  const TableRef(this.table);

  final String table;
}

const firestoreBaseModel = BaseModel(options: [BaseModelOptions.firestore]);
const driftBaseModel = BaseModel(options: [BaseModelOptions.drift]);
const realtimeBaseModel = BaseModel(options: [BaseModelOptions.realtime]);
const serverBaseModel = BaseModel(options: [BaseModelOptions.server]);
const driftAndServerBaseModel =
    BaseModel(options: [BaseModelOptions.drift, BaseModelOptions.server]);
const allBaseModel = BaseModel(options: [
  BaseModelOptions.drift,
  BaseModelOptions.realtime,
  BaseModelOptions.server,
  BaseModelOptions.firestore,
]);
