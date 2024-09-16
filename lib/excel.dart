import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data'; // ByteData を含むパッケージをインポート

class ExcelDropdown extends StatefulWidget {
  final Function(List<String>) onItemsLoaded; // データを渡すための関数

  ExcelDropdown({required this.onItemsLoaded});

  @override
  _ExcelDropdownState createState() => _ExcelDropdownState();
}

class _ExcelDropdownState extends State<ExcelDropdown> {
  @override
  void initState() {
    super.initState();
    loadExcelData();
  }

  Future<void> loadExcelData() async {
  List<String> dropdownItems = [];
  try {
    // エクセルファイルのパス（アセット）
    final ByteData data = await rootBundle.load('assets/施設マスター.xlsx');
    final Uint8List bytes = data.buffer.asUint8List(); // Uint8List へ変換
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;
      for (var row in sheet.rows) {
        if (row.length > 1 && row[1] != null) {
          dropdownItems.add(row[1]!.value.toString());
        }
      }
    }

    // データがすべて読み込まれた後にまとめて出力
    // print("読み込まれたデータ: $dropdownItems");

    widget.onItemsLoaded(dropdownItems);
  } catch (e) {
    print('エクセルファイルの読み込み中にエラーが発生しました: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    // 空のウィジェットを返す（データ読み込み専用）
    return Container();
  }
}


