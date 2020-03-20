import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocw_app/containers/booking_container.dart';
import 'package:ocw_app/containers/profile_page_container.dart';
import 'package:ocw_app/models/user/user.dart';
import 'package:ocw_app/models/user/user_type.dart';
import 'package:ocw_app/presentation/function/wil_pop_scope.dart';
import 'package:ocw_app/presentation/profile/logout_dialog.dart';
import 'package:ocw_app/service/broadcaster_service.dart';
import 'package:ocw_app/utils/globals.dart';
import 'package:ocw_app/utils/size_config.dart';
import 'package:ocw_app/utils/string.dart';

class HomePage extends StatefulWidget {
  final User user;
  final Function onExit;
  final Function logout;

  HomePage(this.user,  this.onExit,
       this.logout);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: widget.user.userType == UserType.admin ? 3 : 2,
        initialIndex: 1,
        vsync: this);

    broadcasterService.on(BroadcasterEventType.onExitSession).listen((data) {
      if (mounted) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return Exit(widget.onExit);
            });
      },
      child: SafeArea(
        child: Scaffold(
          drawer: _drawer(),
          appBar: _appBar(),
          body: Container(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.black,
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(right: 10),
          child: Text(
            widget.user.fullName,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.only(
          top: SizeConfig.screenHeight * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    height: SizeConfig.screenHeight * 0.2,
                    width: SizeConfig.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.screenHeight * 0.1),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/profilepic1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    widget.user != null ? widget.user.fullName : '',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.1),
              child: Divider(
                color: Colors.white,
                thickness: 2,
              ),
            ),
            _drawerOptions(StringValue.bookingPage, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          _scaffoldChild(BookingContainer())));
            }),
            _drawerOptions(StringValue.profilePage, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          _scaffoldChild(ProfileContainer())));
            }),
            _drawerOptions(StringValue.logOut, () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LogoutDialog(widget.logout);
                  });
            }),
          ],
        ),
      ),
    );
  }

  Widget _scaffoldChild(Widget widget) {
    return Scaffold(
      body: widget,
    );
  }

  Widget _drawerOptions(String text, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
//            border: Border.all(
//              color: Colors.white,
//            ),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.all(
          SizeConfig.screenHeight * 0.01,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
