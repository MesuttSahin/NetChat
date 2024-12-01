import 'package:flutter/material.dart';
import 'package:net_chat/app/home_page.dart';
import 'package:net_chat/app/sign_in/sign_in_page.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewmodel>(context);

    if (_userViewModel.state == ViewState.Idle) {
      if (_userViewModel.userModel == null) {
        return SignInPage();
      } else {
        return HomePage(
          user: _userViewModel.userModel!,
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
