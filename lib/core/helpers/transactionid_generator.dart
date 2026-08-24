class TransactionIdGenerator {
  static int _counter = 1;

  /// Returns a new incremental unique transaction ID
  static int get nextId => _counter++;
}
