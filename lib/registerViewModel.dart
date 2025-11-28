import '../dependencies.dart';
import '../pages.dart';
// function: creates a collection of users from usermodel and check input
// fields to register and adds a user
class RegisterViewModel
{
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');

  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  Future<String> registerUser() async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return "Please fill all fields.";
    }

    if (password != confirmPassword) {
      return "Passwords do not match.";
    }

    UserModel newUser = UserModel(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    await users.add(newUser.toMap());

    return "success";
  }
}
