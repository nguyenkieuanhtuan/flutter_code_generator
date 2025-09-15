// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_database.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

// forClassName: TenantModel

// Firebase Database
class _$TenantFirebaseDatabase implements TenantDatabase {
  static String kTenantsRefName = 'tenants';

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  Future<TenantModel> newTenant(
      {required TenantModel townHouse, required String storeId}) async {
    final reference = _databaseRef.child(kTenantsRefName).push();
    final map = townHouse.toFirebaseDatabaseMap();
    map['id'] = reference.key;
    map['createdAt'] = DateTime.now().millisecondsSinceEpoch;

    return reference.set(map).then((_) {
      return townHouse.copyWith(id: reference.key, createdAt: map['createdAt']);
    }).catchError((e) {
      if (kDebugMode) {
        print('new TenantModel error $e');
      }
      throw e;
    });
  }

  @override
  Future<TenantModel> updateTenant({required TenantModel townHouse}) async {
    if (townHouse.hasID) {
      final reference = _databaseRef.child(kTenantsRefName).child(townHouse.id);
      final map = townHouse.toFirebaseDatabaseMap();
      map['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

      return reference.update(map).then((_) {
        return townHouse;
      }).catchError((e) {
        if (kDebugMode) {
          print('update TenantModel error $e');
        }
        throw e;
      });
    } else {
      throw Exception('id_not_exist');
    }
  }

  @override
  Future<bool> deleteTenant({required TenantModel townHouse}) async {
    if (townHouse.hasID) {
      final reference = _databaseRef.child(kTenantsRefName).child(townHouse.id);

      return reference.remove().then((_) {
        return true;
      }).catchError((e) {
        if (kDebugMode) {
          print('delete TenantModel error $e');
        }
        throw e;
      });
    } else {
      throw Exception('id_not_exist');
    }
  }

  @override
  Future<TenantModel?> getTenant(String id) async {
    try {
      final dataEvent =
          await _databaseRef.child(kTenantsRefName).child(id).once();

      final map = dataEvent.snapshot.value as Map<String, dynamic>;

      final model = TenantModel.fromMap(map);

      return model;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  @override
  Future<List<TenantModel>> getAllTenant() async {
    try {
      var query = _databaseRef.child(kTenantsRefName).orderByChild('createdAt');

      final dataEvent = await query.once();

      final dataValues = dataEvent.snapshot.value as Map?;

      final models = <TenantModel>[];
      dataValues?.forEach((key, value) {
        final map = value as Map<String, dynamic>?;
        if (map != null) {
          final model = TenantModel.fromMap(map);
          if (model != null) {
            models.add(model);
          }
        }
      });

      return models;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  @override
  Stream<List<TenantModel>> streamAllTenant() {
    var query = _databaseRef.child(kTenantsRefName).orderByChild('createdAt');

    return query.onValue.map((event) {
      final models = <TenantModel>[];
      if (event.snapshot.value is Map) {
        final dataMap = event.snapshot.value as Map?;

        dataMap?.forEach((key, value) {
          final map = value as Map<String, dynamic>?;
          if (map != null) {
            final model = TenantModel.fromMap(map);
            if (model != null) {
              models.add(model);
            }
          }
        });
      }
      return models;
    });
  }
}
