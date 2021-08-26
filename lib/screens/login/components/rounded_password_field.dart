import 'package:agendaapp/screens/login/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final bool enabled;
  const RoundedPasswordField(
      {Key key, this.onChanged, this.validator, this.enabled, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        autocorrect: false,
        cursorColor: Theme.of(context).primaryColor,
        validator: validator,
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          hintText: "Senha",
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
