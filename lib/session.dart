/// PROBAR CÓMO CAMBIAR DE USUARIO SEGUN LA WEB
/// O SI SE PUEDE HACER EN UN BOTON DESPLEGABLE COMO INSTA
class CurrentUser {
  CurrentUser._();

  static int id = const int.fromEnvironment('ID_USUARIO', defaultValue: 15);
}