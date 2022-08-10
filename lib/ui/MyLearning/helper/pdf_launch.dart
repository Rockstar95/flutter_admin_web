import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfCourseLaunch extends StatefulWidget {
  final String url;
  final File? myFile;
  final Uint8List pdfBytes;
  final String finalDownloadedFilePath;
  final bool isOffline;
  final DummyMyCatelogResponseTable2 myLearningModel;

  PdfCourseLaunch({
    this.url = "",
    this.myFile,
    this.finalDownloadedFilePath = "",
    required this.pdfBytes,
    this.isOffline = false,
    required this.myLearningModel,
  });

  @override
  State<PdfCourseLaunch> createState() => _PdfCourseLaunchState();
}

class _PdfCourseLaunchState extends State<PdfCourseLaunch> {
  final _key = UniqueKey();
  bool isLoading = false;

  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  int _actualPageNumber = 1, _allPagesCount = 0;
  bool isSampleDoc = true;
  late PdfController _pdfController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isOffline) {
      print(widget.finalDownloadedFilePath);
      _pdfController = PdfController(
          document: PdfDocument.openFile(widget.finalDownloadedFilePath));
    } else {
      print(widget.url);
      _pdfController =
          PdfController(document: PdfDocument.openData(widget.pdfBytes));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
          elevation: 0,
          title: Text(
            widget.myLearningModel.name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Container(
                  child: Expanded(
                    child: PdfView(
                      documentLoader:
                          Center(child: CircularProgressIndicator()),
                      pageLoader: Center(child: CircularProgressIndicator()),
                      controller: _pdfController,
                      onDocumentLoaded: (document) {
                        setState(() {
                          _actualPageNumber = 1;
                          _allPagesCount = document.pagesCount;
                        });
                      },
                      onPageChanged: (page) {
                        setState(() {
                          _actualPageNumber = page;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            //isLoading ? Center( child: CircularProgressIndicator()) : Container(),
          ],
        ));
  }
}
