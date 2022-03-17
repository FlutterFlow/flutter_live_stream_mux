import 'package:flutter/material.dart';
import 'package:flutter_mux_live/utils/authentication_client.dart';
import 'package:flutter_mux_live/utils/validators.dart';

import '../stream/dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameTextController;
  late final TextEditingController _emailTextController;
  late final TextEditingController _passwordTextController;
  late final TextEditingController _confirmPasswordTextController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;
  late final AuthenticationClient _authClient;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordTextController = TextEditingController();
    _authClient = AuthenticationClient();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _nameFocusNode.unfocus();
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
        _confirmPasswordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              onChanged: () => setState(() {}),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 56.0, vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameTextController,
                      focusNode: _nameFocusNode,
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
                        hintText: 'Enter name',
                      ),
                      validator: (value) => Validators.validateName(
                        name: value,
                      ),
                      // onChanged: (value) => widget.onChange(value),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _emailFocusNode,
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
                      focusNode: _passwordFocusNode,
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
                        hintText: 'Enter password',
                      ),
                      validator: (value) => Validators.validatePassword(
                        password: value,
                      ),
                      // onChanged: (value) => widget.onChange(value),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      obscureText: true,
                      controller: _confirmPasswordTextController,
                      focusNode: _confirmPasswordFocusNode,
                      textInputAction: TextInputAction.done,
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
                        hintText: 'Confirm password',
                      ),
                      validator: (value) => Validators.validateConfirmPassword(
                        password: _passwordTextController.text,
                        confirmPassword: value,
                      ),
                      // onChanged: (value) => widget.onChange(value),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _isProcessing
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).colorScheme.primary,
                                onSurface:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isProcessing = true;
                                });

                                final user = await _authClient
                                    .registerUsingEmailPassword(
                                  name: _nameTextController.text,
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
                                  'Sign Up',
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
      ),
    );
  }
}
