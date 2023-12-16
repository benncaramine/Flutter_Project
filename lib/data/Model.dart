class Materiel{
  String nom ;
  String num_serie ;
  String image;
  Affectation? affectation;

  Materiel(this.nom, this.num_serie, this.image, this.affectation,);

  factory Materiel.fromMap(Map<dynamic,dynamic> data, String key, Affectation? affectation)
  {
    return Materiel(
    data["nom"] as String,
    data["num_serie"] as String,
    data["image"] as String,
    affectation
    );
  }
}

class Employee{
  String nom ;
  String matricule ;
  String entreprise ;
  String departement ;

  Employee(this.nom, this.matricule, this.entreprise, this.departement);

  factory Employee.fromMap(Map<dynamic,dynamic> data, String key )
{
return Employee(
data["nom"] as String,
key ,
data["entreprise"] as String,
  data["departement"] as String,
);
}
}


class Affectation{
  String key ;
  DateTime dateAffectation ;
  String num_serie ;
  Employee employee;

  Affectation(this.key,this.dateAffectation, this.num_serie, this.employee);
  factory Affectation.fromMap(Map<dynamic,dynamic> data, String key, Employee employee )
  {
    return Affectation(
      key ,
      DateTime.parse(data["dateAffectation"]),
      data["num_serie"] as String,
      employee,
    );
  }
}