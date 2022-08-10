import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/messages/messages_bloc.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/ui/common/app_colors.dart';

class MessageUserComponent {
  MessageUserComponent({
    required this.roleName,
    required this.check,
  });

  String roleName;
  bool check;
}

class MessageUserFilterScreen extends StatefulWidget {
  final AppBloc appBloc;
  final MessagesBloc messagesBloc;

  const MessageUserFilterScreen(
      {Key? key, required this.appBloc, required this.messagesBloc})
      : super(key: key);

  @override
  _MessageUserFilterScreenState createState() =>
      _MessageUserFilterScreenState();
}

class _MessageUserFilterScreenState extends State<MessageUserFilterScreen> {
  bool _seeAll = true;
  List<MessageUserComponent> items = [];

  @override
  void initState() {
    items = widget.messagesBloc.usersList
        .map((e) => e.role)
        .toSet()
        .map((e) => MessageUserComponent(roleName: e, check: false))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: AppColors.getAppHeaderColor(),
            title: Text(
              'Filter',
              style: TextStyle(
                  fontSize: 18,
                  color:AppColors.getAppHeaderTextColor()),
            )),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(children: [
                Checkbox(
                  value: _seeAll,
                  onChanged: (val) {
                    setState(() {
                      _seeAll = val ?? false;
                      items.forEach((element) {
                        element.check = _seeAll;
                      });
                    });
                  },
                ),
                Text(
                  'See All',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.apply(color: InsColor(widget.appBloc).appTextColor),
                ),
                Expanded(child: Text('Clear'))
              ]),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.all(8),
                      height: items.length * 80.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Content Type',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, i) {
                                var value = items[i];
                                return Row(children: [
                                  Checkbox(
                                    value: value.check,
                                    onChanged: (val) {
                                      // setState(() {
                                      value.check = val ?? false;
                                      // });
                                    },
                                  ),
                                  Text(
                                    value.roleName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.apply(
                                            color: InsColor(widget.appBloc)
                                                .appTextColor),
                                  )
                                ]);
                              },
                            ),
                          )
                        ],
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
