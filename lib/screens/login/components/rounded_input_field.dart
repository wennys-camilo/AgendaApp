import 'package:agendaapp/screens/login/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool enabled;

  final TextInputType keyboardType;

  RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.enabled,
    this.keyboardType,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: keyboardType,
        controller: controller,
        enabled: enabled,
        validator: validator,
        autocorrect: false,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
