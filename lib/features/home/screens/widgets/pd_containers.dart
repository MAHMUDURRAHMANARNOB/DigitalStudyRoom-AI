import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_function.dart';
import 'card_container_button.dart';

class PDContainer extends StatelessWidget {
  const PDContainer({
    super.key,
    required this.image,
    required this.title,
    required this.bgColor,
  });

  final String image;
  final String title;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      // height: 150,
      decoration: BoxDecoration(
        color: /*dark ? TColors.dark : TColors.light*/
            bgColor,
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            image,
            height: 100,
            width: 150,
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
