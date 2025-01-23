import 'package:flutter/material.dart';
import 'package:payment_tracker/globals.dart';
import 'package:payment_tracker/src/month/blocs/month_cubit.dart';
import 'package:payment_tracker/src/month/components/transaction/edit_transactrion_page.dart';
import 'package:payment_tracker/src/month/components/transaction/add_transaction_page.dart';
import 'package:payment_tracker/src/shared/components/alert_dialog.dart';
import 'package:payment_tracker/src/shared/gasto_utils.dart';
import 'package:payment_tracker/src/shared/models/Gasto.dart';
import 'package:payment_tracker/src/shared/models/Tag.dart';
import 'package:payment_tracker/src/shared/repositories/GastoHelper.dart';

Widget getBalanceText(double saldo) {
  return Text(
    'Saldo: \$${saldo.toStringAsFixed(2)}',
    style: const TextStyle(color: Colors.white),
  );
}

Widget getCategoryTextOrIcon(Tag tag) {
  String category = tag.nome;
  var icon = null;
  defaultTags.forEach((key, value) {
    if (key == category) {
      icon = Icon(value);
    }
  });
  if (icon != null) {
    return icon;
  }
  return Text(
    category,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

// Widget getGastosPositivos() {
//   return FutureBuilder(
//     future: getGastosByMonthAndPositiveExpense(DateTime.now()),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         if (snapshot.data!.isEmpty) {
//           return const Text(
//             '\$0.0',
//             style: TextStyle(color: Colors.white),
//           );
//         }
//         double gastosTotal = 0;
//         for (int i = 0; i < snapshot.data!.length; i++) {
//           gastosTotal += snapshot.data![i].quantidade;
//         }
//         String strGastosTotal = gastosTotal.toStringAsFixed(2);
//         return Text(
//           '\$$strGastosTotal',
//           style: const TextStyle(color: Colors.green),
//         );
//       } else {
//         return const Text(
//           '\$0.0',
//           style: TextStyle(color: Colors.white),
//         );
//       }
//     },
//   );
// }

// Widget getGastosNegativos() {
//   return FutureBuilder(
//     future: getGastosByMonthAndNegativeExpense(DateTime.now()),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         if (snapshot.data!.isEmpty) {
//           return const Text(
//             '\$0.0',
//             style: TextStyle(color: Colors.white),
//           );
//         }
//         double gastosTotal = 0;
//         for (int i = 0; i < snapshot.data!.length; i++) {
//           gastosTotal += snapshot.data![i].quantidade;
//         }
//         String strGastosTotal = (gastosTotal * -1).toStringAsFixed(2);
//         return Text(
//           '\$$strGastosTotal',
//           style: const TextStyle(color: Colors.red),
//         );
//       } else {
//         return const Text(
//           '\$0.0',
//           style: TextStyle(color: Colors.white),
//         );
//       }
//     },
//   );
// }

// Widget buildEmptyState() {
//   return const Column(
//     children: [
//       SizedBox(height: 20.0),
//       Text('Nenhuma transação encontrada.'),
//     ],
//   );
// }

void addTransaction(
    MesCubit mesCubit, DateTime data, BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return const AddTransactionModal();
    },
  );
  mesCubit.changeGastos(data);
  mesCubit.changeSaldo(data);
}

void updateTransaction(
    Gasto gasto, MesCubit mesCubit, DateTime data, BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return EditTransactionModal(gasto);
    },
  );
  mesCubit.changeGastos(data);
  mesCubit.changeSaldo(data);
}

Future<void> removeMonthGasto(
    Gasto gasto, BuildContext context, MesCubit mesCubit, DateTime data) async {
  if (gasto.mode == 1) {
    var alerta = await const Alerta(
      text:
          'Deseja excluir o gasto?\nIsso excluirá todas as parcelas seguintes.',
      action: 'Sim',
      cancel: 'Cancelar',
    ).show(context);

    if (alerta) {
      List<Gasto> listParcelasGastos = await getParcelasGasto(gasto);
      listParcelasGastos.forEach((gasto) async {
        await removeGastoById(gasto.id);
        print("Excluindo gasto ${gasto.toString()}");
      });
    } else {
      print("Não foi excluido gastos parcelados");
    }

    mesCubit.changeGastos(data);
    mesCubit.changeSaldo(data);
  } else {
    var alerta = await const Alerta(
      text: 'Deseja excluir o gasto?',
      action: 'Sim',
      cancel: 'Cancelar',
    ).show(context);

    GastoHelper gastoHelper = GastoHelper();
    if (alerta) {
      print("Excluindo gasto ${gasto.toString()}");
      await gastoHelper.removeGastoById(gasto.id);
    } else {
      print("Não excluindo gasto");
    }

    mesCubit.changeGastos(data);
    mesCubit.changeSaldo(data);
  }
}

Future<int> getNumberOfParcelasMonth(Gasto gasto) {
  return getNumberOfParcelas(gasto);
}
