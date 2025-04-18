import 'package:flutter/material.dart';
import 'package:fyp/src/common_widgets/form/privacy_policy.dart';
import 'package:fyp/src/constants/colors.dart';
import 'package:fyp/src/constants/sizes.dart';
import 'package:fyp/src/constants/text_strings.dart';
import 'package:fyp/src/features/authentication/controllers/authentication_controllers.dart';
import 'package:fyp/src/features/authentication/models/user_model.dart';
import 'package:get/get.dart';

// List of valid TLDs
const List<String> validTlds = [
  'com', 'org', 'net', 'edu', 'gov', 'mil', 'int', 'co', 'io', 'info', 'biz', 'us',
  // Add more TLDs as needed
];

bool isValidEmail(String email) {
  // Basic email validation
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegExp.hasMatch(email)) {
    return false;
  }

  // Extract the TLD from the email
  final domainPart = email.split('@').last;
  final tld = domainPart.split('.').last;

  return validTlds.contains(tld);
}

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final SignUpController controller = Get.put(SignUpController());

  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Type Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                label: Text('User Type'),
                prefixIcon: Icon(
                  Icons.account_circle_outlined,
                  color: tOrangeColor,
                ),
                labelStyle: TextStyle(color: tBlackColor),
              ),
              items: [
                DropdownMenuItem(
                  value: 'User',
                  child: Text(
                    'User',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Counsellor',
                  child: Text(
                    'Counsellor',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.UserType.value = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a user type';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            
            // User Name
            TextFormField(
              focusNode: userNameFocusNode,
              controller: controller.userName,
              decoration: const InputDecoration(
                label: Text(tUserName),
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: tOrangeColor,
                ),
                labelStyle: TextStyle(color: tBlackColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(emailFocusNode);
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            
            // Email
            TextFormField(
              focusNode: emailFocusNode,
              controller: controller.email,
              decoration: const InputDecoration(
                label: Text(tEmail),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: tOrangeColor,
                ),
                labelStyle: TextStyle(color: tBlackColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!isValidEmail(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            
            // Password
            TextFormField(
              focusNode: passwordFocusNode,
              controller: controller.password,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text(tPassword),
                prefixIcon: Icon(
                  Icons.fingerprint_outlined,
                  color: tOrangeColor,
                ),
                labelStyle: TextStyle(color: tBlackColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            
            // Confirm Password
            TextFormField(
              focusNode: confirmPasswordFocusNode,
              controller: controller.confirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text(tConfirmPassword),
                prefixIcon: Icon(
                  Icons.fingerprint_outlined,
                  color: tOrangeColor,
                ),
                labelStyle: TextStyle(color: tBlackColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 30),
            
            // Privacy Policy
            PrivayPolicy(),
            
            // SignUp Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Ensure context is valid before calling signUp
                    controller.signUserUp(context);
                  }
                },
                child: Text(tSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
