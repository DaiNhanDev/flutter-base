// ignore_for_file: library_private_types_in_public_api
// non_constant_identifier_names

class ErrorCodes {
  static _Authentication get authentication => _Authentication();
}

class _Authentication {
  static final _Authentication _singleton = _Authentication._internal();

  factory _Authentication() {
    return _singleton;
  }

  _Authentication._internal();

  // One instance at the given time
  final int accountDoesNotExisted = 9;
}
