/*import 'package:flutter/material.dart';
import 'package:yazici_kurye/guidance.dart';
import 'package:yazici_kurye/guidancem.dart';
import 'package:yazici_kurye/sayfalar/signpage.dart';

class WhoIsLogin extends StatelessWidget {
  const WhoIsLogin({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: Text("Kurye Girişi"),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Guidance()));
                  },),
                ElevatedButton(
                  child: Text("İş Yeri Girişi"),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Guidancem()));
                  },),
              ],
            ),
            Padding(
                  padding: const EdgeInsets.only(top:100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text(
                          'Kurye Kayıt Et',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignPage(hangisi: 1)));
                        },
                      ),
                          ElevatedButton(
                            child: Text(
                              'İşyeri Kayıt Et',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignPage(hangisi: 0)));
                            },
                          )
                    ],
                  ),
                )
          ],
        ),
      ),
    );
  }
}*/
