import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userdatastorage/constants/constants.dart';
import 'package:userdatastorage/services/bloc/internet_bloc/internet_access_bloc.dart';
import 'package:userdatastorage/services/bloc/user_data_bloc/user_data_bloc.dart';
import 'package:userdatastorage/services/fire_store_service.dart';

class UsersDatapage extends StatefulWidget {
  const UsersDatapage({super.key});

  @override
  State<UsersDatapage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UsersDatapage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Data'),
      ),
      body: BlocConsumer<InternetAccessBloc, InternetAccessState>(
        listener: (context, state) {
          if (state is InternetAccessSuccessState) {
            BlocProvider.of<UserDataBloc>(context)
                .add(const LoadUserDataEventOnline());
          } else if (state is InternetAccessFailureState) {
            BlocProvider.of<UserDataBloc>(context)
                .add(const LoadUserDataEventOffline());
          }
        },
        builder: (context, state) {
          return BlocBuilder<UserDataBloc, UserDataState>(
            builder: (context, state) {
              if (state is UserDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is UserDataLoadedState) {
                final usersData = state.usersDataList;
                return ListView.separated(
                  itemCount: usersData.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                      height: 20,
                    );
                  },
                  itemBuilder: (context, index) {
                    final Uint8List decodedImage =
                        base64Decode(usersData[index].image);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: Image.memory(decodedImage).image,
                        radius: 30,
                      ),
                      title: Text(
                        usersData[index].userName.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usersData[index].phoneNumber.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            usersData[index].emailId.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            usersData[index].dateOfBirth.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            final internetState =
                                context.read<InternetAccessBloc>().state;
                            if (internetState is InternetAccessSuccessState) {
                              context
                                  .read<UserDataBloc>()
                                  .add(DeleteUserDataEventOnline(index: index));
                            } else {
                              context.read<UserDataBloc>().add(
                                  DeleteUserDataEventOffline(index: index));
                            }
                          },
                          icon: const Icon(Icons.delete)),
                    );
                  },
                );
              } else {
                return const Text("No data found");
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(addUserData);
        },
        tooltip: 'Add new user data',
        child: const Icon(Icons.add),
      ),
    );
  }
}
