enum BaseModelOption { drift, realtime, server, firestore }

class BaseModel {
  const BaseModel({this.options = const [BaseModelOption.firestore]});

  final List<BaseModelOption> options;
}
