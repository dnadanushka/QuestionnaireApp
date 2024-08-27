import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:newapp/models/questionnaire.dart';
import 'package:newapp/models/user_response.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../controllers/report_controller.dart';

class ReportScreen extends StatefulWidget {
  Questionnaire quiz;
  List<UserResponse> responseList;
  ReportScreen({required this.quiz, required this.responseList});
  @override
  _ReportScreenState createState() => _ReportScreenState();
}



class _ReportScreenState extends State<ReportScreen> {
  List<String> analyticalData = [];
  List<String> analyticalKeys = ['Question Count', 'Response Count'];
  @override
  void initState() {
    _generateData();
    super.initState();
  }

  void _generateData() {
    analyticalData.add(widget.quiz.questions?.length.toString() ?? '0');
    analyticalData.add(widget.responseList.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Report')),
        body:
            //_report == null
            Expanded(
          child: PdfPreview(
            allowPrinting: true,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            build: (format) => _generatePdf(format),
          ),
        ));
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.all(0),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.max,
            children: [
           
              pw.Padding(
                padding: pw.EdgeInsets.all(30),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text(
                        widget.quiz.name,style: pw.TextStyle(fontSize: 30)),
                        pw.Text(
                        'Analytical Report',style: pw.TextStyle(fontSize: 25)),
                        pw.SizedBox(height: 40),
                      pw.Center(child:
                         pw.ListView.builder(
                        itemBuilder: (context, index) {
                          return pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(analyticalKeys[index]),
                                pw.SizedBox(
                                    width: 190,
                                    child: pw.Text(
                                        analyticalData[index]))
                              ]);
                        },
                        itemCount: 2,
                      ),
                      ),
                      pw.SizedBox(height: 40),
                     pw.Text(
                        'Questions',style: pw.TextStyle(fontSize: 25)),
                  pw.Center(child:
                         pw.ListView.builder(
                        itemBuilder: (context, index) {
                          return pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(widget.quiz.questions?[index].text ?? ''),
                                
                              ]);
                        },
                        itemCount: widget.quiz.questions?.length ?? 0,
                      ),
                      ),
                  
                    ]),
              ),
          
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
  

}
