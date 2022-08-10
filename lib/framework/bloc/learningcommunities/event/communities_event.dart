import 'package:equatable/equatable.dart';
import 'package:flutter_admin_web/framework/bloc/app/native_menu_model.dart';
import 'package:flutter_admin_web/framework/common/local_str.dart';

import '../model/learningcommunitiesresponse.dart';

abstract class CommunitiesEvent extends Equatable {
  const CommunitiesEvent();
}

class GetLearningCommunitiesEvent extends CommunitiesEvent {
  final NativeMenuModel nativeMenuModel;

  GetLearningCommunitiesEvent({
    required this.nativeMenuModel,
  });

  @override
  // TODO: implement props
  List<Object> get props => [nativeMenuModel];
}

class LoginorGotoSubsiteEvent extends CommunitiesEvent {
  final String email;
  final String password;
  final LocalStr localStr;
  final PortalListing portallisting;

  LoginorGotoSubsiteEvent({
    required this.portallisting,
    this.email = "",
    this.password = "",
    required this.localStr,
  });

  @override
  List<Object> get props => [email, password, localStr];
}
