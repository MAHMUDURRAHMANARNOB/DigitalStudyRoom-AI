import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/helpers/helper_function.dart';

class TSectionHeading extends StatelessWidget {
  const TSectionHeading({
    super.key,
    required this.title,
    this.buttonTitle,
    this.onPressed,
    this.textColor,
    required this.showActionButton,
  });

  final String title;
  final Color? textColor;
  final bool showActionButton;
  final String? buttonTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunction.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: () {
              onPressed;
            },
            child: Text(
              buttonTitle!,
              // style: TextStyle(
              //   color: dark ? TColors.light : TColors.dark,
              // ),
              style: Theme.of(context).textTheme.bodySmall!,
            ),
          ),
      ],
    );
  }
}
