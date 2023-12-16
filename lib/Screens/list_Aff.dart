import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrcode_reader/data/Model.dart';

import 'ajouter_employee.dart';
class list_Aff extends StatefulWidget {
  const list_Aff({Key? key}) : super(key: key);

  @override
  State<list_Aff> createState() => _list_AffState();
}

class _list_AffState extends State<list_Aff> {
  List<Affectation> affectation = [] ;
  DatabaseReference refA = FirebaseDatabase.instance.ref("affectation");
  DatabaseReference refE = FirebaseDatabase.instance.ref("employees");
  DatabaseReference refM = FirebaseDatabase.instance.ref("materiel");
  int cnt=0;

  getAff()
  {
    refA.once().then((value) {
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
          cnt++;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique"),
        actions: [
          /*
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ajouter_matriel(product: null)),
            );
          }, icon: Icon(Icons.add_box_outlined)),
          */



        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:20.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: affectation.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  margin: EdgeInsets.all(15),
                  child: Card(
                    elevation: 7,
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.computer, color: Colors.deepPurpleAccent,),
                          Text(affectation[index].num_serie),
                        ],
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_right_alt),
                          Text(DateFormat("yyyy-MM-dd").format(affectation[index].dateAffectation)),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: Colors.blueAccent,),
                          Text(affectation[index].employee.nom),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },),
        )
      ),
    );
  }
}
