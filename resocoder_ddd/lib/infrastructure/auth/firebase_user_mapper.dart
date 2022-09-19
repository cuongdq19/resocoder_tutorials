import 'package:firebase_auth/firebase_auth.dart';
import 'package:resocoder_ddd/domain/auth/user.dart';
import 'package:resocoder_ddd/domain/core/value_objects.dart';

extension FirebaseUserDomainX on FirebaseUser {
  User toDomain() {
    return User(id: UniqueId.fromUniqueString(uid));
  }
}
