import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool? _success;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signInWithEmailAndPassword() async {
    print("step 1");
    final User? user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;
    print("step 2");
    if (user != null) {print("step 3");
      setState(() {
        _success = true;
      });
    } else {
      setState(() {print("step 4");
        _success = false;
      });
    }
  }

  goHome()
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed In')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const home()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Container(
            width: screenWidth ,
            height: screenHeight,
            padding: const EdgeInsets.only(top: 70,bottom: 20,left: 20,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text("K.H.Z",style: TextStyle(fontSize: 30,color: Colors.white), textAlign: TextAlign.center,),

                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                                    child: TextFormField(
                                      controller: _emailController,
                                        validator: (String? value) {
                                          if (value==null || value=="") {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Email',
                                        ))))),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            alignment: const Alignment(0, 0),
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 15, right: 15, top: 5),
                                      child: TextFormField(
                                        controller: _passwordController,
                                          validator: (String? value) {
                                            if (value==null || value=="") {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'Your password',
                                          )))),
                              Positioned(
                                  right: 15,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        // _controller.clear();
                                      },
                                      child: Text('SHOW')))
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.black,
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false
                                  // otherwise.
                                  var valid = _formKey.currentState;
                                  if (valid!=null && valid.validate()) {
                                    print("not null");
                                    // If the form is valid, display a Snackbar.
                                    _signInWithEmailAndPassword();

                                    print("ssss  $_success");
                                    if(_success!=null){
                                      if(_success==true){
                                        goHome();
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('erreur')));

                                      }
                                    }

                                  }
                                  else{
                                    print("not valid");
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                /*

                Column(
                  children: [

                    TextFormField(
                      decoration: const InputDecoration(
                        n: Icon(Icons.email),
                        labelText: 'Email',
                        border: InputBorder.none

                      ),
                    ),
                    SizedBox(height: 10,),

                    TextFormField(),

                  ],
                )
                 */
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(onPressed: goHome, icon: Icon(Icons.door_back_door, color: Colors.red,))
          )
        ],
      ),
    );
  }
}
