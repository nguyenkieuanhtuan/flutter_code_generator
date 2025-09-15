import 'package:flutter_code_generators/annotations/annotations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';

import 'room_model.dart';

part 'room_database.kg_repository.dart';
part 'room_database.kg_database.dart';

@DatabaseAnnotation(forClassName: 'RoomModel')
abstract class RoomDatabase {
    
    @DatabaseMethodAnnotation(type: 'new')
    Future<RoomModel> newRoom({required RoomModel townHouse, required String storeId});

    @DatabaseMethodAnnotation(type: 'update')
    Future<RoomModel> updateRoom({required RoomModel townHouse});

    @DatabaseMethodAnnotation(type: 'delete')
    Future<bool> deleteRoom({required RoomModel townHouse});

    @DatabaseMethodAnnotation(type: 'get')
    Future<RoomModel?> getRoom(String id);

    @DatabaseMethodAnnotation(type: 'getList')
    Future<List<RoomModel>> getAllRoom();

    @DatabaseMethodAnnotation(type: 'streamList')
    Stream<List<RoomModel>> streamAllRoom();
}

class RoomRepository {

  late RoomDatabase database;

  RoomRepository(){
    database = _$RoomFirebaseDatabase();
  }
}