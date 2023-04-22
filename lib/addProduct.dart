import 'package:cfl_app/addProductRows.dart';
import 'package:cfl_app/components/addProductValues.dart';
import 'package:cfl_app/components/customAppBar.dart';
import 'package:cfl_app/database.dart';
import 'package:cfl_app/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'appUser.dart';

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
      appBar: const CustomAppBar(
        title: 'Add Product',
      ),
      body: Builder(builder: (BuildContext context) {
        return  Column(
            children: [
              AddProductRows(
                  category: const Text('Barcode: '),
                  input: Text(widget.barcode)),
              AddProductRows(
                  category: const Text('Product name: '),
                  input: AddProductValues(
                    text: true,
                    isFilled: product.productName == null,
                    value: product.productName,
                    category: 'Product name',
                    onchange: (String ) {
                      product.productName = String;
                    },
                  )),
              AddProductRows(
                  category: const Text('Calories: '),
                  input: AddProductValues(
                    text: false,
                    isFilled: product.calories_100g == null,
                    value: product.calories_100g.toString(),
                    category: 'Calories ',
                    onchange: (String ) {
                      product.calories_100g = int.parse(String);
                    },
                  )),
              AddProductRows(
                  category: const Text('Fat: '),
                  input: AddProductValues(
                    text: false,
                    isFilled: product.fat_100g == null,
                    value: product.fat_100g.toString(),
                    category: 'fat ',
                    onchange: (String ) {
                      product.fat_100g = int.parse(String);
                    },
                  )),
              AddProductRows(
                  category: const Text('Saturates: '),
                  input: AddProductValues(
                    text: false,
                    isFilled: product.satFat_100g == null,
                    value: product.sat_fat100g.toString(),
                    category: 'Saturates ',
                    onchange: (String) {
                      product.sat_fat100g = int.parse(String);
                    },
                  )),
              AddProductRows(
                  category: const Text('Fibre: '),
                  input: AddProductValues(
                    text: false,
                    isFilled: product.fibre_100g == null,
                    value: product.fibre_100g.toString(),
                    category: 'Fibre ',
                    onchange: (String ) {
                      product.fibre_100g = int.parse(String);
                    },
                  )),
              AddProductRows(
                  category: const Text('Protein: '),
                  input: AddProductValues(
                    text: false,
                    isFilled: product.protein_100g == null,
                    value: product.protein_100g.toString(),
                    category: 'Protein ',
                    onchange: (String ) {
                      product.protein_100g = int.parse(String);
                    },
                  )),
              AddProductRows(
                  category: const Text('Sugars: '),
                  input: AddProductValues(
                    text: false,
                    isFilled: product.sugar_100g == null,
                    value: product.sugar_100g.toString(),
                    category: 'Sugar ',
                    onchange: (String ) {
                      product.sugar_100g = int.parse(String);
                    },
                  )),
              AddProductRows(
                  category: const Text('Salt: '),
                  input: AddProductValues(
                    text: false,
                    isFilled: product.salt_100g == null,
                    value: product.salt_100g.toString(),
                    category: 'Salt ',
                    onchange: (String ) {
                      product.salt_100g = int.parse(String);
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
                  Navigator.pop(context);
                } else{
                  String day =
                  DateFormat('dd/MM/yyyy')
                      .format(widget.currentDate);
                  product.setDateTime(
                      DateTime.now(), day);
                  await DatabaseService(uid: user?.uid).addProduct(product);

                  await DatabaseService().productsList(product);
                }
                Navigator.pop(context);
              }, child: const Text('Add'))
            ],

        );
      }),
    );
  }
}
