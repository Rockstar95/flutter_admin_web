import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:flutter_admin_web/utils/my_print.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/messages/messages_bloc.dart';
import 'package:flutter_admin_web/framework/common/device_config.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';

import '../common/bottomsheet_drager.dart';

//import 'package:signalr_client/hub_connection_builder.dart';
//import 'package:signalr_client/itransport.dart';
//import 'package:signalr_flutter/signalr_flutter.dart';

class SendIcon extends StatelessWidget {
  const SendIcon({
    Key? key,
    required this.controller,
    required this.toUserId,
    required this.messageBloc,
    required this.appBloc,
    required this.chatRoom,
  }) : super(key: key);

  final TextEditingController controller;
  final String toUserId;
  final MessagesBloc messageBloc;
  final AppBloc appBloc;
  final String chatRoom;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
            top: deviceData.screenHeight * 0.01,
            bottom: deviceData.screenHeight * 0.01,
            right: deviceData.screenWidth * 0.02),
        child: InkResponse(
          child: Icon(
            FontAwesomeIcons.solidPaperPlane,
            // color: Color(int.parse("0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
            color: AppColors.getAppButtonBGColor(),
            size: deviceData.screenWidth * 0.065,
          ),
          onTap: () {
            if (controller.text.trim().isNotEmpty) {
              messageBloc.add(SendMessageEvent(
                  message: controller.text,
                  toUserId: toUserId,
                  markAsRead: true,
                  chatRoom: chatRoom));
              controller.text = '';
              /*
              var token = await sharePref_getString(sharedPref_bearer);
              var strUserID = await sharePref_getString(sharedPref_userid);
              var strSiteID = await sharePref_getString(sharedPref_siteid);
              var strLanguage = await sharePref_getString(sharedPref_AppLocale);
              print('tokenval $token');

              Map<String, String> auth;

              auth = {
                // "content-type": "application/json",
                "ClientURL": ApiEndpoints.mainSiteURL,
                "Authorization": 'Bearer $token',
                ApiEndpoints.allowfromExternalHostKey: 'allow',
                "UserID": '$strUserID',
                "SiteID": '$strSiteID',
                "Locale": '$strLanguage',
              };
              SignalR signalR = SignalR(
                  ApiEndpoints.mainSiteURL + '/signalr', "ChatHub",
                  transport: Transport.ServerSentEvents,
                  headers: auth,
                  statusChangeCallback: (status) => print(status),
                  hubMethods: ['ReceievePrivateMessage'],
                  hubCallback: (methodName, message) =>
                      print('MethodName = $methodName, Message = $message'));
              signalR.connect();
              signalR.reconnect();

              await signalR
                  .invokeMethod<dynamic>("ReceievePrivateMessage")
                  .catchError((error) {
                print(error.toString());
              });
              return;
              */
              /*
              final httpOptions = new HttpConnectionOptions(
                  logger: transportProtLogger,
                  transport: HttpTransportType.ServerSentEvents);

              final hubConnection = HubConnectionBuilder()
                  .withUrl(ApiEndpoints.mainSiteURL + '/signalr',
                      transportTyp: HttpTransportType.ServerSentEvents,
                      options: HttpConnectionOptions)
                  .build();

              //hubConnection.start();
              await hubConnection.start();
              */

// Creates the connection by using the HubConnectionBuilder.
              //httpOptions.re = ;
              // var hasd = MessageHeaders();
              // hasd.setHeaderValue('name', 'value');
              // var sadasd = AccessTokenFactory;

              // HttpConnectionOptions(httpClient:  )
              // final httpConnections =
              //     new HttpConnection(ApiEndpoints.mainSiteURL, options: hasd);
//
//               httpConnections
//               SignalRHttpRequest(headers: hasd);
//               final hubConnection = HubConnectionBuilder()
//                   .withUrl(ApiEndpoints.mainSiteURL, options: httpOptions)
//                   .configureLogging(hubProtLogger)
//                   .build();
// // When the connection is closed, print out a message to the console.
//               await hubConnection.start();
//               final connection = HubConnectionBuilder()
//                   .withUrl(
//                       'https://flutterapi.instancy.com/signalr/',
//                       HttpConnectionOptions(
//                         logging: (level, message) => print(message),
//                       ))
//                   .build();
//
//               await connection.start();

              // connection.on('ReceiveMessage', (message) {
              //   print(message.toString());
              // });
              //
              // await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
              //ChatPageViewModel().openChatConnection();
            }
          },
        ),
      ),
    );
  }
}

class AttachmentIcon extends StatelessWidget {
  const AttachmentIcon({
    Key? key,
    required this.controller,
    required this.toUserId,
    required this.appBloc,
    required this.messageBloc,
    required this.chatRoom,
  }) : super(key: key);

  final AppBloc appBloc;
  final TextEditingController controller;
  final String toUserId;
  final MessagesBloc messageBloc;
  final String chatRoom;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
            top: deviceData.screenHeight * 0.01,
            bottom: deviceData.screenHeight * 0.01,
            right: deviceData.screenWidth * 0.02),
        child: InkResponse(
          child: Icon(
            Icons.attach_file_outlined,
            color:AppColors.getAppTextColor().withOpacity(0.5),
            size: deviceData.screenWidth * 0.065,
          ),
          onTap: () async {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return Container(
                    color: Color(int.parse(
                        "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const BottomSheetDragger(),
                          ListTile(
                              leading: Icon(
                                Icons.image,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              ),
                              title: Text(
                                'Image',
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                openFile(MessageType.Image);
                              }),
                          ListTile(
                              leading: Icon(
                                Icons.videocam_rounded,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              ),
                              title: Text(
                                'Video',
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                openFile(MessageType.Video);
                              }),
                          ListTile(
                              leading: Icon(
                                Icons.audiotrack_outlined,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              ),
                              title: Text(
                                'Audio',
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                openFile(MessageType.Audio);
                              }),
                          ListTile(
                              leading: Icon(
                                Icons.file_copy_rounded,
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                              ),
                              title: Text(
                                'Documents',
                                style: TextStyle(
                                    color: Color(int.parse(
                                        "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                openFile(MessageType.Doc);
                              })
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  openFile(MessageType msgType) async {
    // if (_pickingType == FileType.custom) {
    // }
    FileType pickingType = FileType.image;
    Uint8List? fileBytes;
    String fileName;

    var extension = '';
    switch (msgType) {
      case MessageType.Image:
        pickingType = FileType.image;
        break;
      case MessageType.Audio:
        pickingType = FileType.custom;
        extension = "mp3,wav,3gp,webm";
        break;
      case MessageType.Video:
        pickingType = FileType.video;
        break;
      case MessageType.Doc:
        pickingType = FileType.custom;
        extension = "pdf,doc,docx,xlsx,xls";
        break;
      default:
        break;
      //   _pickingType = FileType.image;
    }
    try {
      // var _paths = await FilePicker.platform.pickFiles(
      //     type: _pickingType, allowMultiple: false, allowedExtensions: []);
      var paths = (await FilePicker.platform.pickFiles(
        type: pickingType,
        allowMultiple: false,
        allowedExtensions: (extension.isNotEmpty)
            ? extension.replaceAll(' ', '').split(',')
            : null,
      ));
      //     ?.files;
      var files = paths?.files ?? [];
      if(files.isNotEmpty) {
        fileBytes = (files.first.bytes);
        fileName = files.first.name;
        uploadFile(msgType, fileName, fileBytes);
      }
    }
    on PlatformException catch (e) {
      MyPrint.printOnConsole("Unsupported operation$e");
    }
    catch (ex) {
      MyPrint.printOnConsole(ex);
    }
  }

  Future uploadFile(MessageType msgType, String fileName, Uint8List? fileBytes) async {
    if (fileBytes == null || fileName.isEmpty) {
      return;
    }

    messageBloc.add(SendAttachmentEvent(
        fileBytes: fileBytes,
        fileName: fileName,
        toUserId: toUserId,
        msgType: msgType,
        chatRoom: chatRoom));
  }
}

// class ChatPageViewModel {
// // Properties
//   String _serverUrl =
//       "https://flutterapi.instancy.com/signalr/"; //ApiEndpoints.mainSiteURL;
//   HubConnection _hubConnection;
//
//   // List<ChatMessage> _chatMessages;
//   // static const String chatMessagesPropName = "chatMessages";
//   // List<ChatMessage> get chatMessages => _chatMessages;
//
//   bool _connectionIsOpen;
//   static const String connectionIsOpenPropName = "connectionIsOpen";
//   bool get connectionIsOpen => _connectionIsOpen;
//   set connectionIsOpen(bool value) {
//     updateValue(connectionIsOpenPropName, _connectionIsOpen, value,
//         (v) => _connectionIsOpen = v);
//   }
//
//   // String _userName;
//   // static const String userNamePropName = "userName";
//   // String get userName => _userName;
//   // set userName(String value) {
//   //   //updateValue(userNamePropName, _userName, value, (v) => _userName = v);
//   // }
//
//   @protected
//   bool updateValue<TPropertyType>(
//       String propertyName,
//       TPropertyType currentValue,
//       TPropertyType newValue,
//       SetValue<TPropertyType> setNewValue) {
//     assert(setNewValue != null);
//
//     if (currentValue == newValue) {
//       return false;
//     }
//     setNewValue(newValue);
//     //notifyPropertyChanged(propertyName);
//     return true;
//   }
//
// // Methods
//
//   ChatPageViewModel() {
//     //_serverUrl = kChatServerUrl + "/Chat";
//     //_chatMessages = List<ChatMessage>();
//     _connectionIsOpen = false;
//     // _userName = "Fred";
//
//     openChatConnection();
//   }
//
//   Future<void> openChatConnection() async {
//     if (_hubConnection == null) {
//       _hubConnection = HubConnectionBuilder().withUrl(_serverUrl).build();
//       _hubConnection.onclose((error) => connectionIsOpen = false);
//       _hubConnection.on("OnMessage", _handleIncommingChatMessage);
//     }
//
//     if (_hubConnection.state != HubConnectionState.Connected) {
//       _connectionIsOpen = true;
//       await _hubConnection.start();
//     }
//     // if (_hubConnection.state != HubConnectionState.Connected) {
//     //   print('passsdasd');
//     //   await _hubConnection.start();
//     //   connectionIsOpen = true;
//     // }
//   }
//
//   Future<void> sendChatMessage(String chatMessage) async {
//     if (chatMessage == null || chatMessage.length == 0) {
//       return;
//     }
//     await openChatConnection();
//     //_hubConnection.invoke("Send", args: <Object>[userName, chatMessage] );
//   }
//
//   void _handleIncommingChatMessage(List<Object> args) {
//     final String senderName = args[0];
//     final String message = args[1];
//     // _chatMessages.add( ChatMessage(senderName, message));
//     // notifyPropertyChanged(chatMessagesPropName);
//   }
// }
//
// class PropertyChangedEvent {
//   // Properties
//
//   final Object sender;
//
//   final String propertyName;
//
// // Methods
//   const PropertyChangedEvent(this.sender, this.propertyName);
// }
//
// typedef void SetValue<TValue>(TValue value);
//
// abstract class ViewModel {
//   // Properties
//
//   // @protected
//   // final PublishSubject<PropertyChangedEvent> propertyChanges;
//
//   // Methods
//
//   // ViewModel() : propertyChanges = PublishSubject<PropertyChangedEvent>();
//
//   // @protected
//   // void notifyPropertyChanged(String propertyName) {
//   //   propertyChanges.add(PropertyChangedEvent(this, propertyName));
//   // }
// /*
//   Observable<PropertyChangedEvent> whenPropertiesChanged(List<String> propertyNames) {
//     assert(propertyNames != null || propertyNames.length != 0);
//
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || propertyNames.indexOf(event.propertyName) != -1)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<PropertyChangedEvent> sink) {
//       sink.add(value);
//     }));
//   }
//
//   Observable<void> whenPropertiesChangedHint(List<String> propertyNames) {
//     assert(propertyNames != null || propertyNames.length != 0);
//
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || propertyNames.indexOf(event.propertyName) != -1)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<void> sink) {
//       sink.add(null);
//     }));
//   }
//
//   Observable<PropertyChangedEvent> whenPropertyChanged(String propertyName) {
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || event.propertyName == propertyName)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<PropertyChangedEvent> sink) {
//       sink.add(value);
//     }));
//   }
//
//   Observable whenPropertyChangedHint(String propertyName) {
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || event.propertyName == propertyName)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<void> sink) {
//       sink.add(null);
//     }));
//   }
// */
//   Future<void> viewInitState() {
//     return Future<void>.value();
//   }
//
//   Future<void> viewDispose() {
//     return Future<void>.value();
//   }
//
//   void dispose() {
//     //propertyChanges.close();
//   }
// }

// class ChatPageViewModel {
// // Properties
//   String _serverUrl =
//       "https://flutterapi.instancy.com/signalr/"; //ApiEndpoints.mainSiteURL;
//   HubConnection _hubConnection;
//
//   // List<ChatMessage> _chatMessages;
//   // static const String chatMessagesPropName = "chatMessages";
//   // List<ChatMessage> get chatMessages => _chatMessages;
//
//   bool _connectionIsOpen;
//   static const String connectionIsOpenPropName = "connectionIsOpen";
//   bool get connectionIsOpen => _connectionIsOpen;
//   set connectionIsOpen(bool value) {
//     updateValue(connectionIsOpenPropName, _connectionIsOpen, value,
//         (v) => _connectionIsOpen = v);
//   }
//
//   // String _userName;
//   // static const String userNamePropName = "userName";
//   // String get userName => _userName;
//   // set userName(String value) {
//   //   //updateValue(userNamePropName, _userName, value, (v) => _userName = v);
//   // }
//
//   @protected
//   bool updateValue<TPropertyType>(
//       String propertyName,
//       TPropertyType currentValue,
//       TPropertyType newValue,
//       SetValue<TPropertyType> setNewValue) {
//     assert(setNewValue != null);
//
//     if (currentValue == newValue) {
//       return false;
//     }
//     setNewValue(newValue);
//     //notifyPropertyChanged(propertyName);
//     return true;
//   }
//
// // Methods
//
//   ChatPageViewModel() {
//     //_serverUrl = kChatServerUrl + "/Chat";
//     //_chatMessages = List<ChatMessage>();
//     _connectionIsOpen = false;
//     // _userName = "Fred";
//
//     openChatConnection();
//   }
//
//   Future<void> openChatConnection() async {
//     if (_hubConnection == null) {
//       _hubConnection = HubConnectionBuilder().withUrl(_serverUrl).build();
//       _hubConnection.onclose((error) => connectionIsOpen = false);
//       _hubConnection.on("OnMessage", _handleIncommingChatMessage);
//     }
//
//     if (_hubConnection.state != HubConnectionState.Connected) {
//       _connectionIsOpen = true;
//       await _hubConnection.start();
//     }
//     // if (_hubConnection.state != HubConnectionState.Connected) {
//     //   print('passsdasd');
//     //   await _hubConnection.start();
//     //   connectionIsOpen = true;
//     // }
//   }
//
//   Future<void> sendChatMessage(String chatMessage) async {
//     if (chatMessage == null || chatMessage.length == 0) {
//       return;
//     }
//     await openChatConnection();
//     //_hubConnection.invoke("Send", args: <Object>[userName, chatMessage] );
//   }
//
//   void _handleIncommingChatMessage(List<Object> args) {
//     final String senderName = args[0];
//     final String message = args[1];
//     // _chatMessages.add( ChatMessage(senderName, message));
//     // notifyPropertyChanged(chatMessagesPropName);
//   }
// }
//
// class PropertyChangedEvent {
//   // Properties
//
//   final Object sender;
//
//   final String propertyName;
//
// // Methods
//   const PropertyChangedEvent(this.sender, this.propertyName);
// }
//
// typedef void SetValue<TValue>(TValue value);
//
// abstract class ViewModel {
//   // Properties
//
//   // @protected
//   // final PublishSubject<PropertyChangedEvent> propertyChanges;
//
//   // Methods
//
//   // ViewModel() : propertyChanges = PublishSubject<PropertyChangedEvent>();
//
//   // @protected
//   // void notifyPropertyChanged(String propertyName) {
//   //   propertyChanges.add(PropertyChangedEvent(this, propertyName));
//   // }
// /*
//   Observable<PropertyChangedEvent> whenPropertiesChanged(List<String> propertyNames) {
//     assert(propertyNames != null || propertyNames.length != 0);
//
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || propertyNames.indexOf(event.propertyName) != -1)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<PropertyChangedEvent> sink) {
//       sink.add(value);
//     }));
//   }
//
//   Observable<void> whenPropertiesChangedHint(List<String> propertyNames) {
//     assert(propertyNames != null || propertyNames.length != 0);
//
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || propertyNames.indexOf(event.propertyName) != -1)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<void> sink) {
//       sink.add(null);
//     }));
//   }
//
//   Observable<PropertyChangedEvent> whenPropertyChanged(String propertyName) {
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || event.propertyName == propertyName)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<PropertyChangedEvent> sink) {
//       sink.add(value);
//     }));
//   }
//
//   Observable whenPropertyChangedHint(String propertyName) {
//     return propertyChanges
//         .where((event) => isBlank(event.propertyName) || event.propertyName == propertyName)
//         .transform(StreamTransformer.fromHandlers(handleData: (PropertyChangedEvent value, EventSink<void> sink) {
//       sink.add(null);
//     }));
//   }
// */
//   Future<void> viewInitState() {
//     return Future<void>.value();
//   }
//
//   Future<void> viewDispose() {
//     return Future<void>.value();
//   }
//
//   void dispose() {
//     //propertyChanges.close();
//   }
// }
