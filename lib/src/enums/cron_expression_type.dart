/// The type of cron expression format.
///
/// [standard] uses 5 parts: minute hour day month weekday.
/// [quartz] uses 6-7 parts: second minute hour day month weekday [year],
/// and uses `?` for "no specific value" in day/weekday fields.
enum CronExpressionType { standard, quartz }
