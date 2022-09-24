import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Signature Demo'),
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
  final SignatureController controller=SignatureController(
      penStrokeWidth: 2,
      exportBackgroundColor: Colors.white,
      penColor: Colors.black);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [

          Signature(
            height: 300,
            backgroundColor: Colors.white,
            controller: controller,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: (){
                      setState(() async {
                        if(controller.isNotEmpty){
                          final Uint8List? data= await controller.toPngBytes();
                          if(data!=null){
                            final base64=base64Encode(data);
                            showDialog(context: context,
                              builder:(context)=> AlertDialog(
                                content: Image.memory(data),
                                actions: [

                                  IconButton(
                                      alignment: Alignment.centerRight,
                                      onPressed: () async {
                                        final Uint8List bytes=base64Decode(base64);
                                        await WcFlutterShare.share(
                                          sharePopupTitle: 'Share',
                                          subject: 'This is Singnature',
                                          fileName: 'signature.png',
                                          mimeType: 'image/png',
                                          bytesOfFile:bytes.buffer.asInt8List(),
                                        );

                                      },
                                      icon: Icon(Icons.share,size: 40,)
                                  ),
                                  IconButton(onPressed: (){
                                    Navigator.pop(context,true);
                                  },
                                      icon: Icon(Icons.close,size: 40,)
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      });
                    },
                    icon: Icon(Icons.check,color: Colors.green,size: 40,)
                ),
                IconButton(
                    alignment: Alignment.centerRight,
                    onPressed: (){
                      setState(() {
                        controller.clear();
                      });
                    },
                    icon: Icon(Icons.clear,color: Colors.red,size: 40)
                ),


              ]
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
