import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'MUX',
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                'Live Stream',
                style: Theme.of(context).textTheme.headline2,
              ),
              const Spacer(),
              const CircularProgressIndicator(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
