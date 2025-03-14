import 'package:payment_tracker/src/shared/repositories/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:payment_tracker/src/shared/models/payment.dart';

class PaymentHelper {
  Future<Database> get database async {
    DatabaseHelper dbHelper = DatabaseHelper();

    Database db = await dbHelper.database;
    return db;
  }

  Future<void> insertPayment(Payment payment) async {
    Database db = await database;
    await db.insert('payment', payment.toMap());
  }

  Future<List<Payment>> getAllPayments() async {
    Database db = await database;
    List<Map<String, Object?>> maps = await db.query('payment');
    return List.generate(maps.length, (i) {
      return Payment.fromMap(maps[i]);
    });
  }

  Future<List<Payment>> getPaymentsByTagName(String tag) async {
    Database db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT payment.id, payment.date, payment.amount, payment.description, payment.mode, payment.installments, tag.name as tag_name, 
    FROM payment
    INNER JOIN tag ON payment.tag_id = tag.id
    WHERE tag.name = ?
  ''', [tag]);

    return List.generate(result.length, (i) {
      return Payment.fromMap(result[i]);
    });
  }

  Future<List<Payment>> getPaymentsByTagId(int tagId) async {
    Database db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT payment.id, payment.date, payment.amount, payment.description, payment.mode, payment.installments, tag.name as tag_name
    FROM payment
    INNER JOIN tag ON payment.tag_id = tag.id
    WHERE payment.tag_id = ?
  ''', [tagId]);

    return List.generate(result.length, (i) {
      return Payment.fromMap(result[i]);
    });
  }

  Future<List<Payment>> getPaymentsByMonth(String ano, String mes) async {
    Database db = await database;

    String query = '''
        SELECT payment.*, tag.id as tag_id, tag.name as tag_name
        FROM payment
        INNER JOIN tag ON payment.tag_id = tag.id
        WHERE strftime('%Y', payment.date) = ? AND strftime('%m', payment.date) = ?
      ''';

    final List<Map<String, Object?>> result =
        await db.rawQuery(query, [ano, mes]);

    return List.generate(result.length, (i) {
      return Payment.fromMap(result[i]);
    });
  }

  Future<List<Payment>> getPaymentsByMonthAndPositiveExpense(
      String year, String month) async {
    try {
      Database db = await database;

      String query = '''
        SELECT payment.*, tag.id as tag_id, tag.name as tag_name
        FROM payment
        LEFT JOIN tag ON payment.tag_id = tag.id
        WHERE strftime('%Y', payment.date) = ? AND strftime('%m', payment.date) = ? AND payment.amount >= 0
      ''';

      List<Map<String, Object?>> resultado =
          await db.rawQuery(query, [year, month]);

      return List.generate(resultado.length, (i) {
        return Payment.fromMap(resultado[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<List<Payment>> getPaymentsByMonthAndNegativeExpense(
      String year, String month) async {
    Database db = await database;

    String query = '''
        SELECT payment.*, tag.id as tag_id, tag.name as tag_name
        FROM payment
        LEFT JOIN tag ON payment.tag_id = tag.id
        WHERE strftime('%Y', payment.date) = ? AND strftime('%m', payment.date) = ? AND payment.amount < 0
      ''';

    List<Map<String, Object?>> result = await db.rawQuery(query, [year, month]);

    return List.generate(result.length, (i) {
      return Payment.fromMap(result[i]);
    });
  }

  Future<List<Payment>> getPaymentsListByCriteria({
    required DateTime date,
    required int tagId,
    String? description,
    double? amount,
    int? installments,
  }) async {
    try {
      Database db = await database;

      String query = '''
      SELECT payment.id, payment.date, payment.amount, payment.description, payment.mode, payment.installments, tag.id as tag_id, tag.name as tag_name
      FROM payment
      LEFT JOIN tag ON payment.tag_id = tag.id
      WHERE payment.date = ? AND payment.tag_id = ?
      ${description != null ? 'AND payment.description = ?' : ''}
      ${amount != null ? 'AND payment.amount = ?' : ''}
      ${installments != null ? 'AND payment.installments = ?' : ''}
    ''';

      final List<Map<String, Object?>> result = await db.rawQuery(query, [
        date.toIso8601String(),
        tagId,
        if (description != null) description,
        if (amount != null) amount,
        if (installments != null) installments,
      ]);

      return List.generate(result.length, (i) {
        return Payment.fromMap(result[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<Payment?> getPaymentByCriteria({
    required DateTime date,
    required int tagId,
    String? description,
    double? amount,
    int? installments,
  }) async {
    try {
      Database db = await database;

      // Construir a consulta SQL dinamicamente com base nos parâmetros fornecidos
      String query = '''
      SELECT payment.id, payment.date, payment.amount, payment.description, payment.mode, payment.installments, tag.id as tag_id, tag.name as tag_name
      FROM payment
      LEFT JOIN tag ON payment.tag_id = tag.id
      WHERE payment.date = ? AND payment.tag_id = ?
      ${description != null ? 'AND payment.description = ?' : ''}
      ${amount != null ? 'AND payment.amount = ?' : ''}
      ${installments != null ? 'AND payment.installments = ?' : ''}
      LIMIT 1
    ''';

      final List<Map<String, Object?>> result = await db.rawQuery(query, [
        date.toIso8601String(),
        tagId,
        if (description != null) description,
        if (amount != null) amount,
        if (installments != null) installments,
      ]);

      // Retorna o primeiro resultado encontrado, ou null se não houver resultados
      if (result.isNotEmpty) {
        return Payment.fromMap(result.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> updatePayment(Payment payment) async {
    try {
      Database db = await database;

      await db.update(
        'payment',
        payment.toMap(),
        where: 'id = ?',
        whereArgs: [payment.id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removePayment(Payment payment) async {
    try {
      Database db = await database;

      await db.delete(
        'payment',
        where: 'id = ?',
        whereArgs: [payment.id],
      );
    } catch (e) {
      print("Could not remove payment: $e");
    }
  }

  Future<void> removePaymentById(int paymentId) async {
    try {
      Database db = await database;

      await db.delete(
        'payment',
        where: 'id = ?',
        whereArgs: [paymentId],
      );
    } catch (e) {
      print('Erro ao remover payment por ID: $e');
    }
  }

  Future<int> countInstallmentsOfPayment({
    required DateTime date,
    required int tagId,
    String? description,
    double? amount,
  }) async {
    try {
      Database db = await database;

      // Extrair o dia da date
      String day = date.day.toString().padLeft(2, '0');

      // Construir a consulta SQL dinamicamente com base nos parâmetros fornecidos
      String query = '''
    SELECT COUNT(*) as count
    FROM payment
    LEFT JOIN tag ON payment.tag_id = tag.id
    WHERE payment.tag_id = ?
    ${description != null ? 'AND payment.description = ?' : ''}
    ${amount != null ? 'AND payment.amount = ?' : ''}
    AND payment.installments IS NOT NULL
  ''';

      final List<Map<String, Object?>> result = await db.rawQuery(query, [
        tagId,
        if (description != null) description,
        if (amount != null) amount,
      ]);

      if (result.isNotEmpty) {
        return Sqflite.firstIntValue(result) ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
}
