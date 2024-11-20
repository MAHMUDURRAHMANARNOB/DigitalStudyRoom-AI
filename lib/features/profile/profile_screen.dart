import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:digital_study_room/utils/constants/sizes.dart';
import 'package:digital_study_room/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // TOP PART
            Column(
              children: [
                Image.asset(
                  "assets/images/user_image.png",
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: TSizes.sm / 2),
                Text(
                  "Mahmudur Rahman",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: TSizes.sm / 2),
                Text(
                  "mahmudur.rahman2023@gmail.com",
                  style: TextStyle(),
                ),
                SizedBox(height: TSizes.sm / 2),
                ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text("Edit Profile"),
                  ),
                ),
              ],
            ),
      
            //   Tokens and other stuffs
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: double.infinity,
              child: Text(
                "Tokens",
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),

              decoration: BoxDecoration(
                color: TColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: TColors.primaryColor)
              ),
              child: Column(
                children: [
                  //   Homework Token
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.airplane_ticket,
                              color: TColors.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: TSizes.sm,
                          ),
                          Text("Homework Token"),
                        ],
                      ),
                      Text(
                        "1399",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColors.primaryColor,
                            fontSize: 24),
                      ),
                    ],
                  ),
                  Divider(
                    color: TColors.primaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.star,
                              color: TColors.secondaryColor,
                            ),
                          ),
                          SizedBox(
                            width: TSizes.sm,
                          ),
                          Text("Question Token"),
                        ],
                      ),
                      Text(
                        "2585",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColors.secondaryColor,
                            fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      
            //   Subscription Details
            Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: Text(
                  "Subscription Details",
                  textAlign: TextAlign.left,
                )),
            Container(
              margin: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
              padding:
                  const EdgeInsets.all(10.0, ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: TColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: TColors.primaryColor)
              ),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Active Package: ',
                      style: DefaultTextStyle.of(context).style,
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Mastermind Pro',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: TColors.primaryColor,
                              fontSize: 20,
                            )),
                      ],
                    ),
                  ),
                  Divider(
                    color: TColors.primaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Purchased Date:"),
                      Text("28-Apr-2024"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Valid Till:"),
                      Text("28-Apr-2024"),
                    ],
                  ),
                ],
              ),
            ),
      
            //   Preference
            Container(
                margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: Text(
                  "Preferences",
                  textAlign: TextAlign.left,
                )),
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: TColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: TColors.primaryColor)
              ),
              child: Column(
                children: [
                  //   Homework Token
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Iconsax.money,
                              color: TColors.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: TSizes.sm,
                          ),
                          Text("Subscription plans"),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: TColors.primaryColor,
                        size: 30,
                      ),
                    ],
                  ),
                  Divider(
                    color: TColors.primaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.history,
                              color: TColors.primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: TSizes.sm,
                          ),
                          Text("History"),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: TColors.primaryColor,
                        size: 30,
                      ),
                    ],
                  ),
                  Divider(
                    color: TColors.primaryColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Iconsax.logout_1,
                              color: TColors.error,
                            ),
                          ),
                          SizedBox(
                            width: TSizes.sm,
                          ),
                          Text("Logout"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
