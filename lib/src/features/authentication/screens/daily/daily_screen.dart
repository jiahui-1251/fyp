import 'package:flutter/material.dart';
import 'package:fyp/src/features/authentication/screens/daily/add_mood_screen.dart';
import 'package:fyp/src/features/authentication/screens/daily/daily_challenge_controller.dart';
import 'package:get/get.dart';
import 'package:fyp/src/constants/colors.dart';
import 'package:fyp/src/constants/sizes.dart';
import 'package:fyp/src/constants/text_strings.dart';
import 'package:fyp/src/features/authentication/screens/widgets/page_title_widget.dart';
import 'package:fyp/src/features/authentication/screens/daily/widget/challenge_tile_widget.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  _DailyScreenState createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  DateTime getDateForPage(int page) {
    final today = DateTime.now();
    return today.add(Duration(days: 7 * page));
  }

  List<DateTime> getDaysOfWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dailyChallengeController = Get.put(DailyChallengeController());

    return SafeArea(
      child: Scaffold(
        appBar: PageTitleWidget(title: tDaily),
        body: Obx(() {
          if (dailyChallengeController.userChallenge.value == null || dailyChallengeController.dailyChallenges.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Daily Challenges",
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: tFormHeight - 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              // Progress Bar
                              child: Container(
                                height: 20.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: LinearProgressIndicator(
                                    value: dailyChallengeController.userChallenge.value!.NumCompletion / 3,
                                    color: tYellowColor,
                                    backgroundColor: tGreyColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Refresh or completed button
                            dailyChallengeController.userChallenge.value!.NumCompletion == 3
                                ? ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(15),
                                      backgroundColor: tGreenColor,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      await dailyChallengeController.refreshChallenges();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(15),
                                      backgroundColor: tOrangeColor,
                                    ),
                                    child: Icon(
                                      Icons.refresh_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      const SizedBox(height: tFormHeight - 10),

                      // Challenge Widget
                      ...dailyChallengeController.dailyChallenges.map((challenge) {
                        int index = dailyChallengeController.userChallenge.value!.ChallengeID.indexOf(challenge.ChallengeID);
                        if (index == -1) {
                          return SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: tFormHeight - 15),
                          child: ChallengeTile(
                            title: challenge.ChallengeTitle,
                            description: challenge.ChallengeDescription,
                            benefitDescription: challenge.ChallengeBenefit,
                            isChecked: dailyChallengeController.userChallenge.value!.ChallengeStatus[index],
                            onChanged: (bool? value) {
                              dailyChallengeController.updateChallengeStatus(index, value!);
                            },
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: tFormHeight),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Mood Tracker",
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "${getDateForPage(_currentPage).month} ${getDateForPage(_currentPage).year}",
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 60,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemBuilder: (context, pageIndex) {
                            final date = getDateForPage(pageIndex);
                            final daysOfWeek = getDaysOfWeek(date);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: daysOfWeek.map((date) {
                                return Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => AddMoodScreen()); // Navigate to add_mood_screen.dart
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1],
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 3),
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: tGreyColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${date.day}",
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: tFormHeight),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
