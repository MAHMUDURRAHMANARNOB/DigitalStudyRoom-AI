import 'dart:io';

import 'package:digital_study_room/features/profile/packagesScreen.dart';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:digital_study_room/utils/constants/sizes.dart';
import 'package:digital_study_room/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../authentication/providers/AuthProvider.dart';
import '../authentication/screens/login/login.dart';
import 'DeleteAccountScreen.dart';
import 'Providers/SubscriptionStatusProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SubscriptionStatusProvider subscriptionStatusProvider =
      SubscriptionStatusProvider();
  late int userId = Provider.of<AuthProvider>(context).user!.id;
  late String userName = Provider.of<AuthProvider>(context).user!.name;
  late String email;

  late String phone;

  Future<void> _refresh() async {
    // userId = Provider.of<AuthProvider>(context).user!.id;
    // userName = Provider.of<AuthProvider>(context).user!.name;
    // final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    await subscriptionStatusProvider.fetchSubscriptionData(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    userId = Provider.of<AuthProvider>(context).user!.id;
    userName = Provider.of<AuthProvider>(context).user!.name;
    email = Provider.of<AuthProvider>(context).user!.email;
    phone = Provider.of<AuthProvider>(context).user!.mobile;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionStatusProvider>().fetchSubscriptionData(userId);
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -150,
            right: -250,
            child: TCircularContainer(
              backgroundColor: TColors.secondaryColor.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -250,
            child: TCircularContainer(
              backgroundColor: TColors.primaryColor.withOpacity(0.1),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: TColors.primaryColor,
              backgroundColor: TColors.white,
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
                          userName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: TSizes.sm / 2),
                        Text(
                          email,
                          style: TextStyle(),
                        ),
                        SizedBox(height: TSizes.sm / 2),
                        Visibility(
                          visible: phone != null,
                          child: Text(
                            phone,
                            style: TextStyle(),
                          ),
                        ),
                        SizedBox(height: TSizes.sm / 2),
                        /*ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text("Edit Profile"),
                          ),
                        ),*/
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
                          border: Border.all(color: TColors.primaryColor)),
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
                              userId != null
                                  ? Consumer<SubscriptionStatusProvider>(
                                      builder: (context, subscriptionProvider,
                                          child) {
                                        if (subscriptionProvider.isFetching) {
                                          return const SpinKitPulse(
                                              color: TColors.primaryColor,
                                              size: 14);
                                        }

                                        if (subscriptionProvider
                                                .subscriptionStatus ==
                                            null) {
                                          return Center(child: Text('..'));
                                        }

                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${subscriptionProvider.subscriptionStatus!.ticketsAvailable}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: TColors.primaryColor,
                                                    fontSize: 24),
                                              ),
                                              // Add more details as needed
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Text(
                                      "***",
                                      style: TextStyle(),
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
                              userId != null
                                  ? Consumer<SubscriptionStatusProvider>(
                                      builder: (context, subscriptionProvider,
                                          child) {
                                        if (subscriptionProvider.isFetching) {
                                          return const SpinKitPulse(
                                              color: TColors.primaryColor,
                                              size: 14);
                                        }

                                        if (subscriptionProvider
                                                .subscriptionStatus ==
                                            null) {
                                          return Center(child: Text('..'));
                                        }

                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${subscriptionProvider.subscriptionStatus!.commentsAvailable}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: TColors.primaryColor,
                                                    fontSize: 24),
                                              ),
                                              // Add more details as needed
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Text(
                                      "***",
                                      style: TextStyle(),
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
                                      Icons.audiotrack_rounded,
                                      color: TColors.tertiaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: TSizes.sm,
                                  ),
                                  Text("Audio Minutes"),
                                ],
                              ),
                              userId != null
                                  ? Consumer<SubscriptionStatusProvider>(
                                      builder: (context, subscriptionProvider,
                                          child) {
                                        if (subscriptionProvider.isFetching) {
                                          return const SpinKitPulse(
                                              color: TColors.primaryColor,
                                              size: 14);
                                        }

                                        if (subscriptionProvider
                                                .subscriptionStatus ==
                                            null) {
                                          return Center(child: Text('..'));
                                        }

                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${subscriptionProvider.subscriptionStatus!.audioReamins}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: TColors.primaryColor,
                                                    fontSize: 24),
                                              ),
                                              // Add more details as needed
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Text(
                                      "***",
                                      style: TextStyle(),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    //   Subscription Details
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 12.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: TColors.primaryColor.withOpacity(0.05),
                        border: Border.all(color: TColors.primaryColor),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Text("Subscription Details"),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Active Package: "),
                                  userId != null
                                      ? Consumer<SubscriptionStatusProvider>(
                                          builder: (context,
                                              subscriptionProvider, child) {
                                            if (subscriptionProvider
                                                .isFetching) {
                                              return SpinKitPulse(
                                                  color: TColors.primaryColor,
                                                  size: 14);
                                            }

                                            if (subscriptionProvider
                                                    .subscriptionStatus ==
                                                null) {
                                              return Center(child: Text('--'));
                                            }

                                            return Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    subscriptionProvider
                                                        .subscriptionStatus!
                                                        .packageName
                                                        .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          TColors.primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  // Add more details as needed
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Text(
                                          "Invalid User",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 20,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                /*Purchased*/
                                Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Purchased Date"),
                                      userId != null
                                          ? Consumer<
                                              SubscriptionStatusProvider>(
                                              builder: (context,
                                                  subscriptionProvider, child) {
                                                if (subscriptionProvider
                                                    .isFetching) {
                                                  return SpinKitPulse(
                                                      color:
                                                          TColors.primaryColor,
                                                      size: 14);
                                                }

                                                if (subscriptionProvider
                                                        .subscriptionStatus ==
                                                    null) {
                                                  return Center(
                                                      child: Text('--'));
                                                }

                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        subscriptionProvider
                                                            .subscriptionStatus!
                                                            .datePurchased
                                                            .toString(),
                                                      ),
                                                      // Add more details as needed
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              "***",
                                              style: TextStyle(),
                                            ),
                                    ],
                                  ),
                                ),
                                /*Validity*/
                                Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Valid Till"),
                                      userId != null
                                          ? Consumer<
                                              SubscriptionStatusProvider>(
                                              builder: (context,
                                                  subscriptionProvider, child) {
                                                if (subscriptionProvider
                                                    .isFetching) {
                                                  return SpinKitPulse(
                                                      color:
                                                          TColors.primaryColor,
                                                      size: 14);
                                                }

                                                if (subscriptionProvider
                                                        .subscriptionStatus ==
                                                    null) {
                                                  return Center(
                                                      child: Text('--'));
                                                }

                                                return Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        subscriptionProvider
                                                            .subscriptionStatus!
                                                            .validityDate
                                                            .toString(),
                                                      ),
                                                      // Add more details as needed
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Text(
                                              "***",
                                              style: TextStyle(),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),

                    //   Preference
                    Container(
                        margin: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10.0),
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
                          border: Border.all(color: TColors.primaryColor)),
                      child: Column(
                        children: [
                          //   Homework Token
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PackagesScreen()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
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
                          ),
                          Divider(
                            color: TColors.primaryColor,
                          ),
                          /*Row(
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
                          ),*/
                          //Delete Account
                          GestureDetector(
                            onTap: () {
                              // Call the logout method from AuthProvider
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: TColors.white,
                                    title: const Text("Delete Account"),
                                    content: Text("Are you sure you want to Proceed?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          TColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style:
                                          TextStyle(color: TColors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                  side:BorderSide(color: TColors.secondaryColor),
                                          backgroundColor:
                                          TColors.secondaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const DeleteAccountScreen()),
                                          );
                                        },
                                        child: Text("Proceed",
                                            style: TextStyle(
                                                color: TColors.white)),
                                      ),
                                    ],
                                  );
                                },
                              );
                              // Navigate back to the login screen
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(6.0),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Iconsax.trash,
                                        color: TColors.primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: TSizes.sm,
                                    ),
                                    Text("Delete Account"),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: TColors.primaryColor,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),

                          // SizedBox(height: 10),
                          Divider(
                            color: TColors.primaryColor,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: TColors.white,
                                    title: Text("Logout"),
                                    content: Text(
                                        "Are you sure you want to logout?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: TColors.primaryColor
                                              .withOpacity(0.1),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: TColors.primaryColor),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side:
                                              BorderSide(color: TColors.error),
                                          backgroundColor:
                                              TColors.error.withOpacity(0.1),
                                        ),
                                        onPressed: () {
                                          // Perform logout action here
                                          // For example: navigate to login screen
                                          Navigator.of(context).pop();
                                          authProvider.logout();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                            (route) =>
                                                false, // This removes all routes in the stack
                                          );
                                        },
                                        child: Text("Logout",
                                            style: TextStyle(
                                                color: TColors.error)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
