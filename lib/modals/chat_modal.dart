class ChatModal {
  int id;
  String msg;
  int msgTime;
  int seenTime;
  String type;

  ChatModal(
      {required this.id,
      required this.msg,
      required this.msgTime,
      required this.seenTime,
      required this.type});

  factory ChatModal.fromMap(Map chatModal) {
    ChatModal um = ChatModal(
        id: chatModal['id'],
        msg: chatModal['msg'],
        msgTime: chatModal['msgTime'],
        seenTime: chatModal['seenTime'],
        type: chatModal['type']);
    return um;
  }
}
