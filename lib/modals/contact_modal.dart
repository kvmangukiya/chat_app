class ContactModal {
  int id;
  String name;
  String imagePath;
  String lastMsg;
  int lastMsgTime;
  int lastUnreadMsgCount;
  int lastUnreadMsgId;

  ContactModal(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.lastMsg,
      required this.lastMsgTime,
      required this.lastUnreadMsgCount,
      required this.lastUnreadMsgId});

  factory ContactModal.fromMap(Map contactModal) {
    ContactModal cm = ContactModal(
        id: contactModal['id'],
        name: contactModal['name'],
        imagePath: contactModal['imagePath'],
        lastMsg: contactModal['lastMsg'],
        lastMsgTime: contactModal['lastMsgTime'],
        lastUnreadMsgCount: contactModal['lastUnreadMsgCount'],
        lastUnreadMsgId: contactModal['lastUnreadMsgId']);
    return cm;
  }
}
