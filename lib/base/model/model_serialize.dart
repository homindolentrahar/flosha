import 'package:freezed_annotation/freezed_annotation.dart';

T deserialize<T extends ModelSerialize>(
  Map<String, dynamic> data,
  T Function(Map<String, dynamic> data) factory,
) {
  return factory(data);
}

abstract interface class ModelSerialize {
  Map<String, dynamic> toJson();
}

abstract class ModelSerializer<T> implements JsonConverter<T, Object> {
  bool checkIsEqual<A, B>() => A == B;

  bool checkIsEqualn<A, B>() => checkIsEqual<A?, B?>();

  @override
  T fromJson(Object json);

  @override
  Object toJson(T object);
}
