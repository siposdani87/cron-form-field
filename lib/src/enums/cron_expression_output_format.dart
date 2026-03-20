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
