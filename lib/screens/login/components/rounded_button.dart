import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final Widget child;
  const RoundedButton(
      {Key key,
      this.text,
      this.press,
      this.color,
      this.textColor = Colors.white,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Theme.of(context)
                      .primaryColor
                      .withAlpha(100); // Disabled color
                }
                return Theme.of(context).primaryColor;
                // Regular color
              }),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: press,
            child: child),
      ),
    );
  }
}
