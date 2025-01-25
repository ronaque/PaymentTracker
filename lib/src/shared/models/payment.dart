import 'package:payment_tracker/src/shared/models/tag.dart';

/// Class representing an expense
/// id: Unique identifier of the expense
/// data: Date on which the expense was incurred
/// quantidade: Amount spent
/// tag: Tag associated with the expense
/// descricao: Description of the expense
/// mode: Payment method (0 - cash, 1 - installment, 2 - subscription)
/// parcelas: Number of installments (if the expense is paid in installments)

class Payment {
  int id;
  DateTime date;
  double amount;
  Tag tag;
  String? description;
  int mode;
  int? installments;

  Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.tag,
    this.description,
    required this.mode,
    this.installments,
  });

  // Converte um objeto Gasto em um Map para persistir no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'tag_id': tag.id, // Salva o ID da tag associada
      'description': description,
      'mode': mode,
      'installments': installments
    };
  }

  // Construtor que converte um Map em um objeto Gasto
  Payment.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        date = DateTime.parse(map['date']),
        amount = map['amount'],
        tag = Tag.fromMap({'id': map['tag_id'], 'name': map['tag_name']}),
        description = map['description'], // Agora pode ser nulo
        mode = map['mode'],
        installments = map['installments'];

  @override
  String toString() {
    return 'Payment{id: $id, date: $date, amount: $amount, tag: ${tag.toString()}, description: $description, mode: $mode, installments: $installments}';
  }
}
