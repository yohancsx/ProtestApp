///create an anonymous user
///this user persists over the duration of the application
///destroyed when the application is exited
class AnonymousUser {
  AnonymousUser(this.userName);

  final String userName;
}
