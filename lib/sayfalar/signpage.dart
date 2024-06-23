import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yazici_kurye/main.dart';
import 'package:yazici_kurye/services/authservice.dart';

class SignPage extends StatelessWidget {
  final int hangisi;

  const SignPage({ Key? key , required this.hangisi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: hangisi == 1 ? forCourier(context) : forMerchant(context),
      ),
    );
  }

  Widget forCourier(BuildContext context){
    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    final TextEditingController mailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController adressController = TextEditingController();
    final TextEditingController ibanController = TextEditingController();

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'İsim',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: surnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Soyisim',
                    ),
                  ),
                ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: mailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mail',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifre',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Telefon',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: adressController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Adres',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: ibanController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Iban',
                    ),
                  ),
                ),
              ElevatedButton(
                child: Text("Kaydet"),
                onPressed: (){
                  AuthService().courierSignUp(mailController.text, passwordController.text, nameController.text, surnameController.text,phoneController.text,adressController.text,ibanController.text, 0);
                  Navigator.of(context).pop();
                },
                )
          ],
        ),
      );
  }

   Widget forMerchant(BuildContext context){
    final TextEditingController titleController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController adressController = TextEditingController();
    final TextEditingController menagerController = TextEditingController();
    final TextEditingController menagerPhoneController = TextEditingController();
    final TextEditingController createdateController = TextEditingController();
    final TextEditingController mailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: mailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mail',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifre',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: titleController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şirket Adı',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Telefon',
                    ),
                  ),
                ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: adressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Adres',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: menagerController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Yetkili adı',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: menagerPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Yetkili telefon no',
                    ),
                  ),
                ),
            Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: createdateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kaydetme Tarihi',
                    ),
                  ),
                ),
              ElevatedButton(
                child: Text("Kaydet"),
                onPressed: (){
                  AuthService().merchantSignUp(mailController.text, passwordController.text, titleController.text,phoneController.text,adressController.text,menagerController.text,menagerPhoneController.text,createdateController.text);
                  Navigator.of(context).pop();
                },
                )
          ],
        ),
      );
  }
}
