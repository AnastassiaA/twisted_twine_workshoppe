import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/product_catalogue_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/product_catalogue_model.dart';
import 'package:twisted_twine_workshopppe/Views/Forms/add_product_to_catalogue.dart';

class ProductCataloguePage extends StatefulWidget {
  const ProductCataloguePage({super.key});

  @override
  State<ProductCataloguePage> createState() => _ProductCataloguePageState();
}

class _ProductCataloguePageState extends State<ProductCataloguePage> {
  bool isLoading = true;
  List<ProductCatalogueModel> productList = [];

  getAllProduct() async {
    final productData = await ProductCatalogueController.getAllProducts();

    setState(() {
      productList =
          productData.map((e) => ProductCatalogueModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllProduct();
    super.initState();
  }

  Future refresh() async {
    productList.clear();
    getAllProduct();
  }

  void deleteProduct(
      {required ProductCatalogueModel product,
      required BuildContext context}) async {
    ProductCatalogueController.deleteProduct(product.productId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllProduct();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        actions: [
          const Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,

            ),
            
          ),
          const IconButton(onPressed: null, icon: Icon(Icons.sort)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProductToCatalogue()),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              //scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shadowColor: const Color(0xffefdff9),
                    surfaceTintColor: const Color(0xffefdff9),
                    color: const Color(0xffefdff9),
                    child: GestureDetector(
                      onDoubleTap: () {
                        //edit
                      },
                      child: Column(
                        children: [
                          Image.memory(
                            base64Decode(productList[index].image),
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.7,
                          ),
                          ListTile(
                            title: Text(
                              productList[index].productName,
                              style: const TextStyle(fontSize: 35),
                            ),
                            subtitle: Text(
                              '\$' '${productList[index].price}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            // trailing: Text(
                            //     'Total time: ${twoDigits(productList[index].duration.inHours.remainder(60))} hr'
                            //     ' '
                            //     '${twoDigits(productList[index].duration.inMinutes.remainder(60))} min'
                            //     ' '
                            //     '${twoDigits(productList[index].duration.inSeconds.remainder(60))} sec'),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
