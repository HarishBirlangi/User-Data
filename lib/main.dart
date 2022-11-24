import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userdatastorage/screens/add_user_data.dart';
import 'package:userdatastorage/screens/users_data_page.dart';
import 'package:userdatastorage/services/bloc/user_data_bloc.dart';
import 'package:userdatastorage/services/hive_service.dart';
import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.getInstance().intializeHiveService();
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
              UserDataBloc()..add(const LoadUserDataEvent()),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const UsersDatapage(),
        routes: {
          usersDataRoute: (context) => const UsersDatapage(),
          addUserData: (context) => const AddUserData(),
        },
      ),
    );
  }
}
