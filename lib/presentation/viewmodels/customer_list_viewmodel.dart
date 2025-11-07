import 'package:flutter/foundation.dart';
import '../../data/models/customer.dart';
import '../../data/repositories/customer_repository.dart';
import '../../core/services/notification_service.dart';

class CustomerListViewModel extends ChangeNotifier {
  final CustomerRepository _repository;
  final NotificationService _notificationService = NotificationService();
  List<Customer> _customers = [];
  String _searchQuery = '';
  String _statusFilter = '';

  CustomerListViewModel(this._repository) {
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _notificationService.init();
    _loadCustomers();
  }

  List<Customer> get customers {
    return _filterCustomers();
  }

  void _loadCustomers() {
    _customers = _repository.getAllCustomers();
    notifyListeners();
  }

  void searchCustomers(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void filterByStatus(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  List<Customer> _filterCustomers() {
    return _customers.where((customer) {
      final matchesSearch =
          customer.name.toLowerCase().contains(_searchQuery) ||
              customer.email.toLowerCase().contains(_searchQuery);

      final matchesStatus =
          _statusFilter.isEmpty || customer.status == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> addCustomer(Customer customer) async {
    await _repository.addCustomer(customer);
    await _scheduleNotifications(customer);
    _loadCustomers();
  }

  Future<void> updateCustomer(Customer customer) async {
    await _repository.updateCustomer(customer);
    await _notificationService.cancelCustomerNotifications(customer.id);
    await _scheduleNotifications(customer);
    _loadCustomers();
  }

  Future<void> deleteCustomer(String id) async {
    await _repository.deleteCustomer(id);
    await _notificationService.cancelCustomerNotifications(id);
    _loadCustomers();
  }

  Future<void> _scheduleNotifications(Customer customer) async {
    await _notificationService.schedulePaymentReminder(
      customerId: customer.id,
      customerName: customer.name,
      paymentDate: customer.nextPaymentDate,
    );

    if (customer.endDate != null) {
      await _notificationService.scheduleServiceReminder(
        customerId: customer.id,
        customerName: customer.name,
        endDate: customer.endDate!,
      );
    }
  }
}
