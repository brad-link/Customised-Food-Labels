import 'package:cfl_app/screens/addProductScreen/addProductRows.dart';
import 'package:cfl_app/components/addProductValues.dart';
import 'package:cfl_app/components/database.dart';
import 'package:cfl_app/DataClasses/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../DataClasses/appUser.dart';
import '../../components/custom_app_bar.dart';

class AddProduct extends StatefulWidget {
  final String barcode;
  final Product product;
  final DateTime currentDate;
  const AddProduct({Key? key, required this.barcode, required this.product, required this.currentDate})
      : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    Product product = widget.product;
    product.code = widget.barcode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        backButton: true,
        title: 'Add Product',
      ),
      body: Builder(builder: (BuildContext context) {
        return  Column(
            children: [
              AddProductRows(
                  category: const Text('Barcode: ',
                    style: TextStyle(
                      fontSize: 14,
                    ),),
                  input: AddProductValues(
                  text: true,
                  value: widget.barcode,
                  category: '',
                  onchange: (value) {
                  }, enabled: false,
                  ),),
              AddProductRows(
                  category: const Text('Product name: '),
                  input: AddProductValues(
                    text: true,
                    value: product.productName,
                    category: 'Product name',
                    onchange: (value) {
                      product.productName = value;
                    }, enabled: product.productName == null,
                  )),
              AddProductRows(
                  category: const Text('Calories: '),
                  input: AddProductValues(
                    text: false,
                    enabled: true,
                    value: product.calories_100g.toString(),
                    category: 'Calories ',
                    onchange: (value) {
                      product.calories_100g = int.parse(value);
                    },
                  )),
              AddProductRows(
                  category: const Text('Fat: '),
                  input: AddProductValues(
                    text: false,
                    enabled: true,
                    value: product.fat_100g.toString(),
                    category: 'fat ',
                    onchange: (value) {
                      product.fat_100g = int.parse(value);
                    },
                  )),
              AddProductRows(
                  category: const Text('Saturates: '),
                  input: AddProductValues(
                    text: false,
                    enabled: true,
                    value: product.sat_fat100g.toString(),
                    category: 'Saturates ',
                    onchange: (value) {
                      product.sat_fat100g = int.parse(value);
                    },
                  )),
              AddProductRows(
                  category: const Text('Fibre: '),
                  input: AddProductValues(
                    text: false,
                    enabled: true,
                    value: product.fibre_100g.toString(),
                    category: 'Fibre ',
                    onchange: (value) {
                      product.fibre_100g = int.parse(value);
                    },
                  )),
              AddProductRows(
                  category: const Text('Protein: '),
                  input: AddProductValues(
                    text: false,
                    enabled: true,
                    value: product.protein_100g.toString(),
                    category: 'Protein ',
                    onchange: (value) {
                      product.protein_100g = int.parse(value);
                    },
                  )),
              AddProductRows(
                  category: const Text('Sugars: '),
                  input: AddProductValues(
                    text: false,
                    enabled: true,
                    value: product.sugar_100g.toString(),
                    category: 'Sugar ',
                    onchange: (value) {
                      product.sugar_100g = int.parse(value);
                    },
                  )),
              AddProductRows(
                  category: const Text('Salt: '),
                  input: AddProductValues(
                    text: false,
                    enabled: true,
                    value: product.salt_100g.toString(),
                    category: 'Salt ',
                    onchange: (value) {
                      product.salt_100g = int.parse(value);
                    },
                  )),
              ElevatedButton(onPressed: () async{
                if(user == null){
                  String day =
                  DateFormat('dd/MM/yyyy')
                      .format(widget.currentDate);
                  product.setDateTime(
                      DateTime.now(), day);
                  await DatabaseService().productsList(product);
                  if(!mounted) return;
                  Navigator.pop(context);
                } else{
                  String day =
                  DateFormat('dd/MM/yyyy')
                      .format(widget.currentDate);
                  product.setDateTime(
                      DateTime.now(), day);
                  await DatabaseService(uid: user.uid).addProduct(product);

                  await DatabaseService().productsList(product);
                }
                if(!mounted) return;
                Navigator.pop(context);
              }, child: const Text('Add'))
            ],

        );
      }),
    );
  }
}
