import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userdatastorage/screens/add_user_data.dart';
import 'package:userdatastorage/screens/home_page.dart';
import 'package:userdatastorage/screens/inapp_web_view_page.dart';
import 'package:userdatastorage/screens/users_data_page.dart';
import 'package:userdatastorage/services/bloc/internet_bloc/internet_access_bloc.dart';
import 'package:userdatastorage/services/bloc/user_data_bloc/user_data_bloc.dart';
import 'package:userdatastorage/services/fire_store_service.dart';
import 'package:userdatastorage/services/hive_service.dart';
import 'package:userdatastorage/services/utility_services.dart';

import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.getInstance().intializeHiveService();
  await FireStoreService.getInstance().intializeFireStoreService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              InternetAccessBloc()..add(InternetAccessObserveEvent()),
        ),
        BlocProvider(
          create: (context) => UserDataBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        scaffoldMessengerKey: scaffoldKey,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
        routes: {
          usersDataRoute: (context) => const UsersDatapage(),
          addUserData: (context) => const AddUserData(),
          webViewPageRoute: (context) => const InAppWebPage(
                initialUrl: "http://birlangiharish.pythonanywhere.com/qp/",
              ),
        },
      ),
    );
  }
}
