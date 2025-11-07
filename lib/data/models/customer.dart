import 'package:hive/hive.dart';

part 'customer.g.dart';

@HiveType(typeId: 0)
class Customer extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String email;

  @HiveField(4)
  List<String> services;

  @HiveField(5)
  DateTime startDate;

  @HiveField(6)
  DateTime? endDate;

  @HiveField(7)
  String paymentType;

  @HiveField(8)
  double paymentAmount;

  @HiveField(9)
  DateTime nextPaymentDate;

  @HiveField(10)
  String status; // 'active', 'completed', 'postponed'

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.services,
    required this.startDate,
    this.endDate,
    required this.paymentType,
    required this.paymentAmount,
    required this.nextPaymentDate,
    required this.status,
  });

  factory Customer.create({
    required String name,
    required String phone,
    required String email,
    required List<String> services,
    required DateTime startDate,
    DateTime? endDate,
    required String paymentType,
    required double paymentAmount,
    required DateTime nextPaymentDate,
    required String status,
  }) {
    return Customer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      email: email,
      services: services,
      startDate: startDate,
      endDate: endDate,
      paymentType: paymentType,
      paymentAmount: paymentAmount,
      nextPaymentDate: nextPaymentDate,
      status: status,
    );
  }
}
