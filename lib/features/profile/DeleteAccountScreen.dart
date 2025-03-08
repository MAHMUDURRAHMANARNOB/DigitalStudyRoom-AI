import 'package:digital_study_room/features/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants/colors.dart';
import '../authentication/providers/AuthProvider.dart';
import 'Providers/deleteUserProvider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenMobileState();
}

class _DeleteAccountScreenMobileState extends State<DeleteAccountScreen> {
  String selectedOption = "";
  late int userid;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    userid = authProvider.user?.id ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete Account"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                  "If you need to delete an account, please provide a reason."),
              // Pass the callback to update the selected option
              CheckboxListPage(
                onOptionSelected: (String option) {
                  setState(() {
                    selectedOption = option;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.secondaryColor,
                  side: BorderSide(color: TColors.secondaryColor)
                ),
                onPressed: () {
                  // Print the selected option when the button is pressed
                  print(selectedOption);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: TColors.white,
                        title: Column(
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              size: 50,
                              color: TColors.secondaryColor,
                            ),
                            const Text(
                              "Are you Sure?",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                              "Your account will be deleted permanently and can never be recovered.",
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[500]),
                              "Ensuring that the user understands the consequences of deleting their account / loss of data, subscriptions, etc.",
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side:BorderSide(color: TColors.tertiaryColor),
                              backgroundColor:
                                  TColors.tertiaryColor.withOpacity(0.1),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Keep Account",
                              style: TextStyle(color: TColors.tertiaryColor),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side:BorderSide(color: TColors.error),
                              backgroundColor:

                                  TColors.error.withOpacity(0.1),
                            ),
                            onPressed: () {
                              Navigator.pop(context);

                              _deleteUser(context, selectedOption);
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: TColors.error),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteUser(BuildContext context, String reason) async {
    final deleteUserProvider =
        Provider.of<DeleteUserProvider>(context, listen: false);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing while deleting
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitThreeInOut(color: TColors.secondaryColor),
              SizedBox(height: 10),
              Text("Deleting your account..."),
            ],
          ),
        );
      },
    );

    bool success = await deleteUserProvider.deleteUser(userid, reason);

    // Close the loader dialog
    Navigator.of(context).pop();

    if (success) {
      // Remove user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clears all stored user data

      // Show success dialog
      _showSuccessDialog(context);
    } else {
      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account. Please try again.')),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('We are so sorry to see you go'),
          content: Text('Your account has been successfully deleted.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Wait a bit before navigating
                Future.delayed(Duration(milliseconds: 2000), () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class CheckboxListPage extends StatefulWidget {
  final Function(String) onOptionSelected;

  const CheckboxListPage({Key? key, required this.onOptionSelected})
      : super(key: key);

  @override
  _CheckboxListPageState createState() => _CheckboxListPageState();
}

class _CheckboxListPageState extends State<CheckboxListPage> {
  final List<String> options = [
    "No longer using the platform",
    "Found a better alternative",
    "Privacy concerns",
    "Difficulty navigating the platform",
    "Account security concerns",
    "Personal reasons",
    "Others"
  ];

  String selectedOption = "";
  bool isOthersSelected = false;
  TextEditingController _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: TColors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(
                    options[index],
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  value: (options[index] == "Others" && isOthersSelected) ||
                      selectedOption == options[index],
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (options[index] == "Others") {
                          isOthersSelected = true;
                          selectedOption = "Others";
                        } else {
                          selectedOption = options[index];
                          isOthersSelected = false;
                          _otherReasonController
                              .clear(); // Clear when not "Others"
                        }
                        // Pass the selected option back to the parent
                        widget.onOptionSelected(selectedOption);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: TColors.secondaryColor,
                  checkColor: Colors.white,
                );
              },
            ),
            if (isOthersSelected)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _otherReasonController,
                  cursorColor: TColors.secondaryColor,
                  decoration: InputDecoration(

                    hintText: 'Please specify your reason to leave us.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: TColors.secondaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = "Others: $value";
                      // Update the selected option when the text changes
                      widget.onOptionSelected(selectedOption);
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
