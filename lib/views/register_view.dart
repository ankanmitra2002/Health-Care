import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:hello/Utilities/show_error_dialog.dart';
import 'package:hello/constants/routes.dart';

//import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        //color: Colors.blue,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/healthcare.jpg',
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                ),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pass,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                ),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final pass = _pass.text;
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: pass);
                  final user = FirebaseAuth.instance.currentUser;
                  user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    await showErrorDialog(context, 'Weak password');
                  } else if (e.code == 'email-already-in-use') {
                    await showErrorDialog(context, 'email-already-in-use');
                  } else if (e.code == 'invalid-email') {
                    await showErrorDialog(context, 'Invalid Email Address');
                  } else {
                    await showErrorDialog(context, 'Error:${e.code}');
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString());
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginroute, (route) => false);
                },
                child: const Text('Already Registered?Login'))
          ],
        ),
      ),
    );
  }
}
