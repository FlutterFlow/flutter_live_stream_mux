import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mux_live/screens/authentication/register_page.dart';
import 'package:flutter_mux_live/utils/authentication_client.dart';
import 'package:flutter_mux_live/utils/validators.dart';

import '../stream/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  late final TextEditingController _emailTextController;
  late final TextEditingController _passwordTextController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final AuthenticationClient _authClient;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _authClient = AuthenticationClient();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   elevation: 0,
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   title: RichText(
        //     text: const TextSpan(
        //       style: TextStyle(
        //         fontSize: 22,
        //         color: Colors.indigo,
        //       ),
        //       children: [
        //         TextSpan(
        //           text: 'MUX ',
        //           style: TextStyle(
        //             color: Colors.pinkAccent,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //         TextSpan(
        //           text: 'Live Stream',
        //           style: TextStyle(
        //             color: Colors.pink,
        //             fontWeight: FontWeight.w300,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            onChanged: () => setState(() {}),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 56.0, vertical: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailTextController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.indigo.withOpacity(0.8),
                    ),
                    cursorColor: Colors.indigo,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 3,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo.withOpacity(0.5),
                      ),
                      hintText: 'Enter email',
                    ),
                    validator: (value) => Validators.validateEmail(
                      email: value,
                    ),
                    // onChanged: (value) => widget.onChange(value),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTextController,
                    textInputAction: TextInputAction.done,
                    focusNode: _passwordFocusNode,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.indigo.withOpacity(0.8),
                    ),
                    cursorColor: Colors.indigo,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 3,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      hintText: 'Enter password',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.indigo.withOpacity(0.5),
                      ),
                    ),
                    validator: (value) => Validators.validatePassword(
                      password: value,
                    ),
                    // onChanged: (value) => widget.onChange(value),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16.0),
                  //   child: Text(
                  //     'Error',
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //       color: Theme.of(context).colorScheme.error,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 32),
                  _isProcessing
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.primary,
                              onSurface: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () async {
                              setState(() {
                                _isProcessing = true;
                              });

                              final user =
                                  await _authClient.signInUsingEmailPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text,
                              );

                              setState(() {
                                _isProcessing = false;
                              });

                              if (user != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => DashboardPage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
