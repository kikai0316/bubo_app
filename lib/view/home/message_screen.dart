// import 'dart:convert';
// import 'package:bubu_app/component/text.dart';
// import 'package:bubu_app/constant/color.dart';
// import 'package:bubu_app/model/user_data.dart';
// import 'package:bubu_app/utility/utility.dart';
// import 'package:chatview/chatview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class MessageScreenPage extends HookConsumerWidget {
//   const MessageScreenPage({
//     super.key,
//     required this.partnerData,
//     required this.myData,
//   });
//   final UserData partnerData;
//   final UserData myData;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final safeAreaHeight = safeHeight(context);
//     final safeAreaWidth = MediaQuery.of(context).size.width;
//     final base64String = base64Encode(myData.imgList.first);
//     final messageList = useState<List<Message>>([
//       Message(
//         id: '1',
//         message: "Hi",
//         createdAt: DateTime.now().subtract(
//           const Duration(hours: 1),
//         ),
//         sendBy: "x1",
//       ),
//       Message(
//         id: '2',
//         message: "Hello",
//         createdAt: DateTime.now(),
//         sendBy: "x2",
//       ),
//     ]);

//     final user1 = ChatUser(
//       id: "x1",
//       name: 'JJJ',
//       // profilePhoto: 'data:image/png;base64,$base64String',
//     );
//     final user2 = ChatUser(
//       id: 'x2',
//       name: 'XXX',
//       // profilePhoto: null,
//     );
//     final chatController = ChatController(
//       initialMessageList: messageList.value,
//       scrollController: ScrollController(),
//       chatUsers: [
//         user2,
//       ],
//     );
//     void onSendTap(
//       String message,
//       ReplyMessage replyMessage,
//       MessageType? messageType,
//     ) {
//       final message = Message(
//         id: '3',
//         message: "How are you",
//         createdAt: DateTime.now(),
//         sendBy: user1.id,
//         replyMessage: replyMessage,
//       );
//       chatController.addMessage(message);
//     }

//     return Scaffold(
//       backgroundColor: blackColor,
//       appBar: appber(context, partnerData),
//       body: ChatView(
//         currentUser: user1,
//         chatController: chatController,
//         chatViewState: ChatViewState.hasMessages,
//         onSendTap: onSendTap,
//       ),
//     );
//   }

//   PreferredSizeWidget appber(BuildContext context, UserData userData) {
//     final safeAreaWidth = MediaQuery.of(context).size.width;
//     final safeAreaHeight = safeHeight(context);
//     return PreferredSize(
//       preferredSize: Size.fromHeight(safeAreaHeight * 0.09),
//       child: AppBar(
//         backgroundColor: blackColor,
//         elevation: 10,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(0),
//           child: Container(
//             height: 0.5,
//             color: Colors.grey,
//           ),
//         ),
//         title: SizedBox(
//           height: safeAreaHeight * 1,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: safeAreaHeight * 0.05,
//                 height: safeAreaHeight * 0.05,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: MemoryImage(userData.imgList.first),
//                     fit: BoxFit.cover,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               nText(
//                 userData.name,
//                 color: Colors.white,
//                 fontSize: safeAreaWidth / 30,
//                 bold: 700,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
