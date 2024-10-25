enum VersionNumber {
  /// Future Changes to Protocol
  reserved(0),

  /// First Default Protocol
  firstDefault(1),

  /// Undefined
  undefined(2);

  final int value;

  const VersionNumber(this.value);

  static VersionNumber fromValue(int value) {
    return VersionNumber.values.firstWhere(
      (VersionNumber e) => e.value == value,
      orElse: () => VersionNumber.undefined,
    );
  }
}
