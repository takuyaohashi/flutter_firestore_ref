import 'dart:collection';

import 'package:example/model/firestore/firestore.dart';
import 'package:example/util/util.dart';
import 'package:firestore_ref/firestore_ref.dart';
import 'package:flutter/foundation.dart';
import 'package:subscription_holder/subscription_holder.dart';

class UsersNotifier extends ChangeNotifier {
  UsersNotifier() {
    _subscriptionHolder.add(
      UsersRef.ref()
          .documents((r) => FirRefCollectionReferenceEx(r)
              .orderBy(
                EntityField.updatedAt,
                descending: true,
              )
              .limit(100))
          .listen((docs) {
        logger.info(DateTime.now());
        _userDocs = docs;
        notifyListeners();
      }),
    );
  }

  final _subscriptionHolder = SubscriptionHolder();
  List<UserDoc> _userDocs = [];
  List<UserDoc> get userDocs => UnmodifiableListView(_userDocs);

  @override
  void dispose() {
    _subscriptionHolder.dispose();

    super.dispose();
  }
}
