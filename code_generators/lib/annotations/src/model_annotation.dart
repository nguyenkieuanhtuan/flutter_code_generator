import 'database_type.dart';

/// Một annotation để đánh dấu một lớp là mô hình (model class).
///
/// - Luôn tạo các phương thức tiện ích [toMap()] và [fromMap()]
///    để hỗ trợ chuyển đổi dữ liệu chung.
///
/// - Dựa vào tham số [types] của @BaseModel, generator sẽ quyết định
///    tạo thêm mã cho các loại cơ sở dữ liệu cụ thể:
///    + Nếu [DatabaseType.firestore] được chỉ định, sẽ tạo các phương thức
///      [toFirestore()] và [fromFirestore()].
///    + Nếu [DatabaseType.drift] được chỉ định, sẽ tạo các bảng Drift
///      và các class Companion tương ứng.
class BaseModel {
  /// Tham số duy nhất, [types], là một danh sách các [DatabaseType]
  /// để chỉ định các loại cơ sở dữ liệu mà generator sẽ tạo mã hỗ trợ.
  const BaseModel({required this.types});

  /// Danh sách các loại cơ sở dữ liệu để tạo mã.
  final List<DatabaseType> types;
}

/// Một annotation để đánh dấu một trường là khóa chính (ID) của mô hình.
///
/// Trường được đánh dấu sẽ được generator sử dụng làm ID duy nhất
/// cho tài liệu trong Firestore hoặc hàng trong bảng của Drift.
/// Một mô hình chỉ nên có một trường được đánh dấu bằng annotation này.
class IdField {
  const IdField();
}

/// Một annotation để đánh dấu một trường là duy nhất.
///
/// Generator có thể sử dụng annotation này để tạo các phương thức
/// tìm kiếm hoặc kiểm tra tính duy nhất trong cơ sở dữ liệu.
class UniqueField {
  const UniqueField();
}

/// Một annotation để đánh dấu một trường là tham chiếu đến một
/// bảng hoặc bộ sưu tập khác.
///
/// Điều này giúp generator hiểu các mối quan hệ giữa các mô hình
/// (ví dụ: một `Kid` có một `familyId` tham chiếu đến bộ sưu tập `families`).
class TableRef {
  /// Tham số duy nhất, [table], là tên của bảng hoặc bộ sưu tập
  /// mà trường này tham chiếu.
  const TableRef(this.table);

  /// Tên của bảng hoặc bộ sưu tập được tham chiếu.
  final String table;
}

const firestoreBaseModel = BaseModel(types: [DatabaseType.firestore]);
const driftBaseModel = BaseModel(types: [DatabaseType.drift]);
const realtimeBaseModel = BaseModel(types: [DatabaseType.realtime]);
const serverBaseModel = BaseModel(types: [DatabaseType.server]);
const driftAndServerBaseModel =
    BaseModel(types: [DatabaseType.drift, DatabaseType.server]);
const allBaseModel = BaseModel(types: [
  DatabaseType.drift,
  DatabaseType.realtime,
  DatabaseType.server,
  DatabaseType.firestore,
]);
