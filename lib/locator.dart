import 'package:get_it/get_it.dart';
import 'package:net_chat/repository/user_repository.dart';
import 'package:net_chat/services/fake_auth_service.dart';
import 'package:net_chat/services/firebase_auth_service.dart';
import 'package:net_chat/services/firestore_db_service.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<FakeAuthService>(() => FakeAuthService());
  locator.registerLazySingleton<FirestoreDbService>(() => FirestoreDbService());
  locator.registerLazySingleton<UserRepository>(() => UserRepository());


  
}
