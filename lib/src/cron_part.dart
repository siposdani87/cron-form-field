/// Base interface for all cron expression parts (second, minute, hour, etc.).
abstract class CronPart {
  /// Resets the part type and values to defaults.
  void reset();

  /// Sets default values for all fields without changing the type.
  void setDefaults();

  /// Returns the cron string representation of this part.
  @override
  String toString();

  /// Returns a human-readable description of this part.
  String toReadableString();

  /// Validates whether [part] is a syntactically valid cron part string.
  bool validate(String part);

  /// The starting index for values in this part (e.g., 0 for seconds, 1 for months).
  int get startIndex;
}
