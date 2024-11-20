import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Row(

        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(
                maxWidth: 50,
                maxHeight: 50,
              ),
              // color: Colors.green,
              child:  Image.asset("assets/images/user_image.png"),
            ),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Text(
                TTexts.homeAppbarTitle,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(color: TColors.primaryColor),
              ),*/
              Text(
                TTexts.homeAppbarSubTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(),
              ),Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: TColors.primaryColor.withOpacity(1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  "Class - 12",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      showBackArrow: false,
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.search_normal,
              color: Colors.black,
            ))
      ],
    );
  }
}
