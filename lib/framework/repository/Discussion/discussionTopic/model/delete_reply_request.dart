import 'dart:convert';

DeleteReplyRequest deleteReplyRequestFromJson(String str) =>
    DeleteReplyRequest.fromJson(json.decode(str));

dynamic deleteReplyRequestToJson(DeleteReplyRequest data) =>
    json.encode(data.toJson());

class DeleteReplyRequest {
  int replyId = 0;

  DeleteReplyRequest({
    this.replyId = 0,
  });

  DeleteReplyRequest.fromJson(Map<String, dynamic> json) {
    replyId = json['ReplyID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReplyID'] = this.replyId;
    return data;
  }
}
