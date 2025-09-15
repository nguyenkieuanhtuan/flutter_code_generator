// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'town_house_database.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

// forClassName: TownHouseModel

// Firebase Database
class _$TownHouseFirebaseDatabase implements TownHouseDatabase {
  static String kTownHousesRefName = 'townhouses';

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  Future<TownHouseModel> newTownHouse(
      {required TownHouseModel townHouse, required String storeId}) async {
    final reference = _databaseRef.child(kTownHousesRefName).push();
    final map = townHouse.toFirebaseDatabaseMap();
    map['id'] = reference.key;
    map['createdAt'] = DateTime.now().millisecondsSinceEpoch;

    return reference.set(map).then((_) {
      return townHouse.copyWith(id: reference.key, createdAt: map['createdAt']);
    }).catchError((e) {
      if (kDebugMode) {
        print('new TownHouseModel error $e');
      }
      throw e;
    });
  }

  @override
  Future<TownHouseModel> updateTownHouse(
      {required TownHouseModel townHouse}) async {
    if (townHouse.hasID) {
      final reference =
          _databaseRef.child(kTownHousesRefName).child(townHouse.id);
      final map = townHouse.toFirebaseDatabaseMap();
      map['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

      return reference.update(map).then((_) {
        return townHouse;
      }).catchError((e) {
        if (kDebugMode) {
          print('update TownHouseModel error $e');
        }
        throw e;
      });
    } else {
      throw Exception('id_not_exist');
    }
  }

  @override
  Future<bool> deleteTownHouse({required TownHouseModel townHouse}) async {
    if (townHouse.hasID) {
      final reference =
          _databaseRef.child(kTownHousesRefName).child(townHouse.id);

      return reference.remove().then((_) {
        return true;
      }).catchError((e) {
        if (kDebugMode) {
          print('delete TownHouseModel error $e');
        }
        throw e;
      });
    } else {
      throw Exception('id_not_exist');
    }
  }

  @override
  Future<TownHouseModel?> getTownHouse(String id) async {
    try {
      final dataEvent =
          await _databaseRef.child(kTownHousesRefName).child(id).once();

      final map = dataEvent.snapshot.value as Map<String, dynamic>;

      final model = TownHouseModel.fromMap(map);

      return model;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  @override
  Future<List<TownHouseModel>> getAllTownHouse() async {
    try {
      var query =
          _databaseRef.child(kTownHousesRefName).orderByChild('createdAt');

      final dataEvent = await query.once();

      final dataValues = dataEvent.snapshot.value as Map?;

      final models = <TownHouseModel>[];
      dataValues?.forEach((key, value) {
        final map = value as Map<String, dynamic>?;
        if (map != null) {
          final model = TownHouseModel.fromMap(map);
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
  Stream<List<TownHouseModel>> streamAllTownHouse() {
    var query =
        _databaseRef.child(kTownHousesRefName).orderByChild('createdAt');

    return query.onValue.map((event) {
      final models = <TownHouseModel>[];
      if (event.snapshot.value is Map) {
        final dataMap = event.snapshot.value as Map?;

        dataMap?.forEach((key, value) {
          final map = value as Map<String, dynamic>?;
          if (map != null) {
            final model = TownHouseModel.fromMap(map);
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
