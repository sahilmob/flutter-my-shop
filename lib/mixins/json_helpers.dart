import "dart:convert";

mixin JsonHelpers {
  String encode(Object value) {
    return json.encode(value);
  }

  dynamic decode(String value) {
    return json.decode(value);
  }
}
