import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:yazici_kurye/modeller/courier.dart';
import 'package:yazici_kurye/modeller/order.dart';
import 'package:yazici_kurye/services/authservice.dart';

class FirstPageForCourier extends StatefulWidget {
  final Courier courierId;
  const FirstPageForCourier({Key? key, required this.courierId})
      : super(key: key);

  @override
  _FirstPageForCourierState createState() => _FirstPageForCourierState();
}

class _FirstPageForCourierState extends State<FirstPageForCourier> {
  static late String _courierID;
  late int _courierBalance;
  @override
  void initState() {
    _courierID = widget.courierId.id;
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appbarColor = [
      Colors.amber,
      Colors.teal,
      Colors.indigo,
    ];

    final screens = [
      //Siparişler
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Couriers").doc(_courierID).snapshots(),
        builder: (context,bsnapshot){
          if (!bsnapshot.hasData) {
            return CircularProgressIndicator();
          }else{
            int courierBalance = bsnapshot.data!['balance'];
            return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("order_status", isEqualTo: 0)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Order> orderList = snapshot.data!.docs
                  .map((e) => Order(
                      id: e.id,
                      orderStatus: e['order_status'],
                      merchantId: e['merchant_id'],
                      courierId: e['courier_id'],
                      courierDeliveryStatus: e['courier_delivery_status'],
                      merchantDeliveryStatus: e['merchant_delivery_status'],
                      description: e['description'],
                      timedout: e['timedout'],
                      createdate: e['createdate']))
                  .toList();
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Orders")
                .where("order_status", isEqualTo: 1)
                .where("courier_id", isEqualTo: _courierID)
                .where("courier_delivery_status", isEqualTo: 0)
                .snapshots(),
                builder: (context, osnapshot) {
                  if (!osnapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  else
                  {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return orderList[index].orderStatus == 0
                            ? ListTile(
                                title: FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection("Merchants")
                                        .doc(orderList[index].merchantId)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var dukkan = snapshot.data;
                                        print(snapshot.data);
                                        return ListTile(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    backgroundColor: Color.fromARGB(
                                                        255, 255, 228, 130),
                                                    title:
                                                        Text("Sipariş Detayları"),
                                                    content: Container(
                                                      height: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          40 /
                                                          100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Açıklama:",
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(orderList[index]
                                                              .description),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15.0),
                                                            child: Text(
                                                              "Adres:",
                                                              style: TextStyle(
                                                                  fontSize: 20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(dukkan?["adress"] ??
                                                              "Yükleniyor..."),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        child: Text("Geri Dön"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        child: Text("İşi al"),
                                                        onPressed: () {
                                                          if (courierBalance <=
                                                              50) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Orders")
                                                                .doc(
                                                                    orderList[index]
                                                                        .id)
                                                                .update({
                                                              "order_status": 1,
                                                              "courier_id":
                                                                  _courierID,
                                                            });
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                                    context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  "Borcunuz 50₺'yi geçti. Ödeme yapmanız gerekiyor. İş alamazsınız."),
                                                            ));
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          tileColor: Colors.white,
                                          title: Text(orderList[index].description),
                                          subtitle: Text(
                                              dukkan?["title"] ?? "Yükleniyor..."),
                                          trailing: ElevatedButton(
                                            child: Text("İşi al"),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 255, 228, 130),
                                                      title:
                                                          Text("Sipariş Detayları"),
                                                      content: Container(
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                40 /
                                                                100,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Açıklama:",
                                                              style: TextStyle(
                                                                  fontSize: 20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(orderList[index]
                                                                .description),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15.0),
                                                              child: Text(
                                                                "Adres:",
                                                                style: TextStyle(
                                                                    fontSize: 20.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Text(dukkan?[
                                                                    "adress"] ??
                                                                "Yükleniyor..."),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          child: Text("Geri Dön"),
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          child: Text("İşi al"),
                                                          onPressed: () {
                                                            if (courierBalance >=
                                                                50) {
                                                               ScaffoldMessenger.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                    "Borcunuz 50₺'yi geçti. Ödeme yapmanız gerekiyor. İş alamazsınız."),
                                                              ));
                                                            }
                                                            else if (osnapshot.data!.docs.length >= 3) {
                                                              ScaffoldMessenger.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                    "Aktif 3 sipariş varken yeni sipariş alamazsınız!"),
                                                              ));
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "Orders")
                                                                  .doc(orderList[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                "order_status": 1,
                                                                "courier_id":
                                                                    _courierID,
                                                              });
                                                            }
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                              )
                            : SizedBox();
                      });
                  }

                }
              );
            }
          })
      ;
          }
        }
        ),
      // Aktif Siparişler

      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("courier_id", isEqualTo: _courierID)
              .orderBy("createdate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Order> orderList = snapshot.data!.docs
                  .map((e) => Order(
                      id: e.id,
                      orderStatus: e['order_status'],
                      merchantId: e['merchant_id'],
                      courierId: e['courier_id'],
                      courierDeliveryStatus: e['courier_delivery_status'],
                      merchantDeliveryStatus: e['merchant_delivery_status'],
                      description: e['description'],
                      timedout: e['timedout'],
                      createdate: e['createdate']))
                  .toList();
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection("Couriers").doc(_courierID).snapshots(),
                builder: (context, csnapshot) {
                  if (!csnapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  else{
                    var data = csnapshot.data;
                    Courier courier = Courier(id: data!.id,name: data["name"],surname: data["surname"], phone: data["phone"],adress: data["adress"],iban: data["iban"], balance: data["balance"]);
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (orderList[index].orderStatus == 1 &&
                            orderList[index].courierId == _courierID) {
                          return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("Merchants")
                                  .doc(orderList[index].merchantId)
                                  .get(),
                              builder: (context, fsnapshot) {
                                if (fsnapshot.hasData) {
                                  var dukkan = fsnapshot.data;
                                  print(fsnapshot.data);
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20.0),
                                      width: MediaQuery.of(context).size.width *
                                          90 /
                                          100,
                                      height: MediaQuery.of(context).size.height *
                                          10 /
                                          100,
                                      decoration: BoxDecoration(
                                          color: orderList[index]
                                                      .courierDeliveryStatus ==
                                                  1
                                              ? Colors.green
                                              : Colors.amberAccent,
                                          borderRadius: BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 2),
                                              color: Colors.grey,
                                              blurRadius: 5,
                                              spreadRadius: 0.5,
                                            )
                                          ]),
                                      child: Stack(
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      orderList[index].description,
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      dukkan?["title"] ??
                                                          "Yükleniyor...",
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.normal),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  3 /
                                                  100,
                                              right: 0,
                                              child: Row(
                                                children: [
                                                  orderList[index]
                                                              .courierDeliveryStatus ==
                                                          0
                                                      ? IconButton(
                                                          icon: Icon(Icons.check),
                                                          color: Colors.green,
                                                          onPressed: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Emin misin?"),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                          },
                                                                          child: Text(
                                                                              "İptal")),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            FirebaseFirestore
                                                                                .instance
                                                                                .collection("Orders")
                                                                                .doc(orderList[index].id)
                                                                                .update({
                                                                              "order_status":
                                                                                  1,
                                                                              "courier_delivery_status":
                                                                                  1,
                                                                            });
                                                                            FirebaseFirestore.instance.collection("Couriers").doc(_courierID).update({"balance" :  courier.balance + 2});
                                                                            FirebaseFirestore.instance.collection("Transactions").add({"amount" : 2, "courier_id" : courier.id, "createdate" : FieldValue.serverTimestamp()});
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                          },
                                                                          child: Text(
                                                                              "Teslim ettim"))
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                        )
                                                      : Icon(
                                                          Icons.check,
                                                          color: Colors.black,
                                                        ),
                                                  orderList[index]
                                                              .courierDeliveryStatus ==
                                                          0
                                                      ? IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Emin misin?"),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                          },
                                                                          child: Text(
                                                                              "Geri dön")),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            FirebaseFirestore
                                                                                .instance
                                                                                .collection("Orders")
                                                                                .doc(orderList[index].id)
                                                                                .update({
                                                                              "order_status":
                                                                                  0,
                                                                              "courier_id":
                                                                                  "",
                                                                            });
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                          },
                                                                          child: Text(
                                                                              "İşi iptal et"))
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ))
                                                      : SizedBox(),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                /*ListTile(
                            tileColor: orderList[index].courierDeliveryStatus == 1 ? Colors.green: Colors.white,
                             title: Text(orderList[index].description),
                             subtitle: Text(dukkan?["title"] ?? "Yükleniyor..."),
                             trailing: Row(
                               children: [
                                  orderList[index].courierDeliveryStatus == 0 ? IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.green,
                                  onPressed: (){
                                    FirebaseFirestore.instance.collection("Orders").doc(orderList[index].id).update({
                                      "order_status" : 1,
                                      "courier_delivery_status" : 1,
                                  });
                               },): Icon(Icons.check,color: Colors.black,),
                               IconButton(
                                 onPressed: (){
                                   FirebaseFirestore.instance.collection("Orders").doc(orderList[index].id).set({
                                     "order_status" : 0,
                                     "courier_id" : "",
                                   });
                                 },
                                 icon: Icon(Icons.disabled_by_default))
                               ],
                             )
                            );*/
                                else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              });
                        } else {
                          return SizedBox();
                        }
                      });

                  }}
              );
            }
          }),
      //Cüzdan
      Scaffold(
        backgroundColor: Colors.teal,
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Couriers").doc(_courierID).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
           else{
              var data = snapshot.data;
              Courier courier = Courier(id: data!.id,name: data["name"],surname: data["surname"], phone: data["phone"],adress: data["adress"],iban: data["iban"], balance: data["balance"]);
              return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 50 / 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.0))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(courier.name, style: TextStyle(fontSize: 70.0,fontWeight: FontWeight.bold),),
                      Text(courier.surname, style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                      SizedBox(height: MediaQuery.of(context).size.height * 10 / 100,),
                      Text("Telefon: "+ courier.phone, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.normal),),
                      Text("Adress: "+ courier.adress, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.normal),),
                      Text("Iban: "+ courier.iban, style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.normal),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 60 / 100,
                    height: MediaQuery.of(context).size.height * 15 / 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Borcunuz:", style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: MediaQuery.of(context).size.height * 1 / 100,),
                        Text(courier.balance.toString() + "₺", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  )
              ],
            );

            }
            }
        ),
      )
      ];

    return widget.courierId.id != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: appbarColor[currentIndex],
              title: Text(
                widget.courierId.name,
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    AuthService().signOut();
                  },
                )
              ],
            ),
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
                    label: 'Aktif Siparişlerim',
                    backgroundColor: Colors.teal,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.wallet),
                    label: 'Cüzdan',
                    backgroundColor: Colors.indigo,
                  ),
                ]),
          )
        : wrongLogin();
  }

  Widget wrongLogin() => Center(
        child: Text("Hatalı Giriş (Kurye Değilsiniz!)"),
      );
}
