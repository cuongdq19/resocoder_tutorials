import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:resocoder_ddd/domain/auth/user.dart';
import 'package:resocoder_ddd/domain/core/value_objects.dart';

extension FirebaseUserDomainX on fb.User {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
}
