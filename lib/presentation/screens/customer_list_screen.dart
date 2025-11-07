import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/customer.dart';
import '../viewmodels/customer_list_viewmodel.dart';
import '../widgets/customer_card.dart';
import 'customer_form_screen.dart';
import 'customer_detail_screen.dart';
import 'login_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerListViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('GenZ CRM'),
            actions: [
              // Çıkış butonu
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Çıkış Yap'),
                      content:
                          const Text('Çıkış yapmak istediğinize emin misiniz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('İptal'),
                        ),
                        FilledButton(
                          onPressed: () {
                            context.read<AuthService>().logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('Çıkış Yap'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                onSelected: (value) => viewModel.filterByStatus(value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: '',
                    child: Text('Tümü'),
                  ),
                  const PopupMenuItem(
                    value: 'active',
                    child: Text('Aktif'),
                  ),
                  const PopupMenuItem(
                    value: 'completed',
                    child: Text('Tamamlandı'),
                  ),
                  const PopupMenuItem(
                    value: 'postponed',
                    child: Text('Ertelendi'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Müşteri ara...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => viewModel.searchCustomers(value),
                ),
              ),
              Expanded(
                child: viewModel.customers.isEmpty
                    ? const Center(
                        child: Text('Henüz müşteri bulunmamaktadır.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: viewModel.customers.length,
                        itemBuilder: (context, index) {
                          final customer = viewModel.customers[index];
                          return CustomerCard(
                            customer: customer,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerDetailScreen(
                                    customer: customer,
                                    onUpdate: (updatedCustomer) {
                                      viewModel.updateCustomer(updatedCustomer);
                                      Navigator.pop(context);
                                    },
                                    onDelete: () {
                                      viewModel.deleteCustomer(customer.id);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final customer = await Navigator.push<Customer>(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerFormScreen(),
                ),
              );
              if (customer != null) {
                viewModel.addCustomer(customer);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Yeni Müşteri'),
          ),
        );
      },
    );
  }
}
