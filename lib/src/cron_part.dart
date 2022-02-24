abstract class CronPart {
  void reset();

  void setDefaults();

  @override
  String toString();

  String toReadableString();

  bool validate(String part);
}
