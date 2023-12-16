import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/data/Model.dart';

import 'ajouter_employee.dart';
class list_employe extends StatefulWidget {
  const list_employe({Key? key}) : super(key: key);

  @override
  State<list_employe> createState() => _list_employeState();
}

class _list_employeState extends State<list_employe> {
  List<Employee> employees = [] ;
  DatabaseReference ref = FirebaseDatabase.instance.ref("employees");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employées"),
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
        child: StreamBuilder(
            stream: ref.onValue,

            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data.snapshot.value != null) {
                Map data = snapshot.data.snapshot.value as Map;
                employees = [];
                data.forEach((key, value) {

                  print("data test ${value["nom"]}");
                  employees.add(Employee.fromMap(value, key ));
                  print("data test 2 ${employees[0].nom}");
                });
                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ajouter_employee(emp_edit: employees[index])),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        margin: EdgeInsets.all(15),
                        child: Card(
                          elevation: 7,
                          child: ListTile(
                            leading: Icon(Icons.person, color: Colors.blue, size: 35,),
                            trailing: Text(employees[index].matricule),
                            title: Text(employees[index].nom),
                            subtitle: Text(employees[index].entreprise + " - " + employees[index].departement),
                          ),
                        ),
                      ),
                    );
                  },);

              }
              else if (snapshot.hasError || snapshot.data==null || snapshot.data.snapshot.value == null) {
                return SizedBox();
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
