

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Courier {

  final String id;
  final String name;
  final String surname;
  final String phone;
  final String adress;
  final String iban;
  final int balance;

  Courier({@required required this.id, required this.name, required this.surname, required this.phone,  required this.adress, required this.iban, required this.balance});


  factory Courier.firebasedenUret(User courier) {
    return Courier(
      id: courier.uid,
      name: courier.displayName!,
      surname: "",
      phone: courier.phoneNumber!,
      adress: "",
      iban: "",
      balance: 0,
    );
  }


  factory Courier.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc;
    return Courier(
      id : doc.id,
      name: docData['name'],
      surname: docData['surname'],
      phone: docData['phone'],
      adress: docData['adress'],
      iban: docData['iban'],
      balance: docData['balance'],
    );
  }


}
