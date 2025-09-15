import 'package:flutter_code_generators/annotations/annotations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';

import 'town_house_model.dart';

part 'town_house_database.kg_repository.dart';
part 'town_house_database.kg_database.dart';

@DatabaseAnnotation(forClassName: 'TownHouseModel')
abstract class TownHouseDatabase {
    
    @DatabaseMethodAnnotation(type: 'new')
    Future<TownHouseModel> newTownHouse({required TownHouseModel townHouse, required String storeId});

    @DatabaseMethodAnnotation(type: 'update')
    Future<TownHouseModel> updateTownHouse({required TownHouseModel townHouse});

    @DatabaseMethodAnnotation(type: 'delete')
    Future<bool> deleteTownHouse({required TownHouseModel townHouse});

    @DatabaseMethodAnnotation(type: 'get')
    Future<TownHouseModel?> getTownHouse(String id);

    @DatabaseMethodAnnotation(type: 'getList')
    Future<List<TownHouseModel>> getAllTownHouse();

    @DatabaseMethodAnnotation(type: 'streamList')
    Stream<List<TownHouseModel>> streamAllTownHouse();
}

class TownHouseRepository {

  late TownHouseDatabase database;

  TownHouseRepository(){
    database = _$TownHouseFirebaseDatabase();
  }
}