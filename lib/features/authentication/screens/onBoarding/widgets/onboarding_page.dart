import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_function.dart';

class OnBoardingPage extends StatelessWidget {
  final String image, title, subTitle;

  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          /*Image(
            width: THelperFunction.screenWidth(context) * 0.8,
            height: THelperFunction.screenHeight(context) * 0.6,
            image: AssetImage(image),
          ),*/
          Lottie.asset(
            image,
            width: THelperFunction.screenWidth(context) * 0.8,
            height: THelperFunction.screenHeight(context) * 0.5,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
