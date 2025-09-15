import 'package:flutter_code_generators/annotations/annotations.dart';

import '../room/room_model.dart';

// part 'bill.g.dart';
// part 'bill.model.dart';

@modelAnnotation
class Bill {
  final String id = '0000000';  
  final String name = 'This is name';    
  final double previousElectricity = 0.0;
  final double currentElectricity = 0.0;
  final double priceElectricity = 0.0;
  final double previousWater = 0.0;
  final double currentWater = 0.0;
  final double priceWater = 0.0;
  final double priceRoom = 0.0;
  final double otherFee = 0.0;
  final String note = 'note';
  final RoomModel room = RoomModel();
  final DateTime recordedAt = DateTime.now();
  final DateTime paymentAt = DateTime.now();
  final double paymentAmount = 0.0;
  final String paymentType = 'cash'; 
  final DateTime createdAt = DateTime.now();
}