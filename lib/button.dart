import 'package:flutter/material.dart';
import 'package:survey/colors.dart';

class PatientButton extends StatelessWidget {
  final bool isHollow;
  final String text;
  final double? height;
  final double? width;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;
  final Color? backgroundColorHollow;
  final Color? borderColor;
  final Color? backgroundColorDisabled;
  final Color? textColorDisabled;
  final FontWeight fontWeight;
  final AlignmentGeometry? textAlignment;
  final EdgeInsets? padding;
  final VoidCallback? handleTap;

  const PatientButton({
    required this.text,
    required this.backgroundColor,
    required this.handleTap,
    this.isHollow = false,
    this.height,
    this.width,
    this.fontSize = ConfigConstants.fontCheckoutButton,
    this.textColor = ConfigConstants.white,
    this.backgroundColorHollow,
    this.borderColor,
    this.backgroundColorDisabled,
    this.textColorDisabled,
    this.fontWeight = FontWeight.bold,
    this.textAlignment,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              isHollow && backgroundColorHollow != null
                  ? backgroundColorHollow!
                  : handleTap == null
                      ? backgroundColorDisabled == null
                          ? ConfigConstants.greyDark
                          : backgroundColorDisabled!
                      : backgroundColor,
            ),
            elevation: MaterialStateProperty.all<double>(
              0,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: isHollow && borderColor != null
                    ? BorderSide(
                        color: borderColor!,
                        width: 1,
                      )
                    : BorderSide.none,
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              padding ?? const EdgeInsets.all(0),
            ),
            alignment: textAlignment ?? Alignment.center),
        onPressed: handleTap == null ? null : () => handleTap!(),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: handleTap == null && textColorDisabled != null
                ? textColorDisabled
                : textColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
