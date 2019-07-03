import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mess/models/mess.dart';
import 'package:mess/models/user.dart';

abstract class BaseStorage {
  Future<Mess> createMess({String userId});
  Future<bool> isRegisteredUser({User user});
  Stream<QuerySnapshot> getAllUsers({int offset, int limit});
  Stream<QuerySnapshot> getAllMess({int offset, int limit});
  Stream<QuerySnapshot> getAllMessByUserId(
      {String userId, int offset, int limit});
  Future<void> saveUser({User user});
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

  Future<void> saveUser({User user}) async {
    final TransactionHandler createUserTransaction = (Transaction tx) async {
      bool isRegistered = await this.isRegisteredUser(user: user);

      if (!isRegistered) {
        final DocumentSnapshot ds =
            await tx.get(_db.collection('users').document());

        var dataMap = user.toMap();

        await tx.set(ds.reference, dataMap);

        return dataMap;
      }
    };

    await _db.runTransaction(createUserTransaction);
  }

  Future<bool> isRegisteredUser({User user}) async {
    QuerySnapshot snapshots = await _db
        .collection('users')
        .where('userId', isEqualTo: user.userId)
        .getDocuments();

    return snapshots.documents.isNotEmpty;
  }

  Stream<QuerySnapshot> getAllUsers({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = _db.collection('users').snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
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

  Stream<QuerySnapshot> getAllMessByUserId(
      {String userId, int offset, int limit}) {
    Stream<QuerySnapshot> snapshots =
        _db.collection('mess').where('userId', isEqualTo: userId).snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }
}
