import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello/constants/routes.dart';
import 'package:hello/services/auth/auth_service.dart';
//import 'package:hello/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your Email'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Text(
              'We have already send a verification email.Please open it and verify your email'),
          Text('If you have not received yet,resent email.... '),
          TextButton(
            onPressed: () async {
              await Authservice.firebase().sendEmailVerification();
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   loginroute,
              //   (route) => false,
              // );
            },
            child: const Text('Resend email Verification'),
          ),
          TextButton(
            onPressed: () {
              Authservice.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerroute, (route) => false);
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}
