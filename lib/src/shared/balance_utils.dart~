import 'package:payment_tracker/src/shared/gasto_utils.dart';
import 'package:payment_tracker/src/shared/models/payment.dart';
import 'package:payment_tracker/src/shared/models/tag.dart';
import 'package:payment_tracker/src/shared/tag_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateBalance(double value) async {
  final prefs = await SharedPreferences.getInstance();

  double? balance = prefs.getDouble('balance');

  if (balance == null) {
    prefs.setDouble('balance', value);
    return;
  }

  balance += value;

  prefs.setDouble('balance', balance);
  return;
}

Future<double> fetchBalance() async {
  final prefs = await SharedPreferences.getInstance();

  double? balance = prefs.getDouble('balance');

  if (balance == null) {
    prefs.setDouble('balance', 0);
    return 0;
  }

  return balance;
}

Future<double> getMonthBalance(DateTime data) async {
  List<Payment> gastos = await getPaymentsByMonth(data);
  double gastosTotal = 0;
  for (int i = 0; i < gastos.length; i++) {
    gastosTotal += gastos[i].amount;
  }

  double? balance = await fetchBalance();

  return balance + gastosTotal;
}

Future<void> updateNewMonthBalance() async {
  final prefs = await SharedPreferences.getInstance();

  String? lastLogin = prefs.getString('last_login');

  if (lastLogin == null) {
    prefs.setString('last_login', DateTime.now().toString());
    return;
  }

  double balance = 0;

  DateTime lastLoginDate = DateTime.parse(lastLogin);
  DateTime now = DateTime.now();

  if (now.month != lastLoginDate.month) {
    List<Payment> lastLoginPayments = await getPaymentsByMonth(lastLoginDate);
    for (int i = 0; i < lastLoginPayments.length; i++) {
      balance += lastLoginPayments[i].amount;
    }

    // Adicionar um novo pagamento ao mês atual com o valor total dos gastos
    Tag? tag = await getTagByName('paid');
    if (tag != null) {
      insertPayment(await createPayment(
          DateTime(now.year, now.month, 1), balance, tag, "Saldo", 0, 0));
    } else {
      Tag paidTag = await createTag('paid');
      await insertTag(paidTag);
    }
  }

  prefs.setString('last_login', now.toString());
}
