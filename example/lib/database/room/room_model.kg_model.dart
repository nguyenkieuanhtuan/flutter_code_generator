// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// ModelGenerator
// **************************************************************************

// Log:  visitFieldElement String id /// DataField visitFieldElement String name /// DataField visitFieldElement double priceElectricity /// DataField visitFieldElement double priceWater /// DataField visitFieldElement double priceRoom /// DataField visitFieldElement String note /// DataField visitFieldElement DateTime createdAt /// DataField visitFieldElement List<TenantModel> tenants /// DataField visitFieldElement List<Object?> props null visitConstructorElement null visitConstructorElement /// Connect the generated [_$RoomModelFromJson] function to the `fromJson`
/// factory. visitMethodElement Map<String, dynamic> toJson() visitMethodElement RoomModel fromMap(Map<String, dynamic> map) visitMethodElement Map<String, dynamic> toMap() visitMethodElement Map<String, dynamic> toFirebaseDatabaseMap()
// {id: Instance of 'DataField', name: Instance of 'DataField', priceElectricity: Instance of 'DataField', priceWater: Instance of 'DataField', priceRoom: Instance of 'DataField', note: Instance of 'DataField', createdAt: Instance of 'DataField', tenants: Instance of 'DataField'}

// Extension for a RoomModel class to provide 'copyWith' method
extension $RoomModelExtension on RoomModel {
  bool get hasID => id != null && id.isNotEmpty;

  RoomModel copyWith({
    String? id,
    String? name,
    double? priceElectricity,
    double? priceWater,
    double? priceRoom,
    String? note,
    DateTime? createdAt,
    List<TenantModel>? tenants,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      priceElectricity: priceElectricity ?? this.priceElectricity,
      priceWater: priceWater ?? this.priceWater,
      priceRoom: priceRoom ?? this.priceRoom,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      tenants: tenants ?? this.tenants,
    );
  }
}

// To Map Method
Map<String, dynamic> _$RoomModelToMap(RoomModel instance) {
  return {
    'id': instance.id,
    'name': instance.name,
    'priceElectricity': instance.priceElectricity,
    'priceWater': instance.priceWater,
    'priceRoom': instance.priceRoom,
    'note': instance.note,
    'createdAt': instance.createdAt,
    'tenants': instance.tenants,
  };
}

// To FirebaseDatabaseMap Method
Map<String, dynamic> _$RoomModelToFirebaseDatabaseMap(RoomModel instance) {
  final map = _$RoomModelToMap(instance);

  map['createdAt'] = instance.createdAt.millisecondsSinceEpoch;
  return map;
}

// From Map Method
RoomModel _$RoomModelFromMap(Map<String, dynamic> map) {
  try {
    return RoomModel(
      id: map['id'],
      name: map['name'],
      priceElectricity: map['priceElectricity'],
      priceWater: map['priceWater'],
      priceRoom: map['priceRoom'],
      note: map['note'],
      createdAt: map['createdAt'],
      tenants: map['tenants'],
    );
  } catch (e) {
    rethrow;
  }
}

// **************************************************************************
// JsonGenerator
// **************************************************************************

// From Json Method
RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: json['id'],
      name: json['name'],
      priceElectricity: json['priceElectricity'],
      priceWater: json['priceWater'],
      priceRoom: json['priceRoom'],
      note: json['note'],
      createdAt: json['createdAt'],
      tenants: json['tenants'],
    );

// To Json Method
Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priceElectricity': instance.priceElectricity,
      'priceWater': instance.priceWater,
      'priceRoom': instance.priceRoom,
      'note': instance.note,
      'createdAt': instance.createdAt,
      'tenants': instance.tenants,
    };
