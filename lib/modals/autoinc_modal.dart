class AutoIncrement {
  int val;

  AutoIncrement(this.val);

  factory AutoIncrement.fromMap(Map data) {
    return AutoIncrement(data['val']);
  }
}
