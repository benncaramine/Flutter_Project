import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:collection/collection.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrcode_reader/Screens/ajouter_matriel.dart';

import '../data/Model.dart';

class ScanScreen extends StatefulWidget {
  List<Materiel> products;
  ScanScreen({Key? key, required this.products}) : super(key: key);

  @override
  _ScanState createState() =>   _ScanState();
}
class _ScanState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool paused = false;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  /*

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                paused ? GestureDetector(
                  onTap: () async {
                    await controller?.resumeCamera();
                    setState(() => paused = false);
                  },
                  child: Center(
                    child: Icon(Icons.play_circle, color: Colors.black.withOpacity(0.7), size: 150,),
                  ),
                ) : SizedBox()
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: result == null ? Center(child: Text('Scan a code')) : Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    height: 10,
                    child: ListTile(
                        leading: (describeEnum(result!.format)=='qrcode' ? Icon(FontAwesomeIcons.qrcode) : Icon(FontAwesomeIcons.barcode)),
                        title: Text('${result!.code}', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.6), fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,),
                        trailing: ElevatedButton.icon(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ajouter_matriel(product: null)));
                          }, icon: Icon(Icons.add_box_outlined, color: Colors.white,),
                          label: Text('Ajouter'),
                        )
                    ),
                  ),
                ),
              )
          )

          /*
          Center(
              child: (result != null)
                  ? Text(
                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
           */
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    //var dir = controller.flipCamera();
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      goToProduct(scanData);
    });
  }
  Future<void> goToProduct(var scanData)
  async {
    await controller?.pauseCamera().then((value) async {
      print('ready!');
      String data = scanData.code;
      Materiel? product = widget.products.firstWhereOrNull((Materiel el) => data.contains(el.num_serie));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(product==null ? 'Aucun matériel trouvé' : 'Matériel trouvé')));
      if(product==null)
      {
        setState(() => paused = true);
      }
      else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ajouter_matriel(product: product)),
          ModalRoute.withName('/'),
        ).then((_) => controller?.resumeCamera());
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}
