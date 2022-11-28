import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
part 'internet_access_event.dart';
part 'internet_access_state.dart';

class InternetAccessBloc
    extends Bloc<InternetAccessEvent, InternetAccessState> {
  late StreamSubscription connectivityStreamSubscription;
  InternetAccessBloc() : super(InternetAccessInitialState()) {
    on<InternetAccessObserveEvent>((event, emit) {
      connectivityStreamSubscription =
          Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) {
          if (result == ConnectivityResult.none) {
            InternetAccessBloc()
                .add(const InternetAccessNotifyEvent(isConnected: false));
            print('No internet');
          } else {
            InternetAccessBloc()
                .add(const InternetAccessNotifyEvent(isConnected: true));
            print('Internet connected');
          }
        },
      );
    });

    on<InternetAccessNotifyEvent>(
      (event, emit) async {
        print('InternetAccessNotifyEvent called');
        event.isConnected
            ? emit(InternetAccessSuccessState())
            : emit(InternetAccessFailureState());
      },
    );
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
