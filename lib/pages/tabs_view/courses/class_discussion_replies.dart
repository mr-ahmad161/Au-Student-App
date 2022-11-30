import 'dart:async';
import 'dart:convert';
import 'package:aue/model/discussion_reply_model.dart';
import 'package:aue/model/load_group_messages_model.dart';
import 'package:aue/notifiers/app_state_notifier.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/app_colors.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:signalr_client/ihub_protocol.dart';
import 'package:signalr_client/signalr_client.dart';

class ClassDiscussionReplies extends StatefulWidget {
  @override
  _ClassDiscussionRepliesState createState() => _ClassDiscussionRepliesState();
}

class _ClassDiscussionRepliesState extends State<ClassDiscussionReplies> {
  // Future<DiscussionReplyModel> repliesFuture;
  List<Widget> replies = [];
  TextEditingController controller = TextEditingController();
  HubConnection hubConnection;
  final GlobalKey<DashChatState> _dashChatState = GlobalKey<DashChatState>();
  ChatUser currentChatUser;
  List<ChatMessage> chatMessages = List<ChatMessage>();
  Future<LoadGroupMessagesModel> loadGroupMessagesFuture;

  // bool isTyping = false;
  // Timer typingTimer;
  // DateTime lastTypedTime = DateTime(0);
  // double typingDelayMilliseconds = 5000;
  // String typingStatus = '';
  // TextEditingController inputText = TextEditingController();

  @override
  void initState() {
    super.initState();
    this.currentChatUser = this.getCurrentChatUser();
    getReplies();
    initiateHubConnection();
    this.hubConnection.onclose((error) {
      print('OnClose: $error');
    });

    if (this.mounted) {
      this.hubConnection.on('SendMessage', (value) {
        setState(() {
          chatMessages.add(
            ChatMessage(
              text: value[0],
              user: ChatUser(name: value[1], uid: value[2]),
            ),
          );
        });
        print('OnSendMessage: $value');
      });
    }

    this.getGroupMessages();
    // typingTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
    //   this.refreshTypingStatus();
    // });
    //
    // inputText.addListener(() {
    //   if (!_dashChatState.currentState.inputFocusNode.hasFocus) {
    //     this.refreshTypingStatus();
    //   }
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    // this.inputText.dispose();
    // this.typingTimer.cancel();
    super.dispose();
  }

  void getGroupMessages() async {
    final String studentId = context.read<AuthNotifier>().user.studentID;
    final String mergeId = context.read<AppStateNotifier>().selectedSection.mergeId;
    this.loadGroupMessagesFuture = Repository().getGroupMessages(studentId: studentId, groupId: mergeId, scroll: 0);
  }

  // Future<String> _getAccessToken() async {
  //   await Future.delayed(Duration.zero);
  //   return 'bW9iaWxldXNlcjpBdWVkZXYyMDIw';
  // }

  void initiateHubConnection() async {
    try {
      this.hubConnection = HubConnectionBuilder().withUrl('https://integrations.aue.ae/chatapi/MyHub').build();

      await this.hubConnection.start();
      final response = await this.hubConnection.invoke('JoinMyHub', args: [context.read<AuthNotifier>().user.studentID]);
      print('JoinMyHubResponse: $response');
    } catch (e) {
      print('HubConnectionError: $e');
    }
  }

  // void refreshTypingStatus() {
  //   if (!_dashChatState.currentState.inputFocusNode.hasFocus ||
  //       _dashChatState.currentState.textController.text.isEmpty ||
  //       _dashChatState.currentState.textController.text == '' ||
  //       DateTime.now().millisecondsSinceEpoch - lastTypedTime.millisecondsSinceEpoch > typingDelayMilliseconds) {
  //     setState(() {
  //       this.typingStatus = '';
  //     });
  //   } else {
  //     setState(() {
  //       this.typingStatus = 'Typing...';
  //     });
  //   }
  // }
  //
  // void updateLastTypedTime() {
  //   this.lastTypedTime = DateTime.now();
  // }

  getReplies() {
    // repliesFuture = null;
    // final discussionId = context
    //     .read<AppStateNotifier>()
    //     .selectedDiscussion
    //     .id;
    // repliesFuture = Repository().getDiscussionsReplies(discussionId);
    // if (mounted) setState(() {});
  }

  addReply() async {
    if (controller.text.isEmpty) return;
    // final discussionId = context
    //     .read<AppStateNotifier>()
    //     .selectedDiscussion
    //     .id;
    final user = context.read<AuthNotifier>().user;
    //
    // await Repository().addDiscussionReply(discussionId, controller.text, user.studentID);
    //
    ReplyModel replyModel = ReplyModel(controller.text, user.fullName, DateTime.now(), '');

    setState(() {
      replies.add(SentWidget(replyModel: replyModel));
    });

    controller.clear();
  }

  void invokeSendMessage() async {
    try {
      final response = await this.hubConnection.invoke('SendMessage', args: [
        _dashChatState.currentState.textController.text,
        currentChatUser.name,
        currentChatUser.uid,
        context.read<AppStateNotifier>().selectedSection.mergeId,
        null,
        2
      ]);
      print('SendMessageResponse: $response');
    } catch (e) {
      print('SendMessageError: $e');
    }
  }

  ChatUser getCurrentChatUser() {
    final user = context.read<AuthNotifier>().user;
    return ChatUser(
      uid: user.studentID,
      name: user.fullName,
      firstName: user.firstName,
      lastName: user.lastName,
    );
  }

  void unusedWidgets() {
    final widgets = [
      Visibility(
        visible: false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(right: 24.0, left: 24.0, bottom: 26.0, top: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20.0,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 24.0,
                  bottom: 14.0,
                  left: 22.0,
                  right: 14.0,
                ),
                child: Row(
                  children: [
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        Visibility(
                          visible: false,
                          child: Container(
                            height: 42.0,
                            width: 42.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              // image: DecorationImage(
                              //   image: MemoryImage(
                              //     base64Decode(classDiscussionModel.imageThumbnail),
                              //   ),
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -2.0,
                          right: -2.0,
                          child: Container(
                            height: 11.0,
                            width: 11.0,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 14.0),
                    Expanded(
                      child: Text(
                        '${'Title'}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: DS.setSP(16),
                        ),
                      ),
                    ),
                    Text(
                      // '${classDiscussionModel.datePosted.day}-${classDiscussionModel.datePosted.month}-${classDiscussionModel.datePosted.year}',
                      'Date',
                      style: TextStyle(
                        color: AppColors.blueGrey,
                        fontWeight: FontWeight.w300,
                        fontSize: DS.setSP(13),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width,
                color: AppColors.blueGrey.withOpacity(0.6),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 11.5,
                  bottom: 10.5,
                  left: 22.0,
                  right: 14.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'Content'}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.blueGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: DS.setSP(13),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ImageIcon(
                      AssetImage(Images.star),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible: false,
        child: Expanded(
          child: FutureBuilder(
            future: null,
            builder: (context, AsyncSnapshot<DiscussionReplyModel> snapshot) {
              if (snapshot.isLoading) {
                return LoadingWidget();
              }

              if (snapshot.hasError && snapshot.error != null) {
                return CustomErrorWidget(
                  err: snapshot.error,
                  onRetryTap: () => getReplies(),
                );
              }

              // replies.addAll(snapshot.data.replies
              //     .map((e) => e.studentName == user.fullName ? SentWidget(replyModel: e) : ReceivedWidget(replyModel: e))
              //     .toList());

              return ListView(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: replies,
              );
            },
          ),
        ),
      ),
      // ListView(
      //   primary: false,
      //   shrinkWrap: true,
      //   padding: EdgeInsets.zero,
      //   children: replies,
      // ),
      Visibility(
        visible: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 14.0),
          child: Row(
            children: [
              ImageIcon(
                AssetImage(Images.emoji),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: AppColors.blackGrey,
                    fontSize: DS.setSP(17),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0.0),
                    hintText: 'Type here...',
                    hintStyle: TextStyle(
                      color: AppColors.blackGrey,
                      fontSize: DS.setSP(17),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Container(
                height: 24.0,
                width: 0.5,
                color: Color(0xFFADADAD),
              ),
              SizedBox(width: 24.0),
              Icon(
                Icons.add,
                color: Color(0xFF8C8C8C),
              ),
              SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => addReply(),
                child: ImageIcon(
                  AssetImage(Images.send),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final classDiscussionModel = context.select((AppStateNotifier stateNotifier) => stateNotifier.selectedDiscussion);

    final user = context.select((AuthNotifier authNotifier) => authNotifier.user);

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 44.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: AppColors.primary),
                Expanded(
                  child: Text(
                    "Class Discussion",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(20),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: ImageIcon(
                    AssetImage(Images.bell),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<LoadGroupMessagesModel>(
              future: loadGroupMessagesFuture,
              builder: (BuildContext context, AsyncSnapshot<LoadGroupMessagesModel> snapshot) {
                if (snapshot.isLoading) {
                  return LoadingWidget();
                }
                if (snapshot.hasError && snapshot.error != null) {
                  return Center(
                    child: const Text('Error occurred!'),
                  );
                }
                final List<ChatMessage> messages = snapshot.data.item2.map((message) {
                  return ChatMessage(
                    text: message.text,
                    user: ChatUser(
                      uid: message.fromId,
                      name: message.fromName,
                    ),
                    createdAt: message.createdDate,
                  );
                }).toList();
                this.chatMessages.addAll(messages);
                this.chatMessages.sort((a, b) => a.createdAt.isAfter(b.createdAt) ? 1 : 0);
                return Expanded(
                  child: DashChat(
                    key: _dashChatState,
                    user: currentChatUser,
                    messages: chatMessages,
                    onSend: (ChatMessage chatMessage) {
                      chatMessages.add(chatMessage);
                      this.invokeSendMessage();
                      print(chatMessage.toJson());
                    },
                    timeFormat: DateFormat('hh:mm aaa'),
                    inputDecoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(0.0),
                      hintText: 'Type here...',
                      hintStyle: TextStyle(
                        color: AppColors.blackGrey,
                        fontSize: DS.setSP(17),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class SentWidget extends StatelessWidget {
  final ReplyModel replyModel;

  const SentWidget({Key key, @required this.replyModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 17.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 24.0),
          Text(
            '${DateFormat.jm().format(replyModel.datePosted)}',
            style: TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w300,
              fontSize: DS.setSP(13),
            ),
          ),
          SizedBox(width: 14.0),
          ImageIcon(
            AssetImage(Images.sentSeen),
            color: AppColors.primary,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 24.0, left: 4.0, top: 0.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      bottom: 8.0,
                      left: 6.0,
                      right: 14.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          overflow: Overflow.visible,
                          children: [
                            Container(
                              height: 42.0,
                              width: 42.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(replyModel.imageThumbnail),
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -2.0,
                              right: -2.0,
                              child: Container(
                                height: 11.0,
                                width: 11.0,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 14.0),
                        Expanded(
                          child: Text(
                            '${replyModel.studentName}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: DS.setSP(13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 11.5,
                      bottom: 10.5,
                      left: 6.0,
                      right: 14.0,
                    ),
                    child: Text(
                      '${replyModel.replyText}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: DS.setSP(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceivedWidget extends StatelessWidget {
  final ReplyModel replyModel;

  const ReceivedWidget({Key key, @required this.replyModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 17.0,
        left: 24.0,
        right: 24.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                '${replyModel.replyText}',
                style: TextStyle(
                  color: AppColors.blueGrey,
                  fontSize: DS.setSP(16),
                ),
              ),
            ),
          ),
          SizedBox(width: 11.0),
          Text(
            '${DateFormat.jm().format(replyModel.datePosted)}',
            style: TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w300,
              fontSize: DS.setSP(13),
            ),
          ),
        ],
      ),
    );
  }
}
