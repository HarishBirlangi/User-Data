import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:userdatastorage/models/user_data.dart';
import 'package:userdatastorage/services/utility_services.dart';

class FireStoreService {
  static FireStoreService? _instance;

  static FireStoreService getInstance() {
    _instance ??= FireStoreService();
    return _instance!;
  }

  Future<void> intializeFireStoreService() async {
    await Firebase.initializeApp();
  }

  Future<void> addUserData(UserData userData) async {
    FirebaseFirestore.instance.collection('user-data').add({
      'name': userData.userName,
      'phoneNumber': userData.phoneNumber,
      'emailId': userData.emailId,
      'dateOfBirth': userData.dateOfBirth,
      'image': userData.image,
    });
    UtilityServices().showSnackBar('User data added to Cloud Firestore');
  }

  Future<List<UserData>> getUserData() async {
    List<UserData> list = [];
    var data = await FirebaseFirestore.instance.collection("user-data").get();
    for (int i = 0; i < data.docs.length; i++) {
      UserData userData = UserData(
        userName: data.docs[i].data()['name'],
        phoneNumber: data.docs[i].data()['phoneNumber'],
        dateOfBirth: data.docs[i].data()['dateOfBirth'],
        emailId: data.docs[i].data()['emailId'],
        image: data.docs[i].data()['image'],
      );
      list.add(userData);
    }
    return list;
  }

  Future<void> deleteUserData(int index) async {
    var data = await FirebaseFirestore.instance.collection("user-data").get();
    String id = data.docs[index].id;
    await FirebaseFirestore.instance.collection("user-data").doc(id).delete();
  }
}
