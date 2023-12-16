import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qrcode_reader/Screens/ajouter_matriel.dart';
import 'package:qrcode_reader/Screens/list_employe.dart';
import 'package:qrcode_reader/Screens/login.dart';

import '../data/Model.dart';
import 'QR_Code.dart';
import 'ajouter_employee.dart';
import 'list_Aff.dart';
import 'package:collection/collection.dart';


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home>{
  String name = "hhh";
  List<Materiel> materiels = [] ;
  void handleClick(String value) {
    switch (value) {
      case 'Ajouter Materiel':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ajouter_matriel(product: null)),
        );
        break;
      case 'Ajouter Employée':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ajouter_employee(emp_edit: null)),
        );
        break;
    }
  }
  List<Affectation> affectation = [] ;
  DatabaseReference refA = FirebaseDatabase.instance.ref("affectation");
  DatabaseReference refE = FirebaseDatabase.instance.ref("employees");
  DatabaseReference ref = FirebaseDatabase.instance.ref("materiel");
  Stream getData() => ref.onValue ;

  getAff()
  {
    refA.onValue.listen((value) {
      Map data = value.snapshot.value as Map;
      data.forEach((key, value) async {
        print("data : ${value["employee"]}");
        await refE.child(value["employee"].toString()).once().then((valueE) {

          print("here emp");
          Map dataE = valueE.snapshot.value as Map;
          Employee employee = Employee.fromMap(dataE,value["employee"]);
          setState(() {
            affectation.add(Affectation.fromMap(value, key, employee));
          });

          print("aff : ${affectation.first.employee.nom}");
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAff();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Materiels"),
        actions: [
         /*
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ajouter_matriel(product: null)),
            );
          }, icon: Icon(Icons.add_box_outlined)),
          */
          PopupMenuButton<String>(
            onSelected: handleClick,
            icon: Icon(Icons.add_box_outlined, color: Colors.white //Color(0xffb6b2df),
            ),
            itemBuilder: (BuildContext context) {
              return {'Ajouter Materiel', 'Ajouter Employée',}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),

          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ScanScreen(products: materiels,)),
            );
          }, icon: Icon(Icons.qr_code_scanner))
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top:80, right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(onPressed: ()=>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const home()),
              ),
                  icon: Icon(Icons.computer),
                  label: Text("Materiel")),
              TextButton.icon(onPressed: ()=>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const list_employe()),
              ),
                  icon: Icon(Icons.person),
                  label: Text("Employees")),

              TextButton.icon(
                  onPressed: ()=>Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const list_Aff()),
                  ),
                  icon: Icon(Icons.history),
                  label: Text("Historique")
              ),

              TextButton.icon(onPressed: ()=>Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const login()),
              ),
                  icon: Icon(Icons.logout),
                  label: Text("Deconnecter")),

            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
                  stream: ref.onValue,

                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data!=null && snapshot.data.snapshot!=null && snapshot.data.snapshot.value != null) {
                      Map data = snapshot.data.snapshot.value as Map;
                      materiels = [];
                      data.forEach((key, value) {
                        Affectation? affectationN = affectation.firstWhereOrNull((Affectation el) => el.num_serie==value["num_serie"].toString());
                        materiels.add(Materiel.fromMap(value, key, affectationN));
                      });
                      return GridView.builder(
                        gridDelegate: const
                        SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: materiels.length,
                        itemBuilder: (BuildContext ctx, index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ajouter_matriel(product: materiels[index])),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(materiels[index].image))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 80),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 80,
                                      margin: const EdgeInsets.only(right: 5, bottom: 10, left: 5),
                                      //padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text(materiels[index].nom, overflow: TextOverflow.ellipsis,)),
                                    ),
                                    Container(
                                      height: 60,
                                      margin: const EdgeInsets.only(right: 5, bottom: 10, left: 5),
                                      //padding: const EdgeInsets.all(10),

                                      child: Container(
                                          alignment: Alignment.center,
                                          //child: Icon(Icons.how_to_reg, color: Colors.greenAccent,)
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    else if (snapshot.hasError) {
                      return SizedBox();
                    } else {
                      return CircularProgressIndicator();
                    }
                  })),
    )
    );
  }

}
