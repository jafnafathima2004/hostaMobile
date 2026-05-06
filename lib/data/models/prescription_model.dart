class Medicine {
  final String name;
  final String dosage;
  final String days;
  final String time;
  final String freq;
  final bool isTaken;
  final DateTime date;

  Medicine({
    required this.name,
    required this.dosage,
    required this.days,
    required this.time,
    required this.freq,
    required this.isTaken,
    required this.date,
  });
}