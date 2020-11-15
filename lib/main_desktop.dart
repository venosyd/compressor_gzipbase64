///
/// venosyd © 2016-2020 sergio lisan <sels@venosyd.com>
///
library compressor.imagem;

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:clipboard/clipboard.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';

///
void main() {
  runApp(
    MaterialApp(
      title: 'Compressor de Imagens',
      debugShowCheckedModeBanner: false,
      routes: {'/': (_) => const CompressorApp()},
      initialRoute: '/',
    ),
  );
}

///
///
///
class CompressorApp extends StatefulWidget {
  ///
  const CompressorApp();

  @override
  _CompressorAppState createState() => _CompressorAppState();
}

///
class _CompressorAppState extends State<CompressorApp> {
  ///
  String compressed = '';

  ///
  Uint8List bytes;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              //
              Container(
                margin: const EdgeInsets.all(8),
                child: const Text(
                  'CONVERSOR PNG/JPG PARA GZIPPED BASE64',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              //
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: const Text(
                  'CLIQUE NO TEXTO PARA COPIAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              //
              Expanded(
                child: Row(
                  children: [
                    //
                    SizedBox(
                      width: 256,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //
                          if (bytes != null)
                            Expanded(
                              child: Center(
                                child: Image.memory(bytes, width: 256),
                              ),
                            ),
                          //
                          Container(
                            width: 196,
                            height: 48,
                            margin: const EdgeInsets.only(top: 32),
                            child: FlatButton(
                              onPressed: _upload,
                              color: const Color(0xFF64B5F6),
                              child: const Text(
                                'SUBIR A IMAGEM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Column(
                          children: [
                            //
                            if (compressed.isNotEmpty)
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  child: Material(
                                    color: const Color(0xFFFAFAFA),
                                    child: InkWell(
                                      onTap: _copy,
                                      child: Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Center(
                                          child: Text(
                                            compressed,
                                            style: const TextStyle(
                                              color: Color(0xFF777777),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  ///
  Future<void> _upload() async {
    final picker = await FilePickerCross.importFromStorage(
      type: FileTypeCross.image,
    );

    final gzip = GZipEncoder();

    setState(() {
      bytes = picker.toUint8List();
      compressed = base64.encode(gzip.encode(bytes));
    });
  }

  ///
  void _copy() {
    if (compressed.isNotEmpty)
      FlutterClipboard.copy(compressed).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 300,
            content: const Text('Copiado !', textAlign: TextAlign.center),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
  }
}
