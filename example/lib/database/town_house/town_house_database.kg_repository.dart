// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'town_house_database.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// forClassName: Instance of '_DartObjectConstant'
// Extension for a TownHouseRepositoryRepository class to provide base method
extension $TownHouseRepositoryExtension on TownHouseRepository {
  Future<TownHouseModel> newTownHouse(
      {required TownHouseModel townHouse, required String storeId}) {
    return database.newTownHouse(
      townHouse: townHouse,
      storeId: storeId,
    );
  }

  Future<TownHouseModel> updateTownHouse({required TownHouseModel townHouse}) {
    return database.updateTownHouse(
      townHouse: townHouse,
    );
  }

  Future<bool> deleteTownHouse({required TownHouseModel townHouse}) {
    return database.deleteTownHouse(
      townHouse: townHouse,
    );
  }

  Future<TownHouseModel?> getTownHouse(String id) {
    return database.getTownHouse(
      id,
    );
  }

  Future<List<TownHouseModel>> getAllTownHouse() {
    return database.getAllTownHouse();
  }

  Stream<List<TownHouseModel>> streamAllTownHouse() {
    return database.streamAllTownHouse();
  }
}
