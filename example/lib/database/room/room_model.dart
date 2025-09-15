import 'package:equatable/equatable.dart';
import 'package:flutter_code_generators/annotations/annotations.dart';

import '../tenant/tenant_model.dart';

part 'room_model.kg_model.dart';

@modelAnnotation
class RoomModel extends Equatable {

  /// DataField
  final String id;  
  /// DataField
  final String name;    
  /// DataField
  final double priceElectricity;  
  /// DataField
  final double priceWater;
  /// DataField
  final double priceRoom;
  /// DataField
  final String note;
  /// DataField
  final DateTime createdAt;
  /// DataField
  final List<TenantModel> tenants;

  const RoomModel({required this.id, required this.name, required this.priceElectricity, required this.priceWater, required this.priceRoom, required this.note, required this.createdAt, required this.tenants});
  
  @override  
  List<Object?> get props => throw UnimplementedError();

  /// Connect the generated [_$RoomModelFromJson] function to the `fromJson`
  /// factory.
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return _$RoomModelFromJson(json);
  }

  /// Connect the generated [_$RoomModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);

  /// Connect the generated [_$RoomModelFromMap] function to the `fromMap`
  /// factory.
  static RoomModel fromMap(Map<String, dynamic> map) {
    return _$RoomModelFromMap(map);
  }

  /// Connect the generated [_$RoomModelToMap] function to the `toMap` method.
  Map<String, dynamic> toMap() => _$RoomModelToMap(this);

  /// Connect the generated [_$RoomModelToFirebaseDatabaseMap] function to the `toFirebaseDatabaseMap` method.
  Map<String, dynamic> toFirebaseDatabaseMap() => _$RoomModelToFirebaseDatabaseMap(this);
}