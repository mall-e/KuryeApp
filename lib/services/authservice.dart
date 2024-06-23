import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yazici_kurye/modeller/courier.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  merchantSignUp(String email, String password, String title, String phone,String adress, String menager, String menagerphone, String createdate)async{
   try {
      User? user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      FirebaseFirestore.instance.collection("Merchants").doc(user!.uid).set({
                    "title" : title,
                    "phone" : phone,
                    "adress" : adress,
                    "menager" : menager,
                    "menager_phone" : menagerphone,
                    "createdate" : createdate,
                    "type" : "merchant",
                  });
   } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  courierSignUp(String email, String password, String name, String surname,String phone, String adress, String iban, int balance)async{
   try {
      User? user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      FirebaseFirestore.instance.collection("Couriers").doc(user!.uid).set({
                    "name" : name,
                    "surname" : surname,
                    "phone" : phone,
                    "adress" : adress,
                    "iban" : iban,
                    "balance" : balance,
                  });
   } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
  signIn(String email, String password)async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut()async{
    await _firebaseAuth.signOut();
  }
}
