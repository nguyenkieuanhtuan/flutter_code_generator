import 'package:flutter_code_generators/annotations/annotations.dart';
import 'package:equatable/equatable.dart';

part 'town_house_model.kg_model.dart';

@modelAnnotation
class TownHouseModel extends Equatable{

  /// DataField
  final String id;
  /// DataField
  final String name;
  /// DataField
  final String address;
  /// DataField
  final String province;
  /// DataField
  final String district;
  /// DataField
  final String ward;
  /// DataField
  final DateTime createdAt;  

  const TownHouseModel({required this.id, required this.name, required this.address, required this.district, required this.province, required this.ward, required this.createdAt});

  @override  
  List<Object?> get props => [id, name, address];

  /// Connect the generated [_$TownHouseModelFromJson] function to the `fromJson`
  /// factory.
  factory TownHouseModel.fromJson(Map<String, dynamic> json) {
    return _$TownHouseModelFromJson(json);
  }

  /// Connect the generated [_$TownHouseModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TownHouseModelToJson(this);

  /// Connect the generated [_$TownHouseModelFromMap] function to the `fromMap`
  /// factory.
  static TownHouseModel fromMap(Map<String, dynamic> map) {
    return _$TownHouseModelFromMap(map);
  }

  /// Connect the generated [_$TownHouseModelToMap] function to the `toMap` method.
  Map<String, dynamic> toMap() => _$TownHouseModelToMap(this);

  /// Connect the generated [_$TownHouseModelToFirebaseDatabaseMap] function to the `toFirebaseDatabaseMap` method.
  Map<String, dynamic> toFirebaseDatabaseMap() => _$TownHouseModelToFirebaseDatabaseMap(this);
}

