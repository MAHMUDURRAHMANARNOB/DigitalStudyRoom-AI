import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  final String fullName;
  final String? className;

  const THomeAppBar({
    super.key,
    required this.fullName,
    this.className,
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
              child: Image.asset("assets/images/user_image.png"),
            ),
          ),
          SizedBox(
            width: 10,
          ),
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
                fullName,
                style: Theme.of(context).textTheme.bodyLarge!.apply(),
              ),
              className == null
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          // barrierDismissible: false,
                          // Prevent closing the dialog until download completes
                          builder: (BuildContext context) {
                            return AlertDialog();
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: TColors.secondaryColor.withOpacity(1),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          "Select your class",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(color: Colors.white),
                        ),
                      ),
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: TColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TColors.white),
                      ),
                      child: Text(
                        "Class $className",
                        style: TextStyle(
                          color: TColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
      showBackArrow: false,
      /*actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.search_normal,
              color: Colors.black,
            ))
      ],*/
    );
  }
}
