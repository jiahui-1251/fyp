import 'package:flutter/material.dart';
import 'package:fyp/src/constants/colors.dart';
import 'package:fyp/src/constants/colors.dart';
import 'package:fyp/src/constants/image_strings.dart';
import 'package:fyp/src/constants/sizes.dart';
import 'package:fyp/src/constants/text_strings.dart';
import 'package:fyp/src/features/authentication/screens/profile/widgets/profile_screen_menu_widget.dart';
import 'package:fyp/src/features/authentication/screens/profile/profile_settings.dart';
import 'package:fyp/src/features/authentication/screens/profile/update_profile_screen.dart';
import 'package:fyp/src/features/authentication/screens/widgets/page_title_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreenMenu extends StatelessWidget {
  const ProfileScreenMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PageTitleWidget(title: tProfile),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize-20),
            child: Column(
              children: [
                Stack(
                  children: [
                    //Profile Image
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(tProfileImage)),
                      ),
                    ),

                    //Edit button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: tOrangeColor,
                        ),
                        child: const Icon(LineAwesomeIcons.pencil_alt_solid, size:15.0, color: tBlackColor),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  tProfileHeadingUserName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  tProfileSubHeadingEmail,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => Get.to(()=> UpdateProfileScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tOrangeColor,
                      padding: const EdgeInsets.symmetric(vertical: 10)
                    ),
                    child: const Text(
                      tEditProfile,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // MENU
                ProfileMenuWidget(title: tMenu1Settings, icon:LineAwesomeIcons.cog_solid, onPress: () => Get.to(()=> ProfileSettingsScreen())),
                ProfileMenuWidget(title: tMenu2Help, icon:LineAwesomeIcons.hands_helping_solid, onPress: (){}),
                ProfileMenuWidget(title: tMenu3Notifications, icon:LineAwesomeIcons.bell_solid, onPress: (){}),
                const Divider(),
                ProfileMenuWidget(title: tLogout, icon:LineAwesomeIcons.sign_out_alt_solid, onPress: (){}, endIcon: false),
                ProfileMenuWidget(
                  title: "Delete account", 
                  icon:LineAwesomeIcons.sign_out_alt_solid, 
                  onPress: (){}, 
                  endIcon: false,
                  textColor: Colors.red,
                )
              ],
            ),
          ),
        ),

        
      ),
    );
  }
}

