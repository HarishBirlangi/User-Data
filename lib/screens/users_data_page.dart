import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userdatastorage/constants/constants.dart';
import 'package:userdatastorage/services/bloc/internet_bloc/internet_access_bloc.dart';
import 'package:userdatastorage/services/bloc/user_data_bloc/user_data_bloc.dart';

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
              } else if (state is UserDataLoadedState) {
                final usersData = state.usersDataList;

                return usersData.isEmpty
                    ? const Center(child: Text('No data'))
                    : CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final Uint8List decodedImage =
                                    base64Decode(usersData[index].image);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Image(
                                            image: Image.memory(decodedImage)
                                                .image,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.fill),
                                        ListTile(
                                          title: Text(
                                            usersData[index].userName,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  usersData[index]
                                                      .phoneNumber
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  usersData[index]
                                                      .emailId
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: PopupMenuButton(
                                            child: const Icon(Icons.more_vert),
                                            itemBuilder: (context) {
                                              return [
                                                const PopupMenuItem(
                                                  value: 0,
                                                  child: Text('Edit'),
                                                ),
                                                const PopupMenuItem(
                                                  value: 1,
                                                  child: Text('Delete'),
                                                ),
                                              ];
                                            },
                                            onSelected: (value) {
                                              if (value == 0) {
                                                Navigator.of(context).pushNamed(
                                                    addUserData,
                                                    arguments:
                                                        AddUserDataPageArguments(
                                                            index: index,
                                                            userDataEdit:
                                                                true));
                                              } else if (value == 1) {
                                                final internetState = context
                                                    .read<InternetAccessBloc>()
                                                    .state;
                                                if (internetState
                                                    is InternetAccessSuccessState) {
                                                  context.read<UserDataBloc>().add(
                                                      DeleteUserDataEventOnline(
                                                          index: index));
                                                } else {
                                                  context.read<UserDataBloc>().add(
                                                      DeleteUserDataEventOffline(
                                                          index: index));
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: usersData.length,
                            ),
                          ),
                        ],
                      );
              } else {
                return const Center(child: Text('Something went wrong'));
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(addUserData, arguments: AddUserDataPageArguments());
        },
        tooltip: 'Add new user data',
        child: const Icon(Icons.add),
      ),
    );
  }
}
