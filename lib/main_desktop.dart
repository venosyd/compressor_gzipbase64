///
/// venosyd © 2016-2020 sergio lisan <sels@venosyd.com>
///
library compressor.imagem;

import 'dart:convert';

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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  children: [
                    //
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: const Text(
                        'CONVERSOR PNG/JPG PARA GZIP BASE64',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    //
                    Container(
                      width: 196,
                      height: 48,
                      margin: const EdgeInsets.symmetric(vertical: 32),
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
                    //
                    if (compressed.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(32),
                        child: const Text(
                          'CLIQUE NO TEXTO PARA COPIAR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              )
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
    final data = picker.toUint8List();

    setState(() => compressed = base64.encode(gzip.encode(data)));
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
