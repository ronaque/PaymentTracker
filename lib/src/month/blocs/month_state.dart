import 'package:payment_tracker/src/shared/models/payment.dart';

class MesState {
  final int index_open;

  final List<Payment> gastos;

  final double saldo;

  MesState({
    this.index_open = -1,
    this.gastos = const <Payment>[],
    this.saldo = 0.0,
  });

  MesState copyWith({
    int? index_open,
    List<Payment>? gastos,
    double? saldo,
  }) {
    return MesState(
      index_open: index_open ?? this.index_open,
      gastos: gastos ?? this.gastos,
      saldo: saldo ?? this.saldo,
    );
  }
}
