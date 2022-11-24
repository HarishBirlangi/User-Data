import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:userdatastorage/models/user_data.dart';
import 'package:userdatastorage/services/hive_service.dart';
part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final HiveService _hive = HiveService();
  UserDataBloc() : super(UserDataLoadingState()) {
    on<LoadUserDataEvent>(
      (event, emit) {
        List<UserData> usersDataList = _hive.getUsersData();
        emit(UserDataLoadedState(usersDataList: usersDataList));
      },
    );
    on<AddUserDataEvent>(
      (event, emit) {
        final state = this.state;
        if (state is UserDataLoadedState) {
          _hive.addUserData(event.userData);
          List<UserData> usersDataList = _hive.getUsersData();
          emit(
            UserDataLoadedState(usersDataList: usersDataList),
          );
        }
      },
    );

    on<UpdateUserDataEvent>(
      (event, emit) {},
    );
    on<DeleteUserDataEvent>(
      (event, emit) {
        final state = this.state;
        if (state is UserDataLoadedState) {
          _hive.deleteUserdata(event.index);
          List<UserData> usersDataList = _hive.getUsersData();
          emit(
            UserDataLoadedState(usersDataList: usersDataList),
          );
        }
      },
    );
  }
}
