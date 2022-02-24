enum CronExpressionOutputFormat { AUTO, ALLOWED_VALUES, ALTERNATIVE_VALUES }

extension CronExpressionOutputFormatExtension on CronExpressionOutputFormat {
  bool isAlternative(bool isAlternative) {
    switch (this) {
      case CronExpressionOutputFormat.AUTO:
        return isAlternative;
      case CronExpressionOutputFormat.ALLOWED_VALUES:
        return false;
      case CronExpressionOutputFormat.ALTERNATIVE_VALUES:
        return true;
    }
  }
}
