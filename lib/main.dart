import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'excel.dart'; 
import 'pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ジーユー・ライフ 返品表',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 245, 230, 230)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '返品表'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String date;
  List<String> title = ['日 付\nDate', '施設名\nFacility Name', 'フロア名\nFloor name', '記入者\nentrant'];
  List<String> dropdownItems = [];
  String? selectedValue;
  final List<Map<String, dynamic>> _checkedMaps1 = [
    {'value': '上衣\njacket                   ', 'checked': false},
    {'value': '下衣\nLower clothing                   ', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedMaps2 = [
    {'value': '肌着上\nUnderwearTop', 'checked': false},
    {'value': '肌着下\nunderwear', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedMaps3 = [
    {'value': 'くつ下\nsocks                   ', 'checked': false},
    {'value': '小物\nAccessories', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedMaps4 = [
    {'value': '寝具類\nBedding', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedMapsf = [
    {'value': '名前未記入 衣類に直接フルネームで記入。\nName not written Full name\nwritten directly on clothing', 'checked': false},
    {'value': '名前が読み取れませんでした。\nName could not be read. Please retype it.', 'checked': false},
    {'value': '以下のことが発生しています\n洗ってもよろしいでしょうか？\nMay I wash the following?', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedRowRaps1 = [
    {'value': '破れ\ntear                   ', 'checked': false},
    {'value': 'ほつれ\nfrayed spot', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedRowRaps2 = [
    {'value': '縮み\nshrinkage        ', 'checked': false},
    {'value': '変色\nfading', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedRowRaps3 = [
    {'value': 'ボタンなし\nNo buttons', 'checked': false},
  ];
  final List<Map<String, dynamic>> _checkedMapsb = [
    {'value': '契約外品目・未契約\nItems not contracted/not contracted', 'checked': false},
    {'value': 'ドライ契約のないかたです。\nThis is the one without dry contract.', 'checked': false},
    {'value': 'バーコード貼り付けできない衣類です\nClothing to which barcodes cannot be attached', 'checked': false},
    {'value': '片足のため\nFor one leg', 'checked': false},
    {'value': 'ドライ品になります。縮む可能性はありますが、水洗い\n処理をしてもよろしいでしょうか？\nIt will be dry goods.\nIs it possible to wash it in cold water?', 'checked': false},
  ];

  final TextEditingController _controllerFacilityName = TextEditingController();
  final TextEditingController _controllerFloorName = TextEditingController();
  final TextEditingController _controllerEntrant = TextEditingController();
  final TextEditingController _controllerYourName = TextEditingController();
  final TextEditingController _controllerOther = TextEditingController();

  String _facilityName = '';
  String _floorName = '';
  String _entrant = '';
  String _yourName = '';
  String _other = '';
  List<String> _dropdownItems = [];
  String? _selectedItem;
  List<String> _allItems = []; // Excelデータ全体のリスト
  List<String> _filteredItems = []; // フィルタリングされたアイテム

  void _filterItems(String input) {
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.contains(input)) // 入力された文字列を含むアイテムだけを抽出
        . toList();
   });
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('MM/dd');
    date = outputFormat.format(now);
    // Excelデータを読み込む処理
    // loadExcelData();
  }

  @override
  void dispose() {
    _controllerFacilityName.dispose();
    _controllerFloorName.dispose();
    _controllerEntrant.dispose();
    super.dispose();
  }

  void _handleItemsLoaded(List<String> items) {
    setState(() {
      _dropdownItems = items;
      // _selectedItem をリストの最初のアイテムに設定する
      if (items.isNotEmpty) {
        _selectedItem = items.first;
      } else {
        _selectedItem = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> titleWidgets = title.map((text) => Expanded(
      child: Column(
        children: [
          _buildTextWithBorderText(context, text),
          if (text == '日 付\nDate')
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(screenWidth * 0.003),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0))
              ),
              child: Text(
                date,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
         if (text == '施設名\nFacility Name')
          Container(
            child: Column(
              children: [
                if (_dropdownItems.isNotEmpty)
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty(); // 空の入力があった場合
                      }
                      // 入力文字列と部分一致するアイテムを返す
                      return _dropdownItems.where((String item) {
                        return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selectedItem) {
                      setState(() {
                        // Autocompleteで選択されたアイテムを変更する
                        _selectedItem = selectedItem;
                      });
                    },
                    fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: '施設名を入力してください', // ヒントテキスト
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),


          if (text == 'フロア名\nFloor name')
          Container(
            child: TextFormField(
              controller: _controllerFloorName,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
          ),
            
          if (text == '記入者\nentrant')
          Container(
            child: TextFormField(
              controller: _controllerEntrant,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
          ),
            
        ],
      ),
    )).toList();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1),
              ),
              child: Text(
                '返却連絡票 (バーコード用)\nReturn Contact Form (for barcode)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                  right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              child: Row(
                children: titleWidgets,
              ),
            ),
            ExcelDropdown(
              onItemsLoaded: _handleItemsLoaded,
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    controller: _controllerYourName,
                    decoration: InputDecoration(
                      labelText: 'お名前  様 Your Name',
                      labelStyle: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '品物 goods',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: Row(
                    children: _checkedMaps1
                      .map((q) => Flexible(
                        child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          q['value'],
                          style: TextStyle(fontSize: 25),
                          ),
                          value: q['checked'],
                          onChanged: (bool? checkedValue) {
                          setState(() {
                            q['checked'] = checkedValue;
                          });
                        },
                      ))
                      )
                    .toList()
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15,),
                  width: double.infinity,
                  child: Row(
                    children: _checkedMaps2
                      .map((q) => Flexible(
                        child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          q['value'],
                          style: TextStyle(fontSize: 25),
                          ),
                          value: q['checked'],
                          onChanged: (bool? checkedValue) {
                          setState(() {
                            q['checked'] = checkedValue;
                          });
                        },
                      ))
                      )
                    .toList()
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: Row(
                    children: _checkedMaps3
                      .map((q) => Flexible(
                        child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          q['value'],
                          style: TextStyle(fontSize: 25),
                          ),
                          value: q['checked'],
                          onChanged: (bool? checkedValue) {
                          setState(() {
                            q['checked'] = checkedValue;
                          });
                        },
                      ))
                      )
                    .toList()
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: Row(
                    children: _checkedMaps4
                      .map((q) => Flexible(
                        child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          q['value'],
                          style: TextStyle(fontSize: 25),
                          ),
                          value: q['checked'],
                          onChanged: (bool? checkedValue) {
                          setState(() {
                            q['checked'] = checkedValue;
                          });
                        },
                      ))
                      )
                    .toList()
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: screenWidth * 0.01, right: screenWidth * 0.01),
                  child: TextFormField(
                    controller: _controllerOther,
                    decoration: InputDecoration(
                      labelText: 'その他 Other',
                      labelStyle: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '返却理由\nReason for return',
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                // チェックボックスリストを表示
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: Column(
                    children: _checkedMapsf
                      .map((e) => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          e['value'],
                          style: TextStyle(fontSize: 25),
                        ),
                        value: e['checked'],
                        onChanged: (bool? checkedValue) {
                          setState(() {
                            e['checked'] = checkedValue;
                          });
                        },
                      ))
                    .toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: Row(
                    children: _checkedRowRaps1
                      .map((a) => Flexible(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            a['value'],
                            style: TextStyle(fontSize: 25),
                          ),
                          value: a['checked'],
                          onChanged: (bool? checkedValue) {
                            setState(() {
                              a['checked'] = checkedValue;
                            });
                          },
                        ),
                      ))
                      .toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: Row(
                    children: _checkedRowRaps2
                      .map((a) => Flexible(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            a['value'],
                            style: TextStyle(fontSize: 25),
                          ),
                          value: a['checked'],
                          onChanged: (bool? checkedValue) {
                            setState(() {
                              a['checked'] = checkedValue;
                            });
                          },
                        ),
                      ))
                      .toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: double.infinity,
                  child: Row(
                    children: _checkedRowRaps3
                      .map((a) => Flexible(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            a['value'],
                            style: TextStyle(fontSize: 25),
                          ),
                          value: a['checked'],
                          onChanged: (bool? checkedValue) {
                            setState(() {
                              a['checked'] = checkedValue;
                            });
                          },
                        ),
                      ))
                      .toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                      right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    )
                  ),
                  padding: EdgeInsets.only(top: 0 ,left: 15, right: 15, bottom: 0),
                  width: double.infinity,
                  child: Column(
                    children: _checkedMapsb
                      .map((b) => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          b['value'],
                          style: TextStyle(fontSize: 25),
                        ),
                        value: b['checked'],
                        onChanged: (bool? checkedValue) {
                          setState(() {
                            b['checked'] = checkedValue;
                          });
                        }
                      ))
                    .toList()
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, left: screenWidth * 0.02, right: screenWidth * 0.02, bottom: 0),
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: const Color.fromARGB(255, 0, 0, 0))
                    )
                  )
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton(
                onPressed: () async {
                  _saveData();
                  await generatePdf(
                    date: date,
                    facilityName: _facilityName,
                    floorName: _floorName,
                    entrant: _entrant,
                    yourName: _yourName,
                    other: _other,
                    checkedMaps1: _checkedMaps1,
                    checkedMaps2: _checkedMaps2,
                    checkedMaps3: _checkedMaps3,
                    checkedMaps4: _checkedMaps4,
                    checkedMapsf: _checkedMapsf,
                    checkedRowRaps1: _checkedRowRaps1,
                    checkedRowRaps2: _checkedRowRaps2,
                    checkedRowRaps3: _checkedRowRaps3,
                    checkedMapsb: _checkedMapsb,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(110, 100),
                ),
                child: Text(
                  '印刷\nPrinting',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWithBorderText(BuildContext context, String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(screenWidth * 0.003),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  void _saveData() async {
    // _selectedItem が null でない場合はその値を使用し、null の場合はデフォルト値を使用する
    String facilityName = _selectedItem ?? '未選択'; 
    _facilityName = facilityName;
    _floorName = _controllerFloorName.text;
    _entrant =  _controllerEntrant.text;
    _yourName = _controllerYourName.text;
    _other = _controllerOther.text;

    
    // print('施設名: $_facilityName\nフロア名: $_floorName\n記入者: $_entrant\nお名前: $_yourName\nその他: $_other');
    print('施設名: $_facilityName\nフロア名: $_floorName\n記入者: $_entrant\nお名前: $_yourName\nその他: $_other');
  }
}

