import 'package:cfl_app/components/customAppBar.dart';
import 'package:cfl_app/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  final String barcode;
  final Product;
  const AddProduct({Key? key, required this.barcode, this.Product}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    String productName;
    num? calories;
    num? fat;
    num? saturates;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Product',
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Product Name'),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (value){
                      setState(() {
                        productName = value;
                      });
                    },
                  )
                ],
              )
            ],
          );
        }
      ),
    );
  }
}
