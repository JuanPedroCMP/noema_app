import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {

  const SplashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return Center(child: 
      Text(
        "Carregando", 
        style: Theme.of(context)
          .textTheme
          .headlineMedium,
      )
    );
  }
}
