/// Calendar-day arithmetic using integer day numbers (days since 1970-01-01).
/// Working in whole days avoids DST / timezone surprises.
library;

int dayNumber(DateTime d) => DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/ 86400000;

DateTime fromDayNumber(int n) {
  final u = DateTime.fromMillisecondsSinceEpoch(n * 86400000, isUtc: true);
  return DateTime(u.year, u.month, u.day);
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

int daysBetween(DateTime a, DateTime b) => dayNumber(b) - dayNumber(a);
