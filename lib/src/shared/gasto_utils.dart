import 'package:payment_tracker/src/shared/models/payment.dart';
import 'package:payment_tracker/src/shared/models/tag.dart';
import 'package:payment_tracker/src/shared/repositories/payment_helper.dart';
import 'package:payment_tracker/src/shared/tag_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<Payment> createPayment(DateTime date, double amount, Tag tag,
    String description, int mode, int installments) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('payment_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('payment_id', id);
  return Payment(
      id: id,
      date: date,
      amount: amount,
      tag: tag,
      description: description,
      mode: mode,
      installments: installments);
}

Future<void> insertPayment(Payment payment) async {
  PaymentHelper paymentHelper = PaymentHelper();
  paymentHelper.insertPayment(payment);
}

Future<void> removePayment(Payment payment) async {
  PaymentHelper paymentHelper = PaymentHelper();
  paymentHelper.removePayment(payment);
}

Future<void> removePaymentById(int id) async {
  PaymentHelper paymentHelper = PaymentHelper();
  paymentHelper.removePaymentById(id);
}

Future<bool> updatePayment(Payment payment) async {
  PaymentHelper paymentHelper = PaymentHelper();
  return paymentHelper.updatePayment(payment);
}

Future<List<Payment>> getAllPayments() async {
  PaymentHelper paymentHelper = PaymentHelper();
  return paymentHelper.getAllPayments();
}

Future<List<Payment>> getPaymentsByTagName(String tagName) async {
  PaymentHelper paymentHelper = PaymentHelper();
  Tag? tag = await getTagByName(tagName);
  if (tag == null) {
    return [];
  }

  return paymentHelper.getPaymentsByTagName(tagName);
}

Future<List<Payment>> getPaymentsByTagId(int tagId) async {
  PaymentHelper paymentHelper = PaymentHelper();
  Tag? tag = await getTagById(tagId);
  if (tag == null) {
    return [];
  }

  return paymentHelper.getPaymentsByTagId(tagId);
}

Future<List<Payment>> getPaymentsByMonth(DateTime date) async {
  PaymentHelper paymentHelper = PaymentHelper();

  String year = DateFormat('y').format(date);
  String month = DateFormat('MM').format(date);

  return paymentHelper.getPaymentsByMonth(year, month);
}

Future<List<Payment>> getPaymentsByMonthAndPositiveExpense(DateTime date) {
  PaymentHelper paymentHelper = PaymentHelper();

  String year = DateFormat('y').format(date);
  String month = DateFormat('MM').format(date);

  return paymentHelper.getPaymentsByMonthAndPositiveExpense(year, month);
}

Future<List<Payment>> getPaymentsByMonthAndNegativeExpense(DateTime date) {
  PaymentHelper paymentHelper = PaymentHelper();

  String year = DateFormat('y').format(date);
  String month = DateFormat('MM').format(date);

  return paymentHelper.getPaymentsByMonthAndNegativeExpense(year, month);
}

Future<List<Payment>> getInstallmentsPayment(Payment payment) async {
  PaymentHelper paymentHelper = PaymentHelper();
  List<Payment> listInstallments = [payment];
  Payment? actualPayment = payment;
  while (true) {
    DateTime date = actualPayment!.date;
    int installments = actualPayment.installments! + 1;
    int year = date.year;
    int month = date.month + 1;
    if (month > 12) {
      month = month - 12;
      year += 1;
    }
    date = DateTime(year, month, 1);

    actualPayment = await paymentHelper.getPaymentByCriteria(
        date: date,
        tagId: payment.tag.id,
        description: payment.description!,
        amount: payment.amount,
        installments: installments);
    if (actualPayment == null) {
      break;
    } else {
      listInstallments.add(actualPayment);
    }
  }

  return listInstallments;
}

Future<int> getNumberOfInstallments(Payment payment) async {
  PaymentHelper paymentHelper = PaymentHelper();

  DateTime date = payment.date;
  int tagId = payment.tag.id;
  String? description = payment.description;
  double amount = payment.amount;
  int countInstallments = await paymentHelper.countInstallmentsOfPayment(
      date: date, tagId: tagId, description: description, amount: amount);
  return countInstallments;
}
