import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ocw_app/models/app_state.dart';
import 'package:ocw_app/models/user/user.dart';
import 'package:redux/redux.dart';

class BookingContainer extends StatelessWidget {
  static const String routeNamed = 'Booking';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _viewModel) {
        return Container();
      },
    );
  }
}

class _ViewModel {
  final User user;
  final Function onBooking;

  _ViewModel({
    this.user,
    this.onBooking,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user.profile,
    );
  }
}
