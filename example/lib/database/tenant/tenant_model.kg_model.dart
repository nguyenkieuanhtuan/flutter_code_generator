// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_model.dart';

// **************************************************************************
// ModelGenerator
// **************************************************************************

// Log:  visitFieldElement String id /// DataField visitFieldElement String personalID /// DataField visitFieldElement String name /// DataField visitFieldElement DateTime birthday /// DataField visitFieldElement String gender /// DataField visitFieldElement String address /// DataField visitFieldElement String phone /// DataField visitFieldElement String note /// DataField visitFieldElement RoomModel room /// DataField isModel visitFieldElement DateTime createdAt /// DataField visitFieldElement DateTime rentedAt /// DataField visitFieldElement DateTime returnedAt /// DataField visitFieldElement List<Object?> props null visitConstructorElement null visitConstructorElement /// Connect the generated [_$TenantModelFromJson] function to the `fromJson`
/// factory. visitMethodElement Map<String, dynamic> toJson() visitMethodElement TenantModel fromMap(Map<String, dynamic> map) visitMethodElement Map<String, dynamic> toMap() visitMethodElement Map<String, dynamic> toFirebaseDatabaseMap()
// {id: Instance of 'DataField', personalID: Instance of 'DataField', name: Instance of 'DataField', birthday: Instance of 'DataField', gender: Instance of 'DataField', address: Instance of 'DataField', phone: Instance of 'DataField', note: Instance of 'DataField', room: Instance of 'DataField', createdAt: Instance of 'DataField', rentedAt: Instance of 'DataField', returnedAt: Instance of 'DataField'}

// Extension for a TenantModel class to provide 'copyWith' method
extension $TenantModelExtension on TenantModel {
  bool get hasID => id != null && id.isNotEmpty;

  TenantModel copyWith({
    String? id,
    String? personalID,
    String? name,
    DateTime? birthday,
    String? gender,
    String? address,
    String? phone,
    String? note,
    RoomModel? room,
    DateTime? createdAt,
    DateTime? rentedAt,
    DateTime? returnedAt,
  }) {
    return TenantModel(
      id: id ?? this.id,
      personalID: personalID ?? this.personalID,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      note: note ?? this.note,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
      rentedAt: rentedAt ?? this.rentedAt,
      returnedAt: returnedAt ?? this.returnedAt,
    );
  }
}

// To Map Method
Map<String, dynamic> _$TenantModelToMap(TenantModel instance) {
  return {
    'id': instance.id,
    'personalID': instance.personalID,
    'name': instance.name,
    'birthday': instance.birthday,
    'gender': instance.gender,
    'address': instance.address,
    'phone': instance.phone,
    'note': instance.note,
    'room': instance.room.toMap(),
    'createdAt': instance.createdAt,
    'rentedAt': instance.rentedAt,
    'returnedAt': instance.returnedAt,
  };
}

// To FirebaseDatabaseMap Method
Map<String, dynamic> _$TenantModelToFirebaseDatabaseMap(TenantModel instance) {
  final map = _$TenantModelToMap(instance);

  map['birthday'] = instance.birthday.millisecondsSinceEpoch;
  map['room'] = instance.room.toFirebaseDatabaseMap();
  map['createdAt'] = instance.createdAt.millisecondsSinceEpoch;
  map['rentedAt'] = instance.rentedAt.millisecondsSinceEpoch;
  map['returnedAt'] = instance.returnedAt.millisecondsSinceEpoch;
  return map;
}

// From Map Method
TenantModel _$TenantModelFromMap(Map<String, dynamic> map) {
  try {
    return TenantModel(
      id: map['id'],
      personalID: map['personalID'],
      name: map['name'],
      birthday: map['birthday'],
      gender: map['gender'],
      address: map['address'],
      phone: map['phone'],
      note: map['note'],
      room: RoomModel.fromMap(map['room']),
      createdAt: map['createdAt'],
      rentedAt: map['rentedAt'],
      returnedAt: map['returnedAt'],
    );
  } catch (e) {
    rethrow;
  }
}

// **************************************************************************
// JsonGenerator
// **************************************************************************

// From Json Method
TenantModel _$TenantModelFromJson(Map<String, dynamic> json) => TenantModel(
      id: json['id'],
      personalID: json['personalID'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      address: json['address'],
      phone: json['phone'],
      note: json['note'],
      room: RoomModel.fromJson(json['room']),
      createdAt: json['createdAt'],
      rentedAt: json['rentedAt'],
      returnedAt: json['returnedAt'],
    );

// To Json Method
Map<String, dynamic> _$TenantModelToJson(TenantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personalID': instance.personalID,
      'name': instance.name,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'address': instance.address,
      'phone': instance.phone,
      'note': instance.note,
      'room': instance.room.toJson,
      'createdAt': instance.createdAt,
      'rentedAt': instance.rentedAt,
      'returnedAt': instance.returnedAt,
    };
