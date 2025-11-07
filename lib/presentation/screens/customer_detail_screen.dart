import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/customer.dart';
import 'customer_form_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;
  final Function(Customer) onUpdate;
  final Function() onDelete;

  const CustomerDetailScreen({
    super.key,
    required this.customer,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedCustomer = await Navigator.push<Customer>(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerFormScreen(customer: customer),
                ),
              );
              if (updatedCustomer != null) {
                onUpdate(updatedCustomer);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(
            context,
            title: 'İletişim Bilgileri',
            icon: Icons.contact_mail,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.phone, 'Telefon', customer.phone),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.email, 'E-posta', customer.email),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: 'Hizmet Bilgileri',
            icon: Icons.business_center,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    Icons.category, 'Hizmetler', customer.services.join(', ')),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.event, 'Başlangıç',
                    DateFormat('dd/MM/yyyy').format(customer.startDate)),
                if (customer.endDate != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.event_available, 'Bitiş',
                      DateFormat('dd/MM/yyyy').format(customer.endDate!)),
                ],
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.flag, 'Durum', _getStatusText(customer.status)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: 'Ödeme Bilgileri',
            icon: Icons.payment,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.account_balance_wallet, 'Ödeme Türü',
                    customer.paymentType),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.attach_money, 'Ödeme Miktarı',
                    '₺${customer.paymentAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.calendar_today, 'Sonraki Ödeme',
                    DateFormat('dd/MM/yyyy').format(customer.nextPaymentDate)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'completed':
        return 'Tamamlandı';
      case 'postponed':
        return 'Ertelendi';
      default:
        return status;
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Müşteriyi Sil'),
        content: const Text('Bu müşteriyi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (result == true) {
      onDelete();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
