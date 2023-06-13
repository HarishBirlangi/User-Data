part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();
  @override
  List<Object> get props => [];
}

class LoadUserDataEventOffline extends UserDataEvent {
  final List<UserData> usersDataList;

  const LoadUserDataEventOffline({this.usersDataList = const <UserData>[]});

  @override
  List<Object> get props => [usersDataList];
}

class LoadUserDataEventOnline extends UserDataEvent {
  final List<UserData> usersDataList;

  const LoadUserDataEventOnline({this.usersDataList = const <UserData>[]});

  @override
  List<Object> get props => [usersDataList];
}

class AddUserDataEventOffline extends UserDataEvent {
  final UserData userData;

  const AddUserDataEventOffline({required this.userData});

  @override
  List<Object> get props => [userData];
}

class AddUserDataEventOnline extends UserDataEvent {
  final UserData userData;

  const AddUserDataEventOnline({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UpdateUserDataEventOnline extends UserDataEvent {
  final UserData userData;
  final int index;

  const UpdateUserDataEventOnline({
    required this.userData,
    required this.index,
  });

  @override
  List<Object> get props => [userData];
}

class UpdateUserDataEventOffline extends UserDataEvent {
  final UserData userData;
  final int index;

  const UpdateUserDataEventOffline({
    required this.userData,
    required this.index,
  });

  @override
  List<Object> get props => [userData];
}

class DeleteUserDataEventOffline extends UserDataEvent {
  final int index;

  const DeleteUserDataEventOffline({required this.index});

  @override
  List<Object> get props => [];
}

class DeleteUserDataEventOnline extends UserDataEvent {
  final int index;

  const DeleteUserDataEventOnline({required this.index});

  @override
  List<Object> get props => [];
}
