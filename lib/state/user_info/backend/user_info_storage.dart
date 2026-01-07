import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joby/state/constants/firebase_collection_name.dart';
import 'package:joby/state/constants/firebase_field_name.dart';
import 'package:joby/state/user_info/models/user_info_payload.dart';
import 'package:joby/typedef/user_id.dart';



class UserInfoStorage {
  const UserInfoStorage();


  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {


    try {
      var userInfo = await FirebaseFirestore.instance.collection(
          FirebaseCollectionName.users)
          .where(FirebaseFieldName.userId, isEqualTo: userId).limit(1).get();


      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }


      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
      );

      print('Payload: $payload');


      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(payload);
      return true;
    }
    catch (e) {
      print('Error saving user info');
      print(e);
      return false;
    }
  }
}