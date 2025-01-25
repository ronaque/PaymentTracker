import 'package:bloc/bloc.dart';
import 'package:payment_tracker/src/summary/blocs/summary_state.dart';

class SummaryCubit extends Cubit<SummaryState> {
  SummaryCubit() : super(SummaryState(date: DateTime.now()));

  void setMonthName(String monthName) {
    emit(state.copyWith(monthName: monthName));
  }

  String getMonthName() {
    return state.monthName;
  }

  void setMonthIdx(int monthIdx) {
    emit(state.copyWith(monthIdx: monthIdx));
  }

  int getMonthIdx() {
    return state.monthIdx;
  }

  void setDate(DateTime date) {
    emit(state.copyWith(date: date));
  }

  DateTime getDate() {
    return state.date;
  }
}
