import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess/models/mess.dart';

abstract class BaseStorage {
  Future<Mess> createMess({String userId});
  Stream<QuerySnapshot> getAllMess({int offset, int limit});
}

class Storage implements BaseStorage {
  final Firestore _db = Firestore.instance;

  Future<Mess> createMess({String userId}) async {
    Mess mess = Mess(userId: userId);

    final TransactionHandler createMessTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(_db.collection('mess').document());

      var dataMap = mess.toMap();

      await tx.set(ds.reference, dataMap);

      return dataMap;
    };

    await _db.runTransaction(createMessTransaction);

    return mess;
  }

  Stream<QuerySnapshot> getAllMess({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = _db.collection('mess').snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }
}
