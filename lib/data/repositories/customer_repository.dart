import 'package:hive/hive.dart';
import '../models/customer.dart';

class CustomerRepository {
  static const String boxName = 'customers';
  late Box<Customer> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Customer>(boxName);
  }

  Future<void> addCustomer(Customer customer) async {
    await _box.put(customer.id, customer);
  }

  Future<void> updateCustomer(Customer customer) async {
    await _box.put(customer.id, customer);
  }

  Future<void> deleteCustomer(String id) async {
    await _box.delete(id);
  }

  List<Customer> getAllCustomers() {
    return _box.values.toList();
  }

  List<Customer> getCustomersByStatus(String status) {
    return _box.values.where((customer) => customer.status == status).toList();
  }

  Customer? getCustomerById(String id) {
    return _box.get(id);
  }
}
