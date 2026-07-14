import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  UserModel();

  @JsonKey(name: 'id') int? id;
  @JsonKey(name: 'username') String? username;
  @JsonKey(name: 'password') String? password;
  @JsonKey(name: 'base_path') String? basePath;
  @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) int? role;
  @JsonKey(name: 'permission') int? permission;
  @JsonKey(name: 'sso_id') String? sso_id;
  @JsonKey(name: 'disabled') bool? disabled;
  
  factory UserModel.fromJson(Map<String,dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

int? _roleFromJson(dynamic json) {
  if (json is int) {
    return json;
  }
  if (json is List) {
    if (json.isEmpty) return 1; // GUEST
    if (json.contains(2) || json.contains('2') || json.contains('admin')) {
      return 2; // ADMIN
    }
    if (json.contains(0) || json.contains('0') || json.contains('general')) {
      return 0; // GENERAL
    }
    final first = json.first;
    if (first is int) return first;
    if (first is String) return int.tryParse(first);
  }
  if (json is String) {
    return int.tryParse(json);
  }
  return null;
}

dynamic _roleToJson(int? role) => role;
