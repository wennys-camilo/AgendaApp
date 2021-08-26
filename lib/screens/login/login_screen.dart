import 'package:agendaapp/helpers/validators.dart';
import 'package:agendaapp/models/user.dart';
import 'package:agendaapp/models/user_maneger.dart';
import 'package:agendaapp/screens/HomePage.dart';
import 'package:agendaapp/screens/login/components/already_have_an_account_acheck.dart';

import 'package:agendaapp/screens/login/components/rounded_button.dart';
import 'package:agendaapp/screens/login/components/rounded_input_field.dart';
import 'package:agendaapp/screens/login/components/rounded_password_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Consumer<Usermanager>(
          builder: (_, userManager, __) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/images/loginscreen.svg",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  RoundedInputField(
                    hintText: "Email",
                    controller: emailController,
                    enabled: !userManager.loading,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (!emailValid(email)) return "E-mail inválido";
                      return null;
                    },
                    //onChanged: (value) {},
                  ),
                  RoundedPasswordField(
                    enabled: !userManager.loading,
                    controller: passController,
                    validator: (pass) {
                      if (pass.isEmpty || pass.length < 6) {
                        return 'Senha Invalida';
                      }
                      return null;
                    },
                  ),
                  RoundedButton(
                    text: "LOGIN",
                    press: userManager.loading
                        ? null
                        : () {
                            if (formKey.currentState.validate()) {
                              userManager.signIn(
                                  usuario: Usuario(
                                      email: emailController.text,
                                      password: passController.text),
                                  onFail: (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Falha ao Entrar: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  onSuccess: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FirsPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  });
                            }
                          },
                    child: userManager.loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text(
                            "Entrar",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff2e2e42)),
                          ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    press: () {},
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
