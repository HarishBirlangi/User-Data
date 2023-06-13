import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:userdatastorage/constants/constants.dart';
import 'package:userdatastorage/models/user_data.dart';
import 'package:userdatastorage/services/utility_services.dart';

class HiveService {
  static HiveService? _instance;

  static HiveService getInstance() {
    _instance ??= HiveService();
    return _instance!;
  }

  Future<void> intializeHiveService() async {
    try {
      await hiveInitPath();
      registerHiveAdapters();
      await openHiveBox();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> hiveInitPath() async {
    late Directory appDocumentDirectory;
    if (Platform.isAndroid) {
      appDocumentDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
    } else if (Platform.isIOS) {
      appDocumentDirectory =
          await path_provider.getApplicationSupportDirectory();
    }
  }

  void registerHiveAdapters() async {
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserDataAdapter());
  }

  Future<void> openHiveBox() async {
    if (!Hive.isBoxOpen(usersDataBoxName)) {
      await Hive.openBox<UserData>(usersDataBoxName);
    }
  }

  Future<void> closeHiveBox() async {
    await Hive.close();
  }

  Future<void> addUserData(UserData userData) async {
    try {
      await Hive.box<UserData>(usersDataBoxName).add(userData);
      UtilityServices().showSnackBar('User data added to Hive');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateUserData(UserData userData, int index) async {
    try {
      await Hive.box<UserData>(usersDataBoxName).putAt(index, userData);
      UtilityServices().showSnackBar('User data updated');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<UserData> getUsersData() {
    List<UserData> allUsersData =
        Hive.box<UserData>(usersDataBoxName).values.toList();
    return allUsersData;
  }

  void deleteUserdata(int index) {
    Hive.box<UserData>(usersDataBoxName).deleteAt(index);
  }
}
