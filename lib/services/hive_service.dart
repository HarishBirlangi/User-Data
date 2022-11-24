import 'package:hive/hive.dart';
import 'package:userdatastorage/constants/constants.dart';
import 'package:userdatastorage/models/user_data.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

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
      print(e);
    }
  }

  Future<void> hiveInitPath() async {
    final appDocumnetDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumnetDirectory.path);
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
    } catch (e) {
      print(e);
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
