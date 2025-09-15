// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_database.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// forClassName: Instance of '_DartObjectConstant'
// Extension for a RoomRepositoryRepository class to provide base method
extension $RoomRepositoryExtension on RoomRepository {
  Future<RoomModel> newRoom(
      {required RoomModel townHouse, required String storeId}) {
    return database.newRoom(
      townHouse: townHouse,
      storeId: storeId,
    );
  }

  Future<RoomModel> updateRoom({required RoomModel townHouse}) {
    return database.updateRoom(
      townHouse: townHouse,
    );
  }

  Future<bool> deleteRoom({required RoomModel townHouse}) {
    return database.deleteRoom(
      townHouse: townHouse,
    );
  }

  Future<RoomModel?> getRoom(String id) {
    return database.getRoom(
      id,
    );
  }

  Future<List<RoomModel>> getAllRoom() {
    return database.getAllRoom();
  }

  Stream<List<RoomModel>> streamAllRoom() {
    return database.streamAllRoom();
  }
}
