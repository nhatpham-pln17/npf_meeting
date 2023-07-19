import 'dart:math';

import 'package:flutter/material.dart';
import 'package:npf_meeting/screen/video_screen.dart';
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
    'https://www.zegocloud.com/_nuxt/img/pic_videoconference@2x.c50d1d2.png';

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
            Text('Your UserId: $userId'),
            const Text('Test meeeting with 2 devices or more!'),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 20,
              keyboardType: TextInputType.number,
              controller: conferenceIdController,
              decoration: const InputDecoration(
                labelText: 'Join a meeting by Input and Conference ID!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
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
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
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
