import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Não possui uma conta ? " : "Já tem uma conta ? ",
          style: TextStyle(color: Color(0xff2e2e42)),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Cadastre-se" : "Entrar",
            style: TextStyle(
              color: Color(0xff2e2e42),
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
