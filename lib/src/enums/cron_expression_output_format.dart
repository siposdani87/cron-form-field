/// Controls how month and weekday values are formatted in output.
///
/// - [auto]: preserves the original format (numeric or named).
/// - [allowedValues]: always outputs numeric values (e.g., 1, 2).
/// - [alternativeValues]: always outputs named values (e.g., JAN, MON).
enum CronExpressionOutputFormat { auto, allowedValues, alternativeValues }

extension CronExpressionOutputFormatExtension on CronExpressionOutputFormat {
  bool isAlternative(bool isAlternative) {
    switch (this) {
      case CronExpressionOutputFormat.auto:
        return isAlternative;
      case CronExpressionOutputFormat.allowedValues:
        return false;
      case CronExpressionOutputFormat.alternativeValues:
        return true;
    }
  }
}
