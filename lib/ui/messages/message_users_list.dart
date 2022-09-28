import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/messages/chat_user_response.dart';
import 'package:flutter_admin_web/framework/bloc/messages/messages_bloc.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/helpers/ApiEndpoints.dart';
import 'package:flutter_admin_web/framework/helpers/utils.dart';
import 'package:flutter_admin_web/framework/repository/messages/messages_repository_builder.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';
import 'package:flutter_admin_web/ui/common/common_widgets.dart';
import 'package:flutter_admin_web/ui/common/ins_search_textfield.dart';
import 'package:flutter_admin_web/ui/messages/messages_list.dart';
import 'package:flutter_admin_web/ui/messages/user_filter.dart';

class MessageUsersList extends StatefulWidget {
  @override
  _MessageUsersListState createState() => _MessageUsersListState();
}

class _MessageUsersListState extends State<MessageUsersList> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  bool showFilterView = false;
  late MessagesBloc _messagesBloc;
  late TextEditingController _controller;

  //String selectedDropDown = 'Select';

  @override
  void initState() {
    _messagesBloc = MessagesBloc(
        messagesRepository: MessagesRepositoryBuilder.repository());
    _messagesBloc.isFirstLoading = true;
    _messagesBloc.add(GetAllUserListEvent());
    _controller = TextEditingController(text: _messagesBloc.searchString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.getAppBGColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.getAppBGColor(),
          appBar: getAppbar(),
          body: Container(
            color: AppColors.getAppBGColor(),
            child: BlocConsumer<MessagesBloc, MessagesState>(
              bloc: _messagesBloc,
              listener: (context, state) {
                if (_messagesBloc.isFirstLoading == true && !_messagesBloc.isFirstLoading) {
                  //_loadingOverlay.show(context);
                }
                else {
                  //_loadingOverlay.hide();
                }

                if (state.status == Status.ERROR) {
                  if (state.message == "401") {
                    AppDirectory.sessionTimeOut(context);
                  }
                }
              },
              builder: (context, state) {
                if (_messagesBloc.isFirstLoading == true) {
                  return getCommonLoading();
                }

                return Column(
                  children: [
                    /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                              color: InsColor(appBloc).appBGColor,
                              height: 44,
                              child: Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: InsColor(appBloc).appBGColor,
                                    hint: new Text(selectedDropDown,
                                        style: TextStyle(
                                            color: Color(int.parse(
                                                "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),

                                    //value: mydashboardGamesmodel,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Color(int.parse(
                                            "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                        fontSize: 16),
                                    onChanged: (String newValue) {
                                      setState(() {});
                                    },
                                    items: _messagesBloc.allUsers
                                        .map((e) => e.role)
                                        .toSet()
                                        .toList()
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: TextStyle(
                                                color: Color(int.parse(
                                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")))),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    */
                    getSearchField(),
                    Expanded(
                      child: getMessagesListView(_messagesBloc.usersList),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  AppBar getAppbar() {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.getAppHeaderTextColor(),),
      title: Text(
        appBloc.localstr.myconnectionsHeaderMessagesttitlelabel,
        style: TextStyle(
          color: AppColors.getAppTextColor(),
        ),
      ),
      backgroundColor: AppColors.getAppBGColor(),
      //elevation: 0,
    );
  }

  Widget getSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        color: AppColors.getAppBGColor(),
        height: 44,
        child: InsSearchTextField(
          onTapAction: () {},
          controller: _controller,
          appBloc: appBloc,
          suffixIcon: ((_messagesBloc.searchString.isNotEmpty))
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _messagesBloc.searchString = "";
                      _controller.clear();
                      showFilterView = false;
                    });
                    _messagesBloc.add(SearchUserEvent(''));
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.getAppTextColor(),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MessageUserFilterScreen(
                        messagesBloc: _messagesBloc,
                        appBloc: appBloc,
                      ),
                    ));
                  },
                  icon: Icon(
                    Icons.tune,
                    color: AppColors.getFilterIconColor(),
                  ),
                ),
          onSubmitAction: (value) {
            if (value.toString().length > 0) {
              _messagesBloc.searchString = value.toString();
              setState(() {
                //pageArchiveNumber = 1;
              });
              _messagesBloc.add(SearchUserEvent(value.toString()));
              // connectionsBloc.add(GetPeopleListEvent(
              //     componentID: componentID,
              //     componentInstanceID: componentInstanceID,
              //     pageIndex: pageIndex,
              //     searchText: value.toString(),
              //     filterType: filterType,
              //     contentid: widget.contentId));
            }
          },
        ),
      ),
    );
  }

  Widget getMessagesListView(List<ChatUser> users) {
    return RefreshIndicator(
      onRefresh: () async {
        _messagesBloc.add(GetAllUserListEvent());
      },
      color: AppColors.getAppButtonBGColor(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          ChatUser chatUser = users[index];
          return ChatUserCell(
            value: chatUser,
            appBloc: appBloc,
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagesList(toUser: chatUser)));
              _messagesBloc.add(GetAllUserListEvent());
            },
          );
        },
      ),
    );
  }
}

class ChatUserCell extends StatelessWidget {
  const ChatUserCell({
    Key? key,
    required this.onTap,
    required this.value,
    required this.appBloc,
  }) : super(key: key);

  final void Function() onTap;
  final ChatUser value;
  final AppBloc appBloc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 74,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: InsColor(appBloc).appBGColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 2.0),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(width: 4,),
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xffFDCF09),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  value.profPic.contains('http')
                      ? value.profPic
                      : '${ApiEndpoints.mainSiteURL}${value.profPic}',
                ),
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(value.fullName,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: InsColor(appBloc).appTextColor)),
                  Expanded(
                    child: Text(
                      value.latestMessage,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: AppColors.getAppTextColor().withAlpha(900),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Text(value.role,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: InsColor(appBloc).appTextColor.withAlpha(500))),
            const SizedBox(width: 4,),
          ],
        ),
      ),
    );
  }
}
