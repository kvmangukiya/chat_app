String lastMsgTime(DateTime dt) {
  DateTime n = DateTime.now();
  if (dt.year == n.year && dt.month == n.month && dt.day == n.day) {
    return "${dt.hour}:${dt.minute}";
  } else {
    switch (dt.month) {
      case 1:
        return "Jan ${dt.day}";
      case 2:
        return "Feb ${dt.day}";
      case 3:
        return "Mar ${dt.day}";
      case 4:
        return "Apr ${dt.day}";
      case 5:
        return "May ${dt.day}";
      case 6:
        return "Jun ${dt.day}";
      case 7:
        return "Jul ${dt.day}";
      case 8:
        return "Aug ${dt.day}";
      case 9:
        return "Sep ${dt.day}";
      case 10:
        return "Oct ${dt.day}";
      case 11:
        return "Nov ${dt.day}";
      default:
        return "Dec ${dt.day}";
    }
  }
}
