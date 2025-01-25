class SummaryState {
  final int monthIdx;
  final String monthName;
  final DateTime date;

  SummaryState({
    this.monthIdx = 0,
    this.monthName = '',
    required this.date,
  });

  SummaryState copyWith({
    int? monthIdx,
    String? monthName,
    DateTime? date,
  }) {
    return SummaryState(
      monthIdx: monthIdx ?? this.monthIdx,
      monthName: monthName ?? this.monthName,
      date: date ?? this.date,
    );
  }
}
