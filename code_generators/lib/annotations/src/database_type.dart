/// Một enum để chỉ định các loại cơ sở dữ liệu mà generator sẽ hỗ trợ.
enum DatabaseType {
  /// Chỉ định rằng generator sẽ tạo mã cho Drift (SQLite).
  drift,

  /// Chỉ định rằng generator sẽ tạo mã cho Realtime Database.
  realtime,

  /// Chỉ định rằng generator sẽ tạo mã cho tính năng server.
  server,

  /// Chỉ định rằng generator sẽ tạo mã cho Firestore.
  firestore
}
