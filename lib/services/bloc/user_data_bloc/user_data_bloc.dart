import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:userdatastorage/models/user_data.dart';
import 'package:userdatastorage/services/fire_store_service.dart';
import 'package:userdatastorage/services/hive_service.dart';
import 'package:userdatastorage/services/utility_services.dart';
part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final HiveService _hive = HiveService();
  final FireStoreService _fireStoreService = FireStoreService();
  late List<UserData> usersDataList;

  UserDataBloc() : super(UserDataLoadingState()) {
    on<LoadUserDataEvent>(
      (event, emit) async {
        bool hasInternet = await UtilityServices().hasInternet();
        if (hasInternet) {
          usersDataList = await _fireStoreService.getUserData();
        } else {
          usersDataList = _hive.getUsersData();
        }
        emit(UserDataLoadedState(usersDataList: usersDataList));
      },
    );
    on<AddUserDataEvent>(
      (event, emit) async {
        final state = this.state;
        if (state is UserDataLoadedState) {
          bool hasInternet = await UtilityServices().hasInternet();
          if (hasInternet) {
            _fireStoreService.addUserData(event.userData);
            usersDataList = await _fireStoreService.getUserData();
          } else {
            _hive.addUserData(event.userData);
            usersDataList = _hive.getUsersData();
          }
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
