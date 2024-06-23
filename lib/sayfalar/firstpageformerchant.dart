

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yazici_kurye/modeller/courier.dart';
import 'package:yazici_kurye/modeller/merchant.dart';
import 'package:yazici_kurye/modeller/order.dart';
import 'package:yazici_kurye/services/authservice.dart';

class FPMerchant extends StatefulWidget {
  const FPMerchant({ Key? key , required this.merchantId, required this.userId}) : super(key: key);

  final Merchant merchantId;
  final String userId;

  @override
  _FPMerchantState createState() => _FPMerchantState();
}

final descriptionController = TextEditingController();

class _FPMerchantState extends State<FPMerchant> {

  static String? _merchantId;
  @override
  void initState() {
    _merchantId = widget.merchantId.id;
    print(_merchantId);
    super.initState();
  }
int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final currentTime = Timestamp.fromMicrosecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    String _merhcantName = widget.merchantId.title;
    final screens = [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(_merhcantName,style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(child: Text("Sign Out",style: TextStyle(color: Colors.white),),onPressed: (){AuthService().signOut();},)
        ],),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
              title: Text("Sipariş Oluştur"),
              content: Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Açıklama',
                    ),
                  ),
                ),
              actions: [
                TextButton(child:Text("İptal"), onPressed: () =>Navigator.of(context).pop(),),
                TextButton(
                  onPressed: (){
                    FirebaseFirestore.instance.collection("Orders").add({
                      'order_status' : 0,
                      'merchant_id' : widget.merchantId.id,
                      'courier_id' : "",
                      'courier_delivery_status' : 0,
                      'merchant_delivery_status' : 0,
                      'description' : descriptionController.text,
                      'timedout' : 0,
                      'createdate' : FieldValue.serverTimestamp(),
                    });
                    Navigator.of(context).pop();
                    descriptionController.clear();
                  },
                  child: Text("Sipariş Oluştur"))
              ],
              );
              }
              );
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Orders").where("merchant_id",isEqualTo: _merchantId).snapshots(),
          builder: (context, snapshot){
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              List<Order> orderList = snapshot.data!.docs.map((e) =>
                Order(id: e.id, orderStatus: e['order_status'], merchantId: e['merchant_id'], courierId: e['courier_id'], courierDeliveryStatus: e['courier_delivery_status'], merchantDeliveryStatus: e['merchant_delivery_status'], description: e['description'],timedout: e['timedout'],createdate: e['createdate'] ?? currentTime)).toList();
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  return orderList[index].orderStatus == 0 ?
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection("Merchants").doc(orderList[index].merchantId).get(),
                      builder: (context, fsnapshot) {
                        if (fsnapshot.hasData) {
                          var dukkan = fsnapshot.data;
                          _merhcantName = dukkan?["title"] ?? "Hoşgeliniz";
                          print(snapshot.data);
                          if(fsnapshot.hasData){
                            return ListTile(
                              title: Text(orderList[index].description),
                              trailing: ElevatedButton(
                                child: Text("İşi iptal et"),
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("Emin misin?"),
                                        actions: [
                                          ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("İptal")),
                                          ElevatedButton(onPressed: (){FirebaseFirestore.instance.collection("Orders").doc(orderList[index].id).delete();Navigator.of(context).pop();}, child: Text("Onayla"))
                                        ],
                                      );
                                    }
                                    );
                                   }),
                              subtitle:  Text(dukkan?["title"] ?? "Yükleniyor..."),
                            );
                          }else{
                            return CircularProgressIndicator();
                          }

                        }
                        else{
                          return Center(child: CircularProgressIndicator(),);
                        }
                      }
                    ):SizedBox();
                }
              );
            }
          }
          ),
      ),
        Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Orders").where("merchant_id", isEqualTo: _merchantId).snapshots(),
            builder: (context,snapshot){
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              else{
              List<Order> orderList = snapshot.data!.docs.map((e) =>
                Order(id: e.id, orderStatus: e['order_status'], merchantId: e['merchant_id'], courierId: e['courier_id'], courierDeliveryStatus: e['courier_delivery_status'], merchantDeliveryStatus: e['merchant_delivery_status'], description: e['description'],timedout: e['timedout'], createdate: e['createdate'])).toList();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                      return orderList[index].orderStatus == 1 ?
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            width: MediaQuery.of(context).size.width * 90 / 100,
                            height: MediaQuery.of(context).size.height * 10 / 100,
                            decoration: BoxDecoration(
                              color: orderList[index].courierDeliveryStatus == 0 ? Colors.yellow: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2,2),
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 0.5,

                              )]
                            ),
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                 scrollDirection: Axis.horizontal,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(orderList[index].description),
                                        SizedBox(width: MediaQuery.of(context).size.width * 20 / 100,),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: MediaQuery.of(context).size.height * 35 / 1000,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      orderList[index].courierDeliveryStatus == 1 && orderList[index].merchantDeliveryStatus == 0 ? ElevatedButton(
                                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                                          onPressed: (){
                                            showDialog(
                                              context: context,
                                              builder: (context){
                                                return AlertDialog(
                                                  title: Text("Emin misin?"),
                                                  actions: [
                                                    ElevatedButton(child: Text("İptal"), onPressed: (){Navigator.of(context).pop();},),
                                                    ElevatedButton(
                                                      child: Text("Onayla"),
                                                      onPressed: (){
                                                        FirebaseFirestore.instance.collection("Orders").doc(orderList[index].id).update({"merchant_delivery_status" : 1});
                                                        ;},),
                                                  ],
                                                );
                                              });
                                           },
                                          child: Text("Teslim onay")): SizedBox(),
                                          SizedBox(width: 20.0,),
                                          Container(
                                          ),
                                      orderList[index].courierDeliveryStatus == 0 ? Icon(Icons.incomplete_circle): Icon(Icons.check),

                                    ],
                                  ))
                              ],
                            ),
                          ),
                        ):SizedBox();}
                    );
                  }

              }

            ),
        ),
    ];
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 131, 255, 173),
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          onTap: (index) => setState(() => currentIndex = index),
          type: BottomNavigationBarType.shifting,
          showSelectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Siparişler',
              backgroundColor: Colors.amber,
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'Kuryedeki Siparişlerim',
              backgroundColor: Colors.teal,
              ),
          ]
          ),
    );
  }
}
