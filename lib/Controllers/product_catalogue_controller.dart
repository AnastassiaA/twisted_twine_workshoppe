import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/product_catalogue_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/product_catalogue_model.dart';
import 'database.dart';

class ProductCatalogueController {
  static Future<int> createProduct(ProductCatalogueModel product) async {
    final db = await SQLHelper.db();

    final data = {
      ProductCatalogueConst.productName: product.productName,
      ProductCatalogueConst.image: product.image,
      ProductCatalogueConst.price: product.price,
      ProductCatalogueConst.duration: product.duration
    };

    final id = await db.insert(ProductCatalogueConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await SQLHelper.db();

    return db.query(ProductCatalogueConst.tableName,
        orderBy: ProductCatalogueConst.productId);
  }

  static Future<List<Map<String, dynamic>>> getOneProduct(int id) async {
    final db = await SQLHelper.db();

    return db.query(ProductCatalogueConst.tableName,
        where: "${ProductCatalogueConst.productId} = ?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateProduct(ProductCatalogueModel product) async {
    final db = await SQLHelper.db();

    final data = {
      ProductCatalogueConst.productName: product.productName,
      ProductCatalogueConst.image: product.image,
      ProductCatalogueConst.price: product.price,
      ProductCatalogueConst.duration: product.duration
    };

    final result = await db.update(ProductCatalogueConst.tableName, data,
        where: "${ProductCatalogueConst.productId} =?",
        whereArgs: [ProductCatalogueConst.productId]);

    return result;
  }

  static Future<void> deleteProduct(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(ProductCatalogueConst.tableName,
          where: "${ProductCatalogueConst.productId} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
