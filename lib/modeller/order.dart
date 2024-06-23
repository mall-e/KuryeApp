import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Order {

  final String id;
  final int orderStatus;
  final String merchantId;
  final String courierId;
  final int courierDeliveryStatus;
  final int merchantDeliveryStatus;
  final String description;
  final int timedout;
  final Timestamp createdate;

  Order({@required required this.id, required this.orderStatus, required this.merchantId, required this.courierId,  required this.courierDeliveryStatus, required this.merchantDeliveryStatus, required this.description,required this.timedout, required this.createdate});

  factory Order.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc;
    return Order(
      id : doc.id,
      orderStatus: docData['order_status'],
      merchantId: docData['merchant_id'],
      courierId: docData['courier_id'],
      courierDeliveryStatus: docData['courier_delivery_status'],
      merchantDeliveryStatus: docData['merchant_delivery_status'],
      description: docData['description'],
      timedout: docData['timedout'],
      createdate: docData['createdate']
    );
  }


}
