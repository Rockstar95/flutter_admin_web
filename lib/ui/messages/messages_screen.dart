// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/messages/messages_bloc.dart';
// import 'package:flutter_admin_web/framework/bloc/mylearning/model/filter/instructer_response.dart';
// import 'package:flutter_admin_web/framework/common/device_config.dart';
//
// import 'messages_header.dart';
// import 'messages_list.dart';
//
// class MessagesScreen extends StatefulWidget {
//   final User friend;
//   MessagesScreen({@required this.friend});
//   static String routeID = "MESSAGE_SCREEN";
//
//   @override
//   _MessageScreenState createState() => _MessageScreenState();
// }
//
// class _MessageScreenState extends State<MessagesScreen> {
//   Future<List<Message>> messagesFuture;
//   TextEditingController controller;
//   DeviceData deviceData;
//   bool showMessages = false;
//   MessagesBloc messagesBloc;
//   @override
//   void initState() {
//     //messagesBloc = serviceLocator<MessagesBloc>();
//     controller = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     messagesBloc.close();
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     deviceData = DeviceData.init(context);
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           color: Colors.black,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               MessagesHeader(friend: widget.friend),
//               Expanded(
//                 child: BlocProvider<MessagesBloc>(
//                   create: (context) =>
//                       messagesBloc..add(MessagesStartFetching(widget.friend)),
//                   child: Stack(
//                     children: <Widget>[
//                       //const WhiteFooter(),
//                       MessagesList(friend: widget.friend),
//                       BlocBuilder<MessagesBloc, MessagesState>(
//                         builder: (context, state) {
//                           return state is MessagesLoading
//                               ? const Center(child: CircleProgress())
//                               : state is MessagesLoadFailed &&
//                                       state.failure is NetworkException
//                                   ? TryAgain(
//                                       doAction: () => context
//                                           .bloc<MessagesBloc>()
//                                           .add(MessagesStartFetching(
//                                               widget.friend)))
//                                   : SizedBox.shrink();
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
