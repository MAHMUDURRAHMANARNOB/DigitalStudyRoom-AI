import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../utils/constants/sizes.dart';

class AiHelperContainer extends StatelessWidget {
  const AiHelperContainer({
    super.key,
    required this.image,
    required this.title, required this.bgColor,
  });

  final String image;
  final String title;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 40,
            width: 40,
          ),
          SizedBox(
            height: TSizes.spaceBtwItems/2,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
