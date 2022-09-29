import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_admin_web/framework/bloc/app/bloc/app_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/mylearning_details_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/bloc/review_bloc.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/mylearning_details_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/events/review_event.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/state/review_state.dart';
import 'package:flutter_admin_web/framework/common/enums.dart';
import 'package:flutter_admin_web/framework/theme/ins_theme.dart';
import 'package:flutter_admin_web/packages/smooth_star_rating.dart';
import 'package:flutter_admin_web/ui/auth/login_common_page.dart';
import 'package:flutter_admin_web/ui/common/common_toast.dart';

class ReviewScreen extends StatefulWidget {
  final String contentId;
  final bool isDetailsScreen;
  final MyLearningDetailsBloc detailsBloc;

  const ReviewScreen(
    this.contentId,
    this.isDetailsScreen,
    this.detailsBloc,
  );

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  AppBloc get appBloc => BlocProvider.of<AppBloc>(context);

  ReviewBloc get reviewBloc => BlocProvider.of<ReviewBloc>(context);
  TextEditingController reviewController = new TextEditingController();
  bool isEditing = false;
  double ratingID = 0;
  late FToast flutterToast;

  @override
  void initState() {
    // TODO: implement initState

    reviewBloc.add(
        GetCurrentUserReviewEvent(contentId: widget.contentId, skippedRows: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    flutterToast = FToast();
    flutterToast.init(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(int.parse(
              "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
          appBar: AppBar(
            title: Text(
              appBloc.localstr.detailsHeaderReviewtitlelabel,
              style: TextStyle(
                  color: Color(int.parse(
                      "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))),
            ),
            elevation: 2,
            backgroundColor: Color(int.parse(
                "0xFF${appBloc.uiSettingModel.appHeaderColor.substring(1, 7).toUpperCase()}")),
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: Color(int.parse(
                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
              ),
            ),
          ),
          body: BlocConsumer<ReviewBloc, ReviewState>(
            bloc: reviewBloc,
            listener: (context, state) {
              if (state is GetCurrentUserReviewState) {
                if (state.status == Status.COMPLETED) {
                  if (state.review.editRating != null) {
                    setState(() {
                      reviewController.text =
                          state.review.editRating?.description ?? "";
                      isEditing = true;
                      if (state.review.editRating?.ratingId != null) {
                        ratingID = double.parse(
                            state.review.editRating?.ratingId.toString() ??
                                "0");
                      }
                    });
                  }
                } else if (state.status == Status.ERROR) {
                  print("listner Error ${state.message}");
                  if (state.message == "401") {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginCommonPage()),
                        (route) => false);
                  }
                }
              } else if (state is AddReviewState) {
                if (state.status == Status.COMPLETED) {
                  flutterToast.showToast(
                    child: CommonToast(
                        displaymsg: "${state.data} Successfully ! "),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                  if (widget.isDetailsScreen) {
                    widget.detailsBloc.userRatingDetails.clear();
                    widget.detailsBloc.add(GetDetailsReviewEvent(
                        contentId: widget.contentId, skippedRows: 0));
                  }
                  Navigator.of(context).pop(true);
                }
              }
            },
            builder: (context, state) {
              if (state.status == Status.LOADING &&
                  state is GetCurrentUserReviewState) {
                return Center(
                  child: AbsorbPointer(
                    child: AppConstants().getLoaderWidget(iconSize: 70)
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Container(
                      color: Color(int.parse(
                          "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                      child: Column(
                        children: <Widget>[
                          SmoothStarRating(
                              rating: ratingID,
                              allowHalfRating: false,
                              onRatingChanged: (v) {
                                setState(() {
                                  ratingID = v;
                                });
                              },
                              starCount: 5,
                              size: ScreenUtil().setHeight(60),
                              // filledIconData: Icons.blur_off,
                              // halfFilledIconData: Icons.blur_on,
                              color: Colors.orange,
                              borderColor: Colors.orange,
                              spacing: 0.0),
                          Text(
                            "On a Scale Of 1 to 5 with 5 being the best ",
                            style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                fontSize: 13),
                          ),
                          Text(
                            "Write Your Review",
                            style: TextStyle(
                                color: Color(int.parse(
                                    "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}")),
                                fontSize: 13),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              style: TextStyle(
                                  color: InsColor(appBloc).appTextColor),
                              controller: reviewController,
                              minLines: 5,
                              //Normal textInputField will be displayed
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText:
                                    'What did you think about this content item?',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              disabledColor: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.5),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                              child: Text(
                                  isEditing
                                      ? appBloc.localstr
                                          .mylearningActionsheetDeleteoption
                                      : appBloc.localstr
                                          .asktheexpertActionsheetCanceloption,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                              onPressed: () {
                                if (isEditing) {
                                  reviewBloc.add(DeleteReviewEvent(
                                      contentId: widget.contentId));
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              disabledColor: Color(int.parse(
                                      "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}"))
                                  .withOpacity(0.5),
                              color: Color(int.parse(
                                  "0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")),
                              child: Text(
                                  isEditing
                                      ? appBloc
                                          .localstr.detailsButtonUpdatebutton
                                      : appBloc
                                          .localstr.detailsButtonSubmitbutton,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(int.parse(
                                          "0xFF${appBloc.uiSettingModel.appButtonTextColor.substring(1, 7).toUpperCase()}")))),
                              onPressed: () {
                                print("click  $ratingID");
                                if (ratingID >= 1) {
                                  print("click");
                                  reviewBloc.add(AddUserReviewEvent(
                                      contentId: widget.contentId,
                                      strReview:
                                          reviewController.text.toString(),
                                      strRating: ratingID.round()));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    state.status == Status.LOADING && state is AddReviewState
                        ? Center(
                            child: AbsorbPointer(
                              child: AppConstants().getLoaderWidget(iconSize: 70)
                            ),
                          )
                        : Container(),
                  ],
                );
              }
            },
          )),
    );
  }
}
