import 'package:equatable/equatable.dart';

abstract class ShareEVent extends Equatable {
  const ShareEVent();
}

class GetConnectionListEvent extends ShareEVent {
  final String searchTxt;

  GetConnectionListEvent({this.searchTxt = ""});

  @override
  List<Object> get props => [searchTxt];
}

class SelectConnectionEvent extends ShareEVent {
  final String seletedEmail;

  SelectConnectionEvent({this.seletedEmail = ""});

  @override
  List<Object> get props => [seletedEmail];
}

class SendMailToPeopleEvent extends ShareEVent {
  final String toEmail;
  final String subject;
  final String message;
  final bool isPeople;
  final bool isFromForm;
  final bool isFromQuestion;
  final String contentid;
  final String emailList;

  SendMailToPeopleEvent({
    this.toEmail = "",
    this.subject = "",
    this.message = "",
    this.emailList = "",
    this.isPeople = false,
    this.isFromForm = false,
    this.isFromQuestion = false,
    this.contentid = "",
  });

  @override
  List<Object> get props => [
        toEmail,
        subject,
        message,
        emailList,
        isPeople,
        isFromForm,
        isFromQuestion,
        contentid
      ];
}

class SendviaMailInmylearn extends ShareEVent {
  final String UserMails;
  final String Subject;
  final String Message;
  final bool isattachDocument;
  final String Contentid;

  SendviaMailInmylearn(
    this.UserMails,
    this.Subject,
    this.Message,
    this.isattachDocument,
    this.Contentid,
  );

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
