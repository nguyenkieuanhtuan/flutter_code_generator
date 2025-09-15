// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_database.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

// forClassName: RoomModel

// Firebase Database
class _$RoomFirebaseDatabase implements RoomDatabase {
  static String kRoomsRefName = 'rooms';

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  Future<RoomModel> newRoom(
      {required RoomModel townHouse, required String storeId}) async {
    final reference = _databaseRef.child(kRoomsRefName).push();
    final map = townHouse.toFirebaseDatabaseMap();
    map['id'] = reference.key;
    map['createdAt'] = DateTime.now().millisecondsSinceEpoch;

    return reference.set(map).then((_) {
      return townHouse.copyWith(id: reference.key, createdAt: map['createdAt']);
    }).catchError((e) {
      if (kDebugMode) {
        print('new RoomModel error $e');
      }
      throw e;
    });
  }

  @override
  Future<RoomModel> updateRoom({required RoomModel townHouse}) async {
    if (townHouse.hasID) {
      final reference = _databaseRef.child(kRoomsRefName).child(townHouse.id);
      final map = townHouse.toFirebaseDatabaseMap();
      map['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

      return reference.update(map).then((_) {
        return townHouse;
      }).catchError((e) {
        if (kDebugMode) {
          print('update RoomModel error $e');
        }
        throw e;
      });
    } else {
      throw Exception('id_not_exist');
    }
  }

  @override
  Future<bool> deleteRoom({required RoomModel townHouse}) async {
    if (townHouse.hasID) {
      final reference = _databaseRef.child(kRoomsRefName).child(townHouse.id);

      return reference.remove().then((_) {
        return true;
      }).catchError((e) {
        if (kDebugMode) {
          print('delete RoomModel error $e');
        }
        throw e;
      });
    } else {
      throw Exception('id_not_exist');
    }
  }

  @override
  Future<RoomModel?> getRoom(String id) async {
    try {
      final dataEvent =
          await _databaseRef.child(kRoomsRefName).child(id).once();

      final map = dataEvent.snapshot.value as Map<String, dynamic>;

      final model = RoomModel.fromMap(map);

      return model;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  @override
  Future<List<RoomModel>> getAllRoom() async {
    try {
      var query = _databaseRef.child(kRoomsRefName).orderByChild('createdAt');

      final dataEvent = await query.once();

      final dataValues = dataEvent.snapshot.value as Map?;

      final models = <RoomModel>[];
      dataValues?.forEach((key, value) {
        final map = value as Map<String, dynamic>?;
        if (map != null) {
          final model = RoomModel.fromMap(map);
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
  Stream<List<RoomModel>> streamAllRoom() {
    var query = _databaseRef.child(kRoomsRefName).orderByChild('createdAt');

    return query.onValue.map((event) {
      final models = <RoomModel>[];
      if (event.snapshot.value is Map) {
        final dataMap = event.snapshot.value as Map?;

        dataMap?.forEach((key, value) {
          final map = value as Map<String, dynamic>?;
          if (map != null) {
            final model = RoomModel.fromMap(map);
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
