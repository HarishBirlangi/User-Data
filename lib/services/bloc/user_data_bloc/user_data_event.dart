part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();
  @override
  List<Object> get props => [];
}

class LoadUserDataEvent extends UserDataEvent {
  final List<UserData> usersDataList;

  const LoadUserDataEvent({this.usersDataList = const <UserData>[]});

  @override
  List<Object> get props => [usersDataList];
}

class LoadUserDataOfflineEvent extends UserDataEvent {
  final List<UserData> usersDataList;

  const LoadUserDataOfflineEvent({this.usersDataList = const <UserData>[]});

  @override
  List<Object> get props => [usersDataList];
}

class AddUserDataEvent extends UserDataEvent {
  final UserData userData;

  const AddUserDataEvent({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UpdateUserDataEvent extends UserDataEvent {
  final UserData userData;

  const UpdateUserDataEvent({required this.userData});

  @override
  List<Object> get props => [userData];
}

class DeleteUserDataEvent extends UserDataEvent {
  final int index;

  const DeleteUserDataEvent({required this.index});

  @override
  List<Object> get props => [];
}
