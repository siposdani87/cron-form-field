abstract class CronPart {
  void reset();

  void setDefaults();

  String toString();

  String toReadableString();

  bool validate(String part);
}
