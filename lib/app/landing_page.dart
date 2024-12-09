import 'package:flutter/material.dart';
import 'package:net_chat/app/home_page.dart';
import 'package:net_chat/app/sign_in/sign_in_page.dart';
import 'package:net_chat/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewmodel>(context);

    if (userViewModel.state == ViewState.Idle) {
      if (userViewModel.userModel == null) {
        return const SignInPage();
      } else {
        return HomePage(
          user: userViewModel.userModel!, userModel: null,
        );
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
