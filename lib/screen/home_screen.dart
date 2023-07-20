import 'dart:math';

import 'package:flutter/material.dart';
import 'package:npf_meeting/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

//Generate userId with 6 digit length
//Generate conferenceId with 10 digit length
final String userId = Random().nextInt(900000 + 100000).toString();
final String ramdomConferenceId =
    (Random().nextInt(1000000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0');
const imageSrc =
    'https://50wheel.com/wp-content/uploads/2020/03/9-questions-to-ask-about-web-conferencing-software-1620x800.png';
//'https://www.zegocloud.com/_nuxt/img/pic_videoconference@2x.c50d1d2.png';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final conferenceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Button styel
    var buttonStyles = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primayContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      fixedSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageSrc,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            const SizedBox(height: 20),
            Text(
              'Your UserId: $userId',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Test meeeting with 2 devices or more!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 20,
              keyboardType: TextInputType.number,
              controller: conferenceIdController,
              decoration: const InputDecoration(
                labelText: 'Room ID!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyles,
                    child: const Text('Join Meeting'),
                    onPressed: () => goMeetingPage(
                      context,
                      conferenceId: conferenceIdController.text,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: buttonStyles,
                    child: const Text('New Meeting'),
                    onPressed: () => goMeetingPage(
                      context,
                      conferenceId: ramdomConferenceId,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //Go to meeting page
  goMeetingPage(BuildContext context, {required String conferenceId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoScreen(
          conferenceID: conferenceId,
        ),
      ),
    );
  }
}

class VideoScreen extends StatelessWidget {
  final String conferenceID;

  VideoScreen({
    super.key,
    required this.conferenceID,
  });

  //Read AppID and AppSign for .env file. Make sure to replace with your own
  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Room ID: $conferenceID',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      )),
      body: ZegoUIKitPrebuiltVideoConference(
        appID: appID,
        appSign: appSign,
        conferenceID: conferenceID,
        userID: userId,
        userName: 'UserName_$userId',
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}
