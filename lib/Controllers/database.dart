import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twisted_twine_workshopppe/Models/Const/database_name_const.dart';
import 'package:twisted_twine_workshopppe/Models/Const/pattern_library_const.dart';


import '../Models/Const/history_const.dart';
import '../Models/Const/idea_const.dart';

import '../Models/Const/product_catalogue_const.dart';
import '../Models/Const/todo_const.dart';
import '../Models/Const/expense_used_const.dart';
import '../Models/Const/fabrics_const.dart';
import '../Models/Const/fabrics_used_const.dart';
import '../Models/Const/income_used_const.dart';
import '../Models/Const/infographics_charts_const.dart';
import '../Models/Const/rows_const.dart';
import '../Models/Const/brand_const.dart';
import '../Models/Const/crochet_hook_const.dart';

import '../Models/Const/craft_type_const.dart';
import '../Models/Const/crochet_hook_used_const.dart';
import '../Models/Const/crochet_thread_const.dart';
import '../Models/Const/crochet_thread_used_const.dart';
import '../Models/Const/expense_const.dart';
import '../Models/Const/knitting_needle_const.dart';
import '../Models/Const/knitting_needle_type_const.dart';
import '../Models/Const/knitting_needle_used_const.dart';
import '../Models/Const/task_const.dart';
import '../Models/Const/other_fibres_const.dart';
import '../Models/Const/other_fibres_used_const.dart';
import '../Models/Const/income_const.dart';
import '../Models/Const/sellers_const.dart';
import '../Models/Const/timer_const.dart';
import '../Models/Const/tools_const.dart';
import '../Models/Const/tools_used_const.dart';
import '../Models/Const/trimmings_const.dart';
import '../Models/Const/trimmings_type_const.dart';
import '../Models/Const/trimmings_used_const.dart';
import '../Models/Const/yarn_const.dart';
import '../Models/Const/yarn_used_const.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE ${CraftTypeConst.tableName}(
    ${CraftTypeConst.craftTypeNumber} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ${CraftTypeConst.craftTypeName} TEXT
    )""");

    await database.execute("""CREATE TABLE ${KnittingNeedleTypeConst.tableName}(
    ${KnittingNeedleTypeConst.needleTypeID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ${KnittingNeedleTypeConst.needleTypeName} TEXT
    )""");

    await database.execute("""CREATE TABLE ${TrimmingsTypeConst.tableName}(
    ${TrimmingsTypeConst.trimmingsId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ${TrimmingsTypeConst.trimmingsType} TEXT
    )""");

    //---TaskS TABLE---//
    await database.execute("""CREATE TABLE ${TaskConst.tableName}(
      ${TaskConst.taskNumber} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${TaskConst.taskName} TEXT,
      ${TaskConst.image} BLOB,
      ${TaskConst.craftType} TEXT,
      ${TaskConst.dateStarted} TEXT,
      ${TaskConst.dateCompleted} TEXT,
      ${TaskConst.customer} TEXT,
      ${TaskConst.status} TEXT,
      ${TaskConst.description} TEXT,
      ${TaskConst.depositMade} INTEGER,
      ${TaskConst.taskType} TEXT
      )""");

    await database.execute("""CREATE TABLE ${YarnConst.tableName}(
      ${YarnConst.yarnNumber} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${YarnConst.yarnColor} TEXT,
      ${YarnConst.image} BLOB,
      ${YarnConst.brand} TEXT,
      ${YarnConst.material} TEXT,
      ${YarnConst.size} TEXT,
      ${YarnConst.availableWeight} REAL,
      ${YarnConst.pricePerGram} REAL,
      ${YarnConst.reccHookNeedle} TEXT,
      ${YarnConst.cost} REAL
    )""");

    await database.execute("""CREATE TABLE ${CrochetThreadConst.tableName}(
      ${CrochetThreadConst.crochetThreadid} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${CrochetThreadConst.crochetThreadColor} TEXT,
      ${CrochetThreadConst.image} BLOB,
      ${CrochetThreadConst.brand} TEXT,
      ${CrochetThreadConst.material} TEXT,
      ${CrochetThreadConst.size} TEXT,
      ${CrochetThreadConst.availableWeight} REAL,
      ${CrochetThreadConst.pricePerGram} REAL,
      ${CrochetThreadConst.reccHookNeedle} TEXT,
      ${CrochetThreadConst.cost} REAL
    )""");

    await database.execute("""CREATE TABLE ${KnittingNeedleConst.tableName}(
      ${KnittingNeedleConst.knittingNeedleId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${KnittingNeedleConst.image} BLOB,
      ${KnittingNeedleConst.knittingNeedleSize} TEXT,
      ${KnittingNeedleConst.knittingNeedleType} TEXT
     )""");

    await database.execute("""CREATE TABLE ${CrochetHookConst.tableName} (
      ${CrochetHookConst.crochetHookId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${CrochetHookConst.image} BLOB,
      ${CrochetHookConst.crochetHookSize} TEXT
    )""");

    await database.execute("""CREATE TABLE ${OtherFibresConst.tableName} (
      ${OtherFibresConst.fibreId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${OtherFibresConst.image} BLOB,
      ${OtherFibresConst.fibreName} TEXT,
      ${OtherFibresConst.amount} REAL,
      ${OtherFibresConst.description} TEXT
    )""");

    await database.execute("""CREATE TABLE ${FabricConst.tableName} (
      ${FabricConst.fabricId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${FabricConst.image} BLOB,
      ${FabricConst.fabricName} TEXT,
      ${FabricConst.description} TEXT
    )""");

    await database.execute("""CREATE TABLE ${TrimmingsConst.tableName} (
      ${TrimmingsConst.trimmingsId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${TrimmingsConst.image} BLOB,
      ${TrimmingsConst.trimmingsName} TEXT,
      ${TrimmingsConst.amount} INTEGER
    )""");

    await database.execute("""CREATE TABLE ${ToolsConst.tableName} (
      ${ToolsConst.toolsId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${ToolsConst.toolName} TEXT,
      ${ToolsConst.image} BLOB
    )""");

    await database.execute("""CREATE TABLE ${BrandConst.tableName} (
      ${BrandConst.brandId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${BrandConst.brandName} TEXT,
      ${BrandConst.type} TEXT,
      ${BrandConst.rating} REAL
    )""");

    await database.execute("""CREATE TABLE ${SellersConst.tableName} (
      ${SellersConst.sellerId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${SellersConst.sellersName} TEXT,
      ${SellersConst.rating} REAL,
      ${SellersConst.description} TEXT
    )""");

    await database
        .execute("""CREATE TABLE ${InfographicsChartsConst.tableName} (
      ${InfographicsChartsConst.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${InfographicsChartsConst.image} BLOB
    )""");

    await database.execute("""CREATE TABLE ${ExpenseConst.tableName} (
      ${ExpenseConst.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${ExpenseConst.expenseDescription} TEXT,
      ${ExpenseConst.paidTo} TEXT,
      ${ExpenseConst.date} TEXT,
      ${ExpenseConst.expenseType} TEXT,
      ${ExpenseConst.amount} REAL,
      ${ExpenseConst.taskName} TEXT,
      ${ExpenseConst.receiptImage} BLOB
    )""");

    await database.execute("""CREATE TABLE ${IncomeConst.tableName} (
      ${IncomeConst.incomeId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${IncomeConst.incomeDescription} TEXT,
      ${IncomeConst.date} TEXT,
      ${IncomeConst.incomeType} TEXT,
      ${IncomeConst.amount} REAL,
      ${IncomeConst.disbursedFrom} TEXT,
      ${IncomeConst.taskName} TEXT,
      ${IncomeConst.receiptImage} BLOB
    )""");

    await database.execute("""CREATE TABLE ${ProductCatalogueConst.tableName} (
      ${ProductCatalogueConst.productId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${ProductCatalogueConst.productName} TEXT,
      ${ProductCatalogueConst.image} TEXT,
      ${ProductCatalogueConst.price} REAL,
      ${ProductCatalogueConst.duration} INTEGER
    )""");

    await database.execute("""CREATE TABLE ${CrochetThreadUsedConst.tableName}(
      ${CrochetThreadUsedConst.crochetThreadUsedid} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${CrochetThreadUsedConst.taskNumber} INTEGER,
      ${CrochetThreadUsedConst.crochetThreadnumber} INTEGER,
      ${CrochetThreadUsedConst.amountUsed} REAL,
      FOREIGN KEY (${CrochetThreadUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE,
      FOREIGN KEY (${CrochetThreadUsedConst.crochetThreadnumber}) REFERENCES ${CrochetThreadConst.tableName} (${CrochetThreadConst.crochetThreadid}) ON UPDATE NO ACTION ON DELETE CASCADE 
    )""");

    await database.execute("""CREATE TABLE ${KnittingNeedleUsedConst.tableName}(
      ${KnittingNeedleUsedConst.knittingNeedleUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${KnittingNeedleUsedConst.taskNumber} INTEGER,
      ${KnittingNeedleUsedConst.knittingNeedleId} INTEGER,
      FOREIGN KEY (${KnittingNeedleUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE,
      FOREIGN KEY (${KnittingNeedleUsedConst.knittingNeedleId}) REFERENCES ${KnittingNeedleConst.tableName} (${KnittingNeedleConst.knittingNeedleId}) ON UPDATE NO ACTION ON DELETE CASCADE 

    )""");

    await database.execute("""CREATE TABLE ${YarnUsedConst.tableName}(
      ${YarnUsedConst.yarnUsedNumber} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${YarnUsedConst.taskNumber} INTEGER,
      ${YarnUsedConst.yarnNumber} INTEGER NOT NULL,
      ${YarnUsedConst.amountUsed} REAL,
      FOREIGN KEY (${YarnUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE,
      FOREIGN KEY (${YarnUsedConst.yarnNumber}) REFERENCES ${YarnConst.tableName} (${YarnConst.yarnNumber}) ON UPDATE NO ACTION ON DELETE CASCADE 
    )""");

    await database.execute("""CREATE TABLE ${CrochetHookUsedConst.tableName}(
      ${CrochetHookUsedConst.crochetHookUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${CrochetHookUsedConst.taskNumber} INTEGER,
      ${CrochetHookUsedConst.crochetHookId} INTEGER NOT NULL,
      FOREIGN KEY (${CrochetHookUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE,
      FOREIGN KEY (${CrochetHookUsedConst.crochetHookId}) REFERENCES ${CrochetHookConst.tableName} (${CrochetHookConst.crochetHookId}) ON UPDATE NO ACTION ON DELETE CASCADE 
    )""");

    await database.execute("""CREATE TABLE ${OtherFibresUsedConst.tableName}(
      ${OtherFibresUsedConst.otherFibresUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${OtherFibresUsedConst.taskNumber} INTEGER,
      ${OtherFibresUsedConst.otherFibresId} INTEGER NOT NULL,
      ${OtherFibresUsedConst.amount} REAL,
      FOREIGN KEY (${OtherFibresUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE,
      FOREIGN KEY (${OtherFibresUsedConst.otherFibresId}) REFERENCES ${OtherFibresConst.tableName} (${OtherFibresConst.fibreId}) ON UPDATE NO ACTION ON DELETE CASCADE 
    )""");

    await database.execute("""CREATE TABLE ${TrimmingsUsedConst.tableName}(
      ${TrimmingsUsedConst.trimmingsUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${TrimmingsUsedConst.taskNumber} INTEGER,
      ${TrimmingsUsedConst.trimmingId} INTEGER NOT NULL,
      ${TrimmingsUsedConst.amountUsed} INTEGER, 
      FOREIGN KEY (${TrimmingsUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE,
      FOREIGN KEY (${TrimmingsUsedConst.trimmingId}) REFERENCES ${TrimmingsConst.tableName} (${TrimmingsConst.trimmingsId}) ON UPDATE NO ACTION ON DELETE CASCADE 
    )""");

    await database.execute("""CREATE TABLE ${ToolsUsedConst.tableName}(
      ${ToolsUsedConst.toolUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${ToolsUsedConst.toolId} INTEGER,
      ${ToolsUsedConst.taskNumber} INTEGER NOT NULL,
      FOREIGN KEY (${ToolsUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE,
      FOREIGN KEY (${ToolsUsedConst.toolId}) REFERENCES ${ToolsConst.tableName} (${ToolsConst.toolsId}) ON UPDATE NO ACTION ON DELETE CASCADE 
    )""");

    await database.execute("""CREATE TABLE ${RowsConst.tableName} (
      ${RowsConst.rowId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${RowsConst.rowCount} INTEGER,
      ${RowsConst.taskNumber} INTEGER,
      FOREIGN KEY (${RowsConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE
    )""");

    await database.execute("""CREATE TABLE ${FabricsUsedConst.tableName} (
      ${FabricsUsedConst.fabricsUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${FabricsUsedConst.fabricsId} INTEGER,
      ${FabricsUsedConst.taskNumber} INTEGER,
      FOREIGN KEY (${FabricsUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE
    )""");

    await database.execute("""CREATE TABLE ${TimerConst.tableName} (
      ${TimerConst.timeSlotId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${TimerConst.taskNumber} INTEGER,
      ${TimerConst.commissionName} TEXT,
      ${TimerConst.startDateTime} TEXT,
      ${TimerConst.endDateTime} TEXT,
      ${TimerConst.amountTime}  INTEGER,
      ${TimerConst.description} TEXT,
      FOREIGN KEY (${TimerConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE
    )""");

    await database.execute("""CREATE TABLE ${ExpenseUsedConst.tableName} (
      ${ExpenseUsedConst.expenseUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${ExpenseUsedConst.expenseId} INTEGER,
      ${ExpenseUsedConst.expenseCost} REAL,
      ${ExpenseUsedConst.taskNumber} INTEGER,
      FOREIGN KEY (${ExpenseUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE
    )""");

    await database.execute("""CREATE TABLE ${IncomeUsedConst.tableName} (
      ${IncomeUsedConst.incomeUsedId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${IncomeUsedConst.incomeId} INTEGER,
      ${IncomeUsedConst.taskNumber} INTEGER,
      ${IncomeUsedConst.amount} REAL,
      FOREIGN KEY (${IncomeUsedConst.taskNumber}) REFERENCES ${TaskConst.tableName} (${TaskConst.taskNumber}) ON UPDATE NO ACTION ON DELETE CASCADE
    )""");

    await database.execute("""CREATE TABLE ${IdeaConst.tableName} (
      ${IdeaConst.recordId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${IdeaConst.image} TEXT,
      ${IdeaConst.ideaName} TEXT,
      ${IdeaConst.description} TEXT
      
    )""");

    await database.execute("""CREATE TABLE ${TodoConst.tableName} (
      ${TodoConst.todoId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${TodoConst.todo} TEXT,
      ${TodoConst.isComplete} INTEGER
    )""");

    await database.execute("""CREATE TABLE ${HistoryConst.tableName} (
      ${HistoryConst.historyId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${HistoryConst.name} TEXT,
      ${HistoryConst.completionStatus} INTEGER,
      ${HistoryConst.craftType} TEXT,
      ${HistoryConst.monthYear} TEXT,
      ${HistoryConst.description} TEXT
      
    )""");

    await database.execute("""CREATE TABLE ${PatternLibraryConst.tableName} (
      ${PatternLibraryConst.patternId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${PatternLibraryConst.patternName} TEXT,
      ${PatternLibraryConst.patternType} TEXT,
      ${PatternLibraryConst.patternLink} TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('${DatabaseName.databaseName}.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    }, onConfigure: _onconfigure);
  }

  static Future _onconfigure(db) async {
    await db.execute('pragma foreign_keys = on');
  }

  static Future<String> getDBPath() async {
    return join(await sql.getDatabasesPath(), '${DatabaseName.databaseName}.db');
  }

  



  //Here's some raw code to possibly derive a solution from
//   import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// void main() {
// runApp(const MyApp());
// }
// class MyApp extends StatelessWidget {
// const MyApp({Key? key}) : super(key: key);
// @override
// Widget build(BuildContext context) {
// return const MaterialApp(
// home: ReadCsvFile(),
// );
// }
// }
// class ReadCsvFile extends StatefulWidget {
// const ReadCsvFile({Key? key}) : super(key: key);
// @override
// _ReadCsvFileState createState() => _ReadCsvFileState();
// }
// class _ReadCsvFileState extends State<readcsvfile> {
// List<list<dynamic>> _data = [];
// @override
// void initState() {
// super.initState();
// _loadCSV();
// }
// void _loadCSV() async {
// final rawData = await rootBundle.loadString("assets/test.csv");
// List<list<dynamic>> listData = const CsvToListConverter().convert(rawData);
// setState(() {
// _data = listData;
// });
// }
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
// title: const Text("read csv file"),
// ),
// body: ListView.builder(
// itemCount: _data.length,
// itemBuilder: (_, index) {
// return Card(
// margin: const EdgeInsets.all(3),
// color: Colors.white,
// child: ListTile(
// leading: Text(_data[index][0].toString()),
// title: Text(_data[index][1]),
// trailing: Text(_data[index][2].toString()),
// ),
// );
// },
// ));
// }
// }
// </list<dynamic></list<dynamic></readcsvfile>


}
