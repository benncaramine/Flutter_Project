import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  bool fav = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth ,
        height: screenHeight,
        color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap:() {setState(() {
                    fav = !fav;
                  });},
                  child: Icon(Icons.favorite,size: 40,color: fav==false?Colors.grey : Colors.red ,)),

              SizedBox(
                width: 200,
                height: 200,
                child: Image.network("https://upload.wikimedia.org/wikipedia/fr/thumb/0/0a/RajaClubAthleticCasablanca.svg/1200px-RajaClubAthleticCasablanca.svg.png"),
              )
            ],
          )),
    );
  }
}

