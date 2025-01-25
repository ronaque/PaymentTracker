import 'package:bloc/bloc.dart';
import 'package:payment_tracker/src/month/blocs/month_state.dart';
import 'package:payment_tracker/src/shared/gasto_utils.dart';
import 'package:payment_tracker/src/shared/models/payment.dart';
import 'package:payment_tracker/src/shared/balance_utils.dart';

class MesCubit extends Cubit<MesState> {
  MesCubit() : super(MesState());

  void checkIndex(int index) {
    if (state.index_open == index) {
      index = -1;
    }
    changeIndex(index);
  }

  void changeIndex(int index) {
    emit(state.copyWith(index_open: index));
  }

  void setGastos(List<Payment> gastos) {
    emit(state.copyWith(gastos: gastos));
  }

  Future<void> changeGastos(DateTime data) async {
    var listGastos = await getPaymentsByMonth(data);
    setGastos(listGastos);
  }

  Future<void> changeSaldo(DateTime data) async {
    var saldo = await getMonthBalance(data);
    emit(state.copyWith(saldo: saldo));
  }
}
