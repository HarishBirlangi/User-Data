part of 'user_data_bloc.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object?> get props => [];
}

class UserDataLoadingState extends UserDataState {}

class UserDataLoadedState extends UserDataState {
  final List<UserData> usersDataList;

  const UserDataLoadedState({this.usersDataList = const <UserData>[]});

  @override
  List<Object> get props => [usersDataList];
}
