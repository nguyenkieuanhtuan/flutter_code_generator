// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'town_house_model.dart';

// **************************************************************************
// ModelGenerator
// **************************************************************************

// Log:  visitFieldElement String id /// DataField visitFieldElement String name /// DataField visitFieldElement String address /// DataField visitFieldElement String province /// DataField visitFieldElement String district /// DataField visitFieldElement String ward /// DataField visitFieldElement DateTime createdAt /// DataField visitFieldElement List<Object?> props null visitConstructorElement null visitConstructorElement /// Connect the generated [_$TownHouseModelFromJson] function to the `fromJson`
/// factory. visitMethodElement Map<String, dynamic> toJson() visitMethodElement TownHouseModel fromMap(Map<String, dynamic> map) visitMethodElement Map<String, dynamic> toMap() visitMethodElement Map<String, dynamic> toFirebaseDatabaseMap()
// {id: Instance of 'DataField', name: Instance of 'DataField', address: Instance of 'DataField', province: Instance of 'DataField', district: Instance of 'DataField', ward: Instance of 'DataField', createdAt: Instance of 'DataField'}

// Extension for a TownHouseModel class to provide 'copyWith' method
extension $TownHouseModelExtension on TownHouseModel {
  bool get hasID => id != null && id.isNotEmpty;

  TownHouseModel copyWith({
    String? id,
    String? name,
    String? address,
    String? province,
    String? district,
    String? ward,
    DateTime? createdAt,
  }) {
    return TownHouseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      province: province ?? this.province,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// To Map Method
Map<String, dynamic> _$TownHouseModelToMap(TownHouseModel instance) {
  return {
    'id': instance.id,
    'name': instance.name,
    'address': instance.address,
    'province': instance.province,
    'district': instance.district,
    'ward': instance.ward,
    'createdAt': instance.createdAt,
  };
}

// To FirebaseDatabaseMap Method
Map<String, dynamic> _$TownHouseModelToFirebaseDatabaseMap(
    TownHouseModel instance) {
  final map = _$TownHouseModelToMap(instance);

  map['createdAt'] = instance.createdAt.millisecondsSinceEpoch;
  return map;
}

// From Map Method
TownHouseModel _$TownHouseModelFromMap(Map<String, dynamic> map) {
  try {
    return TownHouseModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      province: map['province'],
      district: map['district'],
      ward: map['ward'],
      createdAt: map['createdAt'],
    );
  } catch (e) {
    rethrow;
  }
}

// **************************************************************************
// JsonGenerator
// **************************************************************************

// From Json Method
TownHouseModel _$TownHouseModelFromJson(Map<String, dynamic> json) =>
    TownHouseModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      province: json['province'],
      district: json['district'],
      ward: json['ward'],
      createdAt: json['createdAt'],
    );

// To Json Method
Map<String, dynamic> _$TownHouseModelToJson(TownHouseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'province': instance.province,
      'district': instance.district,
      'ward': instance.ward,
      'createdAt': instance.createdAt,
    };
