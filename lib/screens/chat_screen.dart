
import 'package:chat_jpt/constants/constants.dart';
import 'package:chat_jpt/providers/chat_provider.dart';
import 'package:chat_jpt/services/assets.manage.dart';
import 'package:chat_jpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/models_provider.dart';
import '../services/services.dart';
import '../widgets/chat_widget.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textController;
  late FocusNode focusNode;
  late ScrollController scrollController;
  @override
  void initState() {
    textController = TextEditingController();
    focusNode = FocusNode();
    scrollController = ScrollController();
    super.initState();
  }
  @override
  void dispose() {
   textController.dispose();
   focusNode.dispose();
   scrollController.dispose();
    super.dispose();
  }
   bool _isTyping = false;
  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openAiLogo),
        ),
        title: const Text('ChatGpt'),
        actions: [
          IconButton(onPressed: ()async{
            await Services.showModelSheet(context: context);
          },
              icon: const Icon(Icons.more_vert_rounded,color: Colors.white,))
        ],

      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemCount: chatProvider.chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                      msg: chatProvider.getChatList[index].msg,
                      chatIndex: chatProvider.getChatList[index].chatIndex,
                    shouldAnimate:
                      chatProvider.getChatList.length - 1 == index,
                  );
              },),
            ),
            if(_isTyping)...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size:18
              )
            ],
            const SizedBox(height: 15.0,),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: TextStyle(color: Colors.white),
                        controller: textController,
                        onSubmitted: (value)async{
                          await sendMessageFCT(
                              modelsProvider: modelProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'How can i help you',
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      ),
                    ),
                    IconButton(onPressed: ()async{
                      await sendMessageFCT(
                          modelsProvider: modelProvider,
                          chatProvider: chatProvider);
                    },
                        icon: const Icon(Icons.send,color: Colors.white,),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider
  })
  async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try{
      String msg = textController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      setState(() {});
    }
    catch(e){
      debugPrint('error $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: e.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    }finally{
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }

  void scrollListToEND() {
     scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }
}
