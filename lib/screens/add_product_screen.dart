import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _productName;
  int? _quantity;
  DateTime? _expiryDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ürün Ekle')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Ürün Adı
              TextFormField(
                decoration: InputDecoration(labelText: 'Ürün Adı'),
                onSaved: (val) => _productName = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Zorunlu alan' : null,
              ),
              SizedBox(height: 16),
              // Miktar
              TextFormField(
                decoration: InputDecoration(labelText: 'Miktar'),
                keyboardType: TextInputType.number,
                onSaved: (val) =>
                    _quantity = val != null ? int.tryParse(val) : null,
                validator: (val) =>
                    val == null || int.tryParse(val!) == null
                        ? 'Geçerli sayı gir'
                        : null,
              ),
              SizedBox(height: 16),
              // Son Kullanım Tarihi
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _expiryDate == null
                          ? 'Tarih seçilmedi'
                          : 'Seçilen: ${_expiryDate!.toLocal()}'
                              .split(' ')[0],
                    ),
                  ),
                  TextButton(
                    child: Text('Tarih Seç'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _expiryDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                child: Text('Kaydet'),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _expiryDate != null) {
                    _formKey.currentState!.save();
                    // TODO: Firestore veya local DB kaydı
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ürün kaydedildi!')),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
