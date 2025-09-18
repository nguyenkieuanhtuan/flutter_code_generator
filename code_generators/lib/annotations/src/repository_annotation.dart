import 'database_type.dart';

/// Một annotation để đánh dấu một lớp là Repository.
///
/// Lớp được đánh dấu sẽ được generator sử dụng để tự động tạo ra
/// các phương thức CRUD (Create, Read, Update, Delete) cho các loại
/// cơ sở dữ liệu được chỉ định.
///
/// Các phương thức được tạo ra bao gồm:
/// - `create(model)`: Tạo một bản ghi mới.
/// - `readById(id)`: Đọc một bản ghi theo ID.
/// - `update(model)`: Cập nhật một bản ghi.
/// - `delete(id)`: Xóa một bản ghi.
/// - `readAll()`: Lấy tất cả các bản ghi.
/// - `getCollectionRef(...)`: Trả về một CollectionReference.
class BaseRepository {
  const BaseRepository(
      {required this.types,
      this.collectionName,
      this.model,
      this.parentCollectionNames = const []});

  /// Danh sách các loại cơ sở dữ liệu mà generator sẽ tạo mã hỗ trợ.
  ///
  /// Ví dụ: `[DatabaseType.firestore]`
  final List<DatabaseType> types;

  /// Tên của collection chính trong cơ sở dữ liệu.
  ///
  /// Nếu không được cung cấp, generator sẽ sử dụng tên của lớp Repository
  /// (sau khi bỏ đi các hậu tố như "Repository") và chuyển thành chữ thường.
  /// Ví dụ: `FamilyRepository` sẽ được tạo mã cho collection `'family'`.
  final String? collectionName;

  /// Loại (Type) của mô hình (model class) mà Repository này quản lý.
  ///
  /// Điều này giúp generator biết được loại dữ liệu cần xử lý trong
  /// các phương thức CRUD.
  final Type? model;

  /// Danh sách các tên của các collection cha, theo thứ tự từ ngoài vào trong.
  ///
  /// Generator sẽ sử dụng danh sách này để xây dựng đường dẫn đến
  /// một sub-collection hoặc sub-sub-collection.
  ///
  /// Ví dụ: Với một collection `children` là con của `families`,
  /// bạn sẽ sử dụng: `parentCollectionNames: ['families']`.
  final List<String> parentCollectionNames;
}
