abstract class MapHelper {
  static Map<String, dynamic> fromDynamic(dynamic original) {
    Map<String, dynamic> temp = {};

    original.forEach((key, value) {
      if (key is String) {
        temp[key] = value;
      }
    });

    return temp;
  }
}
