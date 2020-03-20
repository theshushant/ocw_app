import 'package:ocw_app/models/app_state.dart';
import 'package:ocw_app/reducers/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return state.rebuild((b) => b
    ..user.replace(userReducer(state.user, action))
);
}
