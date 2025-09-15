// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_database.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// forClassName: Instance of '_DartObjectConstant'
// Extension for a TenantRepositoryRepository class to provide base method
extension $TenantRepositoryExtension on TenantRepository {
  Future<TenantModel> newTenant(
      {required TenantModel townHouse, required String storeId}) {
    return database.newTenant(
      townHouse: townHouse,
      storeId: storeId,
    );
  }

  Future<TenantModel> updateTenant({required TenantModel townHouse}) {
    return database.updateTenant(
      townHouse: townHouse,
    );
  }

  Future<bool> deleteTenant({required TenantModel townHouse}) {
    return database.deleteTenant(
      townHouse: townHouse,
    );
  }

  Future<TenantModel?> getTenant(String id) {
    return database.getTenant(
      id,
    );
  }

  Future<List<TenantModel>> getAllTenant() {
    return database.getAllTenant();
  }

  Stream<List<TenantModel>> streamAllTenant() {
    return database.streamAllTenant();
  }
}
