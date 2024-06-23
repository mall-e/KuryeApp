/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yazici_kurye/main.dart';
import 'package:yazici_kurye/sayfalar/firstpageforcourier.dart';
import 'package:yazici_kurye/sayfalar/signpage.dart';
import 'package:yazici_kurye/services/authservice.dart';
import 'main.dart';
import 'package:provider/provider.dart';

import 'modeller/courier.dart';

class Guidancem extends StatefulWidget {
  const Guidancem({ Key? key }) : super(key: key);

  @override
  State<Guidancem> createState() => _GuidancemState();
}

class _GuidancemState extends State<Guidancem> {
  @override
  Widget build(BuildContext context) {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String courierId = snapshot.data!.uid;
            print(snapshot.data);
              return FirstPageForCourier(courierId: courierId);
          }
          else{
            return LoginPage();
          }
        }
      );
  }
}

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hoşgeldiniz'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'YazKurye',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Giriş Yap'),
                        onPressed: () {
                          print(nameController.text);
                          print(passwordController.text);
                          AuthService().signIn(nameController.text, passwordController.text);
                        },
                      )),
                    ],
                  ),
                ),
              ],
            )));
  }
}*/
