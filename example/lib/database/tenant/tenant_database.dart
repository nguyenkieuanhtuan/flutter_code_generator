import 'package:flutter_code_generators/annotations/annotations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';

import 'tenant_model.dart';

part 'tenant_database.kg_repository.dart';
part 'tenant_database.kg_database.dart';

@DatabaseAnnotation(forClassName: 'TenantModel')
abstract class TenantDatabase {
    
    @DatabaseMethodAnnotation(type: 'new')
    Future<TenantModel> newTenant({required TenantModel townHouse, required String storeId});

    @DatabaseMethodAnnotation(type: 'update')
    Future<TenantModel> updateTenant({required TenantModel townHouse});

    @DatabaseMethodAnnotation(type: 'delete')
    Future<bool> deleteTenant({required TenantModel townHouse});

    @DatabaseMethodAnnotation(type: 'get')
    Future<TenantModel?> getTenant(String id);

    @DatabaseMethodAnnotation(type: 'getList')
    Future<List<TenantModel>> getAllTenant();

    @DatabaseMethodAnnotation(type: 'streamList')
    Stream<List<TenantModel>> streamAllTenant();
}

class TenantRepository {

  late TenantDatabase database;

  TenantRepository(){
    database = _$TenantFirebaseDatabase();
  }
}