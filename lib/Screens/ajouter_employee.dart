import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/data/Model.dart';
class ajouter_employee extends StatefulWidget {
  Employee? emp_edit;
   ajouter_employee({Key? key, required this.emp_edit}) : super(key: key);

  @override
  State<ajouter_employee> createState() => _ajouter_employeeState();
}

class _ajouter_employeeState extends State<ajouter_employee> {
  Employee employee = Employee('', '', '', '');
  DatabaseReference ref = FirebaseDatabase.instance.ref("employees");
  supprimer() async {
    var prodKey = widget.emp_edit?.matricule;
    print("prodkey  $prodKey");
    ref.child(prodKey!).remove();
    print("stp3");
    Navigator.pop(context);
  }
  ajouter_matriel() async {
    await ref.child(employee.matricule).set({
      "nom": employee.nom,
      "entreprise": employee.entreprise,
      "departement": employee.departement
    });
    print("stp3");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employee = widget.emp_edit ?? employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter Employée"),),
      body:
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[

                TextFormField(
                  validator: (value) {
                    if(value == '')
                    {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      employee.nom = value;
                    });
                  },
                  initialValue: widget.emp_edit?.nom,
                  decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 5))),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (value) {
                    if(value == '')
                    {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      employee.matricule = value;
                    });
                  },
                  initialValue: widget.emp_edit?.matricule,
                  decoration: const InputDecoration(
                      labelText: 'Matricule',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 5))),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (value) {
                    if(value == '')
                    {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      employee.entreprise = value;
                    });
                  },
                  initialValue: widget.emp_edit?.entreprise,
                  decoration: const InputDecoration(
                      labelText: 'Entreprise',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 5))),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (value) {
                    if(value == '')
                    {
                      return 'Champ obligatoire';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      employee.departement = value;
                    });
                  },
                  initialValue: widget.emp_edit?.departement,
                  decoration: const InputDecoration(
                      labelText: 'Departement',
                      border: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 5))),
                ),
                Visibility(
                  visible: widget.emp_edit==null ? false : true,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      supprimer();
                    }, icon: Icon(Icons.delete), label: Text("Supprimer"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),

                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child:
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(width: MediaQuery.of(context).size.width, child: ElevatedButton(onPressed: (){ajouter_matriel();Navigator.pop(context);}, child: Text("envoyer"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                  )))
        ],
      ),
    );
  }
}
