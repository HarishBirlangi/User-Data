import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:userdatastorage/models/user_data.dart';
import 'package:userdatastorage/services/fire_store_service.dart';
import 'package:userdatastorage/services/hive_service.dart';
part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final HiveService _hive = HiveService();
  final FireStoreService _fireStoreService = FireStoreService();
  late List<UserData> usersDataListFetched;

  UserDataBloc() : super(UserDataLoadingState()) {
    on<LoadUserDataEventOffline>(
      (event, emit) {
        usersDataListFetched = _hive.getUsersData();
        emit(UserDataLoadedState(usersDataList: usersDataListFetched));
      },
    );

    on<LoadUserDataEventOnline>(
      (event, emit) async {
        usersDataListFetched = await _fireStoreService.getUserData();
        emit(UserDataLoadedState(usersDataList: usersDataListFetched));
      },
    );

    on<AddUserDataEventOffline>(
      (event, emit) async {
        if (state is UserDataLoadedState) {
          _hive.addUserData(event.userData);
          usersDataListFetched = _hive.getUsersData();
          emit(
            UserDataLoadedState(usersDataList: usersDataListFetched),
          );
        }
      },
    );

    on<AddUserDataEventOnline>(
      (event, emit) async {
        _fireStoreService.addUserData(event.userData);
        usersDataListFetched = await _fireStoreService.getUserData();
        emit(
          UserDataLoadedState(usersDataList: usersDataListFetched),
        );
      },
    );

    on<UpdateUserDataEvent>(
      (event, emit) {},
    );

    on<DeleteUserDataEventOffline>(
      (event, emit) {
        final state = this.state;
        if (state is UserDataLoadedState) {
          emit(UserDataLoadingState());
          _hive.deleteUserdata(event.index);
          usersDataListFetched = _hive.getUsersData();
          emit(
            UserDataLoadedState(usersDataList: usersDataListFetched),
          );
        }
      },
    );

    on<DeleteUserDataEventOnline>(
      (event, emit) async {
        if (state is UserDataLoadedState) {
          emit(UserDataLoadingState());
          await _fireStoreService.deleteUserData(event.index);
          usersDataListFetched = await _fireStoreService.getUserData();
          emit(
            UserDataLoadedState(usersDataList: usersDataListFetched),
          );
        }
      },
    );
  }
}
