import 'package:ocw_app/actions/actions.dart';
import 'package:ocw_app/database/user/user_database.dart';
import 'package:ocw_app/models/app_state.dart';
import 'package:ocw_app/models/broadcaster_event.dart';
import 'package:ocw_app/models/user/user.dart';
import 'package:ocw_app/service/broadcaster_service.dart';
import 'package:ocw_app/utils/globals.dart';
import 'package:redux/redux.dart';

Future<Null> appMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  print("*******action called  " + action.runtimeType.toString() + "  *****");
  print("In app middleware");


  switch (action.runtimeType) {
    case CheckSession:
      preferenceService.getAuthUser().then((User user) {
        if (user != null && user.id != null) {
          store.dispatch(SetUserComplete(user: user));
        }
      });
      break;
    case ExitSession:
      preferenceService.setAuthUser(store.state.user.profile).then((v) {
        broadcasterService.broadcast(
            BroadcasterEvent(event: BroadcasterEventType.onExitSession));
      });
      break;

    case OnRefreshWallet:
      next(action);
      store.dispatch(CheckSession());
      login(
              password: store.state.user.profile.password,
              emailId: store.state.user.profile.emailId)
          .then((value) {
        store.dispatch(OnRefreshWalletComplete());
        store.dispatch(SetUser(user: value));
      });
      break;

    default:
      next(action);
  }
}
