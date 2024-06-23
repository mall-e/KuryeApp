import 'package:flutter/material.dart';

class Merchant{

  final String id;
  final String title;
  final String phone;
  final String adress;
  final String menager;
  final String menagerPhone;
  final String createdate;

  Merchant({@required required this.id, required this.title, required this.menager, required this.phone,  required this.adress, required this.menagerPhone,required this.createdate});
}
