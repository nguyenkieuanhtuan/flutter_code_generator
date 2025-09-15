import 'package:equatable/equatable.dart';
import 'package:flutter_code_generators/annotations/annotations.dart';

import '../room/room_model.dart';

part 'tenant_model.kg_model.dart';

@modelAnnotation
class TenantModel extends Equatable{
  
  /// DataField
  final String id;
  /// DataField
  final String personalID;
  /// DataField
  final String name;
  /// DataField
  final DateTime birthday;
  /// DataField
  final String gender;  
  /// DataField
  final String address;
  /// DataField
  final String phone;
  /// DataField
  final String note;
  /// DataField isModel
  final RoomModel room;
  /// DataField
  final DateTime createdAt;
  /// DataField
  final DateTime rentedAt;
  /// DataField
  final DateTime returnedAt;

  const TenantModel({required this.id, required this.personalID, required this.name, required this.birthday, required this.gender, required this.address, required this.phone, required this.note, required this.room, required this.createdAt, required this.rentedAt, required this.returnedAt});
  
  @override  
  List<Object?> get props => throw UnimplementedError();

  /// Connect the generated [_$TenantModelFromJson] function to the `fromJson`
  /// factory.
  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return _$TenantModelFromJson(json);
  }

  /// Connect the generated [_$TenantModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TenantModelToJson(this);

  /// Connect the generated [_$TenantModelFromMap] function to the `fromMap`
  /// factory.
  static TenantModel fromMap(Map<String, dynamic> map) {
    return _$TenantModelFromMap(map);
  }

  /// Connect the generated [_$TenantModelToMap] function to the `toMap` method.
  Map<String, dynamic> toMap() => _$TenantModelToMap(this);

  /// Connect the generated [_$TenantModelToFirebaseDatabaseMap] function to the `toFirebaseDatabaseMap` method.
  Map<String, dynamic> toFirebaseDatabaseMap() => _$TenantModelToFirebaseDatabaseMap(this);

}