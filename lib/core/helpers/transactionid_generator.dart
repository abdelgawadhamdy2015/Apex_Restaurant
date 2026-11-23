class TransactionIdGenerator {
  static int _counter = 1;

  /// Returns an id that is not in [used]. The caller adds it to its own set.
  static String next([Set<String> used = const {}]) {
    String id;
    do {
      id = (_counter++).toString();
    } while (used.contains(id));
    return id;
  }
}
