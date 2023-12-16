import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/Model.dart';
import '../data/Model.dart';
import '../main.dart';
class ajouter_matriel extends StatefulWidget {
  Materiel? product;
   ajouter_matriel({Key? key, required this.product}) : super(key: key);

  @override
  State<ajouter_matriel> createState() => _ajouter_matrielState();
}

class _ajouter_matrielState extends State<ajouter_matriel> {
  Materiel produit = Materiel('', '', '', null);
  bool addclicked = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _num_serieController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref("materiel");
  DatabaseReference refA = FirebaseDatabase.instance.ref("affectation");
  DatabaseReference refE = FirebaseDatabase.instance.ref("employees");
  List<Employee> employees = [];

  Employee selectedEmp = Employee("", "", "", "");
  DateTime selectedDate = DateTime.now();
  final dateTextCtlr = TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  final GlobalKey _renderObjectKey = new GlobalKey();

  Future<String> _saveQR(String prodCode) async {
    try {
      RenderRepaintBoundary boundary =
      _renderObjectKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();

      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      //final file = await new File('/<localpath>/qrImg_$prodCode.png').create();

      //await file.writeAsBytes(pngBytes!);

      await ImageGallerySaver.saveImage(pngBytes!,name: 'qrImg_$prodCode.png');
      return 'Image telechargé';
    } catch (e) {
      return e.toString();
    }

  }
  getEmployees()
  {
    refE.once().then((value) {
      Map data = value.snapshot.value as Map;
      setState(() {
        employees = [];
      });
      data.forEach((key, value) {
        setState(() {
          employees.add(Employee.fromMap(value, key));
        });
      });
      setState(() {
        selectedEmp = employees.first;
      });
    });
  }

  ajouter_affectation() async {
    final key = ref.push().key;
    await refA.child(key!).set({
      "dateAffectation": selectedDate.toString(),
      "num_serie": produit.num_serie,
      "employee": selectedEmp.matricule,
    });
  }
  supprimer() async {
    print("stp1");
    print("${produit.nom} ");
    print("${produit.num_serie} ");
    print("${produit.image} ");
    var prodKey = widget.product?.num_serie;
    print("prodkey  $prodKey");
    ref.child(prodKey!).remove();
    print("stp3");
    Navigator.pop(context);
  }
  ajouter_matriel() async {
    if(addclicked)
      {
        print("QDDCLICKED");
        ajouter_affectation();
      }
    print("stp1");
    //final key = ref.push().key;
    //print("stp2 $key");

    print("${produit.nom} ");
    print("${produit.num_serie} ");
    print("${produit.image} ");
    await ref.child(produit.num_serie).set({
      "nom": produit.nom,
      "num_serie": produit.num_serie,
      "image": produit.image!="" ? produit.image :  "https://static.vecteezy.com/system/resources/thumbnails/000/619/445/small/codingisometric-2.jpg"
    });
    print("stp3");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
       dateTextCtlr.text = DateFormat("yyyy-MM-dd").format(picked);
      });
    }
    }


    @override
    void initState() {
      super.initState();
      getEmployees();
      produit = widget.product ?? produit;

      if(widget.product!= null && widget.product?.affectation!=null)
      {
        var currD=DateFormat("yyyy-MM-dd").format(widget.product?.affectation?.dateAffectation ?? selectedDate);
        dateTextCtlr.text= DateFormat("yyyy-MM-dd").format(widget.product?.affectation?.dateAffectation ?? selectedDate);
        print("Date aff: $selectedDate");
        selectedEmp=widget.product?.affectation?.employee ?? selectedEmp;
        addclicked=true;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.product == null ? "Ajouter Materiels" : "Modifier Materiels"
              ),),
        body:
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      if (widget.product != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Image.network(widget.product?.image ?? ""),
                      ),
                      TextFormField(
                        validator: (String? value) {
                          if (value==null || value=="") {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            produit.nom = value;
                            print(produit.nom);
                          });
                        },
                        initialValue: widget.product?.nom,
                        decoration: const InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue, width: 5))),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        validator: (String? value) {
                          if (value==null || value=="") {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            produit.num_serie = value;
                          });
                        },
                        initialValue: widget.product?.num_serie,
                        decoration: const InputDecoration(
                            labelText: 'Num_serie',
                            border: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue, width: 5))),
                      ),
                      SizedBox(height: 20,),
                      if (widget.product == null)
                      TextFormField(
                        validator: (String? value) {
                          if (value==null || value=="") {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            produit.image = value;
                          });
                        },
                        initialValue: widget.product?.image,
                        decoration: const InputDecoration(
                            labelText: 'Image',
                            border: OutlineInputBorder(),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue, width: 5))),
                      ),
                      SizedBox(height: 10,),
                      SizedBox( width: MediaQuery
                          .of(context)
                          .size
                          .width, child:
                      addclicked == true ? Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,

                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ListTile(
                                title: DropdownButton<Employee>(

                                  // Initial Valuef
                                  value: selectedEmp,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: employees.map((Employee item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text("${item.nom} - ${item.entreprise}"),

                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (Employee? newValue) {
                                    setState(() {
                                      selectedEmp = newValue!;
                                    });
                                  },
                                ),
                                trailing: IconButton(onPressed: (){
                                  setState(() {
                                    addclicked = false;
                                    selectedEmp=Employee("", "", "", "");
                                    dateTextCtlr.text="";
                                    produit.affectation=null;
                                  });
                                  }
                                , icon: Icon(Icons.close,color: Colors.red,) ),
                              ),
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              enabled: false,
                              controller: dateTextCtlr,
                              onChanged: (value) {
                                setState(() {
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Date d'affectation",
                                  border: OutlineInputBorder(),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 5))),
                            ),
                            trailing:  IconButton(onPressed: ()=>_selectDate(context), icon: Icon(Icons.calendar_today,color: Colors.blue,size: 30,)),
                          ),
                        ],
                      ) : ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            addclicked = true;
                          });
                        }, icon: Icon(Icons.add), label: Text("Employee"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),

                      )

                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        width: MediaQuery
                              .of(context)
                              .size
                              .width,
                        child: Visibility(
                          visible: widget.product==null ? false : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _saveQR(produit.num_serie).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                                  });
                                  setState(() {
                                    addclicked = true;
                                  });
                                }, icon: Icon(Icons.file_download), label: Text("Telecharger QR"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                ),

                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  supprimer();
                                }, icon: Icon(Icons.delete), label: Text("Supprimer"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),

                              ),
                            ],
                          ),
                        )
                      ),

                      SizedBox(height: 10,),
                      widget.product==null? SizedBox()
                          : SizedBox(
                            child: RepaintBoundary(
                        key: _renderObjectKey,
                        child: Container(
                            color: Colors.white,
                            child: QrImage(
                              data: produit.num_serie,
                              version: QrVersions.auto,
                              size: 250.0,
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size(60, 60),
                              ),
                            ),
                        ),
                      ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child:
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width,
                      child: ElevatedButton(
                        onPressed: () {
                          var valid = _formKey.currentState;
                          print((valid==null).toString());
                          if(valid != null){ajouter_matriel();Navigator.pop(context);}}, child: Text("Sauvegarder"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                      ),
                    ))
            ),

          ],
        ),
      );
    }
  }