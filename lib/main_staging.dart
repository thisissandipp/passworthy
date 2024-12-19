import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/app/app.dart';
import 'package:passworthy/bootstrap.dart';

void main() {
  final passkeyRepository = PasskeyRepository();
  bootstrap(() => App(passkeyRepository: passkeyRepository));
}
