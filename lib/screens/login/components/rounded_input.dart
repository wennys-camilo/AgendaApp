import 'package:agendaapp/screens/login/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final bool enabled;
  final bool obscureText;
  final Function onPressed;
  final String hintText;
  final IconData iconData;
  final bool isInputSenha;
  final TextInputType keyboardType;
  const RoundedInput(
      {Key key,
      this.onChanged,
      this.validator,
      this.enabled,
      this.controller,
      this.obscureText = false,
      this.hintText,
      this.iconData,
      this.isInputSenha = false,
      this.keyboardType,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: obscureText,
        onChanged: onChanged,
        autocorrect: false,
        cursorColor: Theme.of(context).primaryColor,
        validator: validator,
        keyboardType: keyboardType,
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            iconData,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: isInputSenha
              ? IconButton(
                  icon: Icon(Icons.visibility),
                  color: Theme.of(context).primaryColor,
                  onPressed: onPressed,
                )
              : Container(
                  width: 0,
                ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
