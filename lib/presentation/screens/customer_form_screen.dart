import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/customer.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  const CustomerFormScreen({super.key, this.customer});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _paymentAmountController;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  DateTime _nextPaymentDate = DateTime.now();
  String _paymentType = 'Nakit';
  String _status = 'active';
  final List<String> _selectedServices = [];

  final List<String> _availableServices = [
    'Web Tasarım',
    'Mobil Uygulama',
    'SEO',
    'Sosyal Medya Yönetimi',
    'Grafik Tasarım',
    'İçerik Yazarlığı',
    'E-ticaret Çözümleri',
    'Digital Marketing',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
    _phoneController = TextEditingController(text: widget.customer?.phone);
    _emailController = TextEditingController(text: widget.customer?.email);
    _paymentAmountController = TextEditingController(
      text: widget.customer?.paymentAmount.toString(),
    );

    if (widget.customer != null) {
      _startDate = widget.customer!.startDate;
      _endDate = widget.customer!.endDate;
      _nextPaymentDate = widget.customer!.nextPaymentDate;
      _paymentType = widget.customer!.paymentType;
      _status = widget.customer!.status;
      _selectedServices.addAll(widget.customer!.services);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _paymentAmountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      void Function(DateTime) onSelect) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      onSelect(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.customer == null ? 'Yeni Müşteri' : 'Müşteriyi Düzenle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Müşteri Adı Soyadı',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen müşteri adını girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefon',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen telefon numarası girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen e-posta adresini girin';
                }
                if (!value.contains('@')) {
                  return 'Geçerli bir e-posta adresi girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hizmetler',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _availableServices.map((service) {
                        final isSelected = _selectedServices.contains(service);
                        return FilterChip(
                          label: Text(service),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedServices.add(service);
                              } else {
                                _selectedServices.remove(service);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Başlangıç Tarihi'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_startDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(
                context,
                _startDate,
                (date) => setState(() => _startDate = date),
              ),
            ),
            ListTile(
              title: const Text('Bitiş Tarihi'),
              subtitle: Text(_endDate == null
                  ? 'Belirlenmedi'
                  : DateFormat('dd/MM/yyyy').format(_endDate!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(
                context,
                _endDate ?? DateTime.now(),
                (date) => setState(() => _endDate = date),
              ),
            ),
            ListTile(
              title: const Text('Sonraki Ödeme Tarihi'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_nextPaymentDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(
                context,
                _nextPaymentDate,
                (date) => setState(() => _nextPaymentDate = date),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _paymentType,
              decoration: const InputDecoration(
                labelText: 'Ödeme Türü',
                prefixIcon: Icon(Icons.payment),
              ),
              items: const [
                DropdownMenuItem(value: 'Nakit', child: Text('Nakit')),
                DropdownMenuItem(
                    value: 'Kredi Kartı', child: Text('Kredi Kartı')),
                DropdownMenuItem(value: 'Havale', child: Text('Havale')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _paymentType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _paymentAmountController,
              decoration: const InputDecoration(
                labelText: 'Ödeme Miktarı',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen ödeme miktarını girin';
                }
                if (double.tryParse(value) == null) {
                  return 'Geçerli bir miktar girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Durum',
                prefixIcon: Icon(Icons.store),
              ),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Aktif')),
                DropdownMenuItem(value: 'completed', child: Text('Tamamlandı')),
                DropdownMenuItem(value: 'postponed', child: Text('Ertelendi')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _status = value);
                }
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveCustomer,
              child: Text(
                widget.customer == null
                    ? 'Müşteri Ekle'
                    : 'Değişiklikleri Kaydet',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCustomer() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('En az bir hizmet seçmelisiniz'),
          ),
        );
        return;
      }

      final customer = Customer(
        id: widget.customer?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        services: _selectedServices,
        startDate: _startDate,
        endDate: _endDate,
        paymentType: _paymentType,
        paymentAmount: double.parse(_paymentAmountController.text),
        nextPaymentDate: _nextPaymentDate,
        status: _status,
      );

      Navigator.of(context).pop(customer);
    }
  }
}
