import 'package:twisted_twine_workshopppe/Models/Const/product_catalogue_const.dart';

class ProductCatalogueModel {
  final int? productId;
  final String image;
  final String productName;
  final double price;
  final Duration? duration;

  ProductCatalogueModel({
    this.productId,
    required this.image,
    required this.productName,
    required this.price,
    this.duration
  });

  Map<String, dynamic> toMap() {
    return {
      ProductCatalogueConst.productId: productId,
      ProductCatalogueConst.image: image,
      ProductCatalogueConst.productName: productName,
      ProductCatalogueConst.price: price,
      ProductCatalogueConst.duration: duration
    };
  }

  factory ProductCatalogueModel.fromMap(Map<String, dynamic> json) => ProductCatalogueModel(
    productId: json[ProductCatalogueConst.productId],
    image: json[ProductCatalogueConst.image], 
    productName: json[ProductCatalogueConst.productName], 
    price: json[ProductCatalogueConst.price],
    duration: json[ProductCatalogueConst.duration]);
}