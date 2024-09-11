import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';


Future<void> generatePdf({
  required String date,
  required String facilityName,
  required String floorName,
  required String entrant,
  required String yourName,
  required String other,
  required List<Map<String, dynamic>> checkedMaps,
  required List<Map<String, dynamic>> checkedMapsf,
  required List<Map<String, dynamic>> checkedRowRaps,
  required List<Map<String, dynamic>> checkedMapsb,
}) async {
  final pdf = pw.Document();
  // フォントの読み込み
  final jpFont = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansJP-VariableFont_wght.ttf'));

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.copyWith(marginTop: 0.05, marginLeft: 0.005, marginRight: 10, marginBottom: 0.005), // A4サイズで全体のマージンを設定
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 210, // 幅を全体に設定
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
              ),
              child: pw.Text(
                '返品連絡票 (バーコード用)\nReturn Contact Form (for barcode)',
                style: pw.TextStyle(fontSize: 13.5, fontWeight: pw.FontWeight.bold, font: jpFont),
              ),
            ),
            pw.Container(
              width: 215, // 幅を全体に設定
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text(
                    '日付\nDate\n$date',
                    style: pw.TextStyle(
                      font: jpFont,
                      fontSize: 8
                      )
                    ),
                  pw.Text(
                    '施設名\nFacility Name\n$facilityName',
                    style: pw.TextStyle(
                      font: jpFont,
                      fontSize: 8
                      ),
                    ),
                  pw.Text(
                    'フロア名\nFloor Name\n$floorName',
                    style: pw.TextStyle(
                      font: jpFont,
                      fontSize: 8
                    )
                    ),
                  pw.Text(
                    '記入者\nEntrant\n$entrant',
                    style: pw.TextStyle(
                      font: jpFont,
                      fontSize: 8
                    )
                  )
                  
                ],
              ),
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0))
                )
                ),
              child: pw.Row(
              children: [
                pw.Text(
                  'お名前  様\nYour Name\n$yourName',
                  style: pw.TextStyle(
                    font: jpFont,
                    fontSize: 10

                  )
                  ),
              ],
            ),
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0))
                )
                ),
              // padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                '品物',
                style: pw.TextStyle(
                  font: jpFont,
                  fontSize: 10
                )
                )
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0))
                )
                ),
              padding: const pw.EdgeInsets.all(5),
              child: pw.Wrap(
                alignment: pw.WrapAlignment.spaceEvenly,
                children: <pw.Widget>[
                  _buildCheckboxList(checkedMaps, jpFont)
                ]
              )
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0))
                )
                ),
              child: pw.Text(
                'その他(Other)\n$other',
                style: pw.TextStyle(
                  font: jpFont,
                  fontSize: 10
                )
                )
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0))
                )
                ),
              // padding: const pw.EdgeInsets.all(5),
              child: _buildCheckboxList(checkedMapsf, jpFont),
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0))
                )
                ),
              // padding: const pw.EdgeInsets.all(0),
              child: _buildCheckboxListRow(checkedRowRaps, jpFont),
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  right: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0)),
                  bottom: pw.BorderSide(color: PdfColorCmyk.fromRgb(0, 0, 0))
                )
                ),
              padding: pw.EdgeInsets.only(top: 10.0,left: 0.0,right: 10.0,bottom: 10.0),
              child: pw.Wrap(
                children: <pw.Widget>[

                  _buildCheckboxList(checkedMapsb, jpFont)
                ]
              ),
            ),
          ],
        );
      },
    ),
  );

  // PDFのプレビューと印刷
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

pw.Widget _buildCheckboxList(List<Map<String, dynamic>> items, pw.Font fontSymbols) {
  return pw.Container(
    padding: pw.EdgeInsets.only(left: 5),
    width: 200,
    child: pw.Column(
      children: [
        pw.Column(
          children: items
              .map(
                (item) => pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  children: [
                    pw.Text(
                      item['checked'] ? '✔' : '□', // Unicode チェックボックス
                      style: pw.TextStyle(fontSize: 8, font: fontSymbols),
                    ),
                    // pw.SizedBox(width: 5),
                    pw.Text(item['value'], style: pw.TextStyle(fontSize: 10, font: fontSymbols)),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}
pw.Widget _buildCheckboxListRow(List<Map<String, dynamic>> items, pw.Font fontSymbols) {
  return pw.Row(
    children: items.map(
      (item) => pw.Row(
        mainAxisSize: pw.MainAxisSize.min, // 子要素の幅に合わせる
        children: [
          pw.Text(
            item['checked'] ? '✔' : '□', // Unicode チェックボックス
            style: pw.TextStyle(fontSize: 10, font: fontSymbols),
          ),
          pw.SizedBox(width: 5), // チェックボックスとラベルの間隔
          pw.Text(
            item['value'],
            style: pw.TextStyle(fontSize: 10, font: fontSymbols),
          ),
        ],
      ),
    ).toList(),
  );
}
