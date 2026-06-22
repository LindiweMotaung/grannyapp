import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedMethods = prefs.getStringList('payment_methods');

    if (savedMethods != null && savedMethods.isNotEmpty) {
      setState(() {
        _paymentMethods = savedMethods.map((method) {
          final parts = method.split('|');
          return PaymentMethod(
            type: parts[0],
            lastFourDigits: parts.length > 1 ? parts[1] : '',
            expiryDate: parts.length > 2 ? parts[2] : '',
            cardholderName: parts.length > 3 ? parts[3] : '',
            isDefault: parts.length > 4 ? parts[4] == 'true' : false,
          );
        }).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> methodsToSave = _paymentMethods.map((method) {
      return '${method.type}|${method.lastFourDigits}|${method.expiryDate}|${method.cardholderName}|${method.isDefault}';
    }).toList();
    await prefs.setStringList('payment_methods', methodsToSave);
  }

  void _addPaymentMethod() {
    showDialog(
      context: context,
      builder: (context) => _AddPaymentMethodDialog(
        onAdd: (method) {
          setState(() {
            if (method.isDefault) {
              for (var m in _paymentMethods) {
                m.isDefault = false;
              }
            }
            _paymentMethods.add(method);
          });
          _savePaymentMethods();
        },
      ),
    );
  }

  void _setDefaultPaymentMethod(int index) {
    setState(() {
      for (int i = 0; i < _paymentMethods.length; i++) {
        _paymentMethods[i].isDefault = (i == index);
      }
    });
    _savePaymentMethods();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default payment method updated'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deletePaymentMethod(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: const Text('Are you sure you want to remove this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _paymentMethods.removeAt(index);
              });
              _savePaymentMethods();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment method removed'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FCFB),
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: const Color(0xFF1FC8DB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info Card
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: Colors.green.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your payment information is encrypted and secure. Add a payment method for easy billing.',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Payment Methods List
                Expanded(
                  child: _paymentMethods.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card_off,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No payment methods added',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add a payment method to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _paymentMethods.length,
                          itemBuilder: (context, index) {
                            final method = _paymentMethods[index];
                            return _buildPaymentMethodCard(method, index);
                          },
                        ),
                ),

                // Add Button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _addPaymentMethod,
                      icon: const Icon(Icons.add_card),
                      label: const Text(
                        'Add Payment Method',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1FC8DB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method, int index) {
    IconData cardIcon;
    Color cardColor;

    switch (method.type) {
      case 'Visa':
        cardIcon = Icons.credit_card;
        cardColor = Colors.blue;
        break;
      case 'Mastercard':
        cardIcon = Icons.credit_card;
        cardColor = Colors.orange;
        break;
      case 'Bank Account':
        cardIcon = Icons.account_balance;
        cardColor = Colors.green;
        break;
      case 'Cash':
        cardIcon = Icons.payments;
        cardColor = Colors.teal;
        break;
      default:
        cardIcon = Icons.payment;
        cardColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: method.isDefault
            ? Border.all(color: const Color(0xFF1FC8DB), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: cardColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(cardIcon, color: cardColor, size: 28),
        ),
        title: Row(
          children: [
            Text(
              method.type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (method.isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1FC8DB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'DEFAULT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (method.cardholderName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(method.cardholderName),
            ],
            if (method.lastFourDigits.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text('•••• ${method.lastFourDigits}'),
            ],
            if (method.expiryDate.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text('Expires: ${method.expiryDate}'),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'default') {
              _setDefaultPaymentMethod(index);
            } else if (value == 'delete') {
              _deletePaymentMethod(index);
            }
          },
          itemBuilder: (context) => [
            if (!method.isDefault)
              const PopupMenuItem(
                value: 'default',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20),
                    SizedBox(width: 8),
                    Text('Set as Default'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Remove', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  String type;
  String lastFourDigits;
  String expiryDate;
  String cardholderName;
  bool isDefault;

  PaymentMethod({
    required this.type,
    this.lastFourDigits = '',
    this.expiryDate = '',
    this.cardholderName = '',
    this.isDefault = false,
  });
}

class _AddPaymentMethodDialog extends StatefulWidget {
  final Function(PaymentMethod) onAdd;

  const _AddPaymentMethodDialog({required this.onAdd});

  @override
  State<_AddPaymentMethodDialog> createState() => _AddPaymentMethodDialogState();
}

class _AddPaymentMethodDialogState extends State<_AddPaymentMethodDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Visa';
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _nameController = TextEditingController();
  bool _setAsDefault = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Payment Method'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Type Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Payment Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Visa', child: Text('Visa')),
                  DropdownMenuItem(value: 'Mastercard', child: Text('Mastercard')),
                  DropdownMenuItem(value: 'Bank Account', child: Text('Bank Account')),
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                ],
                onChanged: (value) {
                  setState(() => _selectedType = value!);
                },
              ),
              const SizedBox(height: 16),

              // Cardholder Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Card Number (Last 4 digits)
              if (_selectedType != 'Cash')
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Last 4 Digits',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter last 4 digits';
                    }
                    if (value.length != 4) {
                      return 'Must be 4 digits';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),

              // Expiry Date
              if (_selectedType != 'Cash' && _selectedType != 'Bank Account')
                TextFormField(
                  controller: _expiryController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date (MM/YY)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expiry date';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 8),

              // Set as Default
              CheckboxListTile(
                title: const Text('Set as default'),
                value: _setAsDefault,
                onChanged: (value) {
                  setState(() => _setAsDefault = value ?? false);
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(PaymentMethod(
                type: _selectedType,
                lastFourDigits: _cardNumberController.text,
                expiryDate: _expiryController.text,
                cardholderName: _nameController.text,
                isDefault: _setAsDefault,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
