import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_jpt/constants/constants.dart';
import 'package:chat_jpt/services/assets.manage.dart';
import 'package:chat_jpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key,
    this.shouldAnimate = false,
    required this.chatIndex, required this.msg})
      : super(key: key);
  final String msg;
  final int chatIndex;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.openAiLogo,
                  height: 30.0,
                  width: 30.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    child: chatIndex == 0?TextWidget(
                  label: msg,
                ):shouldAnimate?
                        DefaultTextStyle(
                            style:  const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              repeatForever: false,
                              displayFullTextOnTap: true,
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText(msg.trim(),),
                              ],
                            )):Text(
                      msg.trim(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
}
