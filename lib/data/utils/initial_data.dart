import '../models/customer.dart';
import '../repositories/customer_repository.dart';

class InitialData {
  static Future<void> initializeData(CustomerRepository repository) async {
    final customers = repository.getAllCustomers();
    if (customers.isEmpty) {
      final demoCustomers = [
        Customer(
          id: '1',
          name: 'Ahmet Yılmaz',
          phone: '0532 111 2233',
          email: 'ahmet@example.com',
          services: ['Web Tasarım', 'SEO'],
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 90)),
          paymentType: 'Kredi Kartı',
          paymentAmount: 5000,
          nextPaymentDate: DateTime.now().add(const Duration(days: 30)),
          status: 'active',
        ),
        Customer(
          id: '2',
          name: 'Ayşe Demir',
          phone: '0533 444 5566',
          email: 'ayse@example.com',
          services: ['Sosyal Medya Yönetimi', 'İçerik Yazarlığı'],
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 150)),
          paymentType: 'Havale',
          paymentAmount: 3500,
          nextPaymentDate: DateTime.now().add(const Duration(days: 15)),
          status: 'active',
        ),
        Customer(
          id: '3',
          name: 'Mehmet Kaya',
          phone: '0535 777 8899',
          email: 'mehmet@example.com',
          services: ['Mobil Uygulama', 'Digital Marketing'],
          startDate: DateTime.now().subtract(const Duration(days: 60)),
          endDate: null,
          paymentType: 'Nakit',
          paymentAmount: 7500,
          nextPaymentDate: DateTime.now().add(const Duration(days: 7)),
          status: 'postponed',
        ),
      ];

      for (final customer in demoCustomers) {
        await repository.addCustomer(customer);
      }
    }
  }
}
