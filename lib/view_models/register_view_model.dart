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
    if (!isUsernameValid(name)) {
      return "Username must be 3-20 characters, start with a letter, and contain only letters, numbers, or _";
    }

    if (password != confirmPassword) {
      return "Passwords do not match.";
    }
    if (!isPasswordStrong(password)) {
      return "Password must be 8+ chars with at least 1 upper case and lower case letters & and 1 number.";
    }

    bool taken = await isUsernameTaken(name);
    if (taken) {
      return "Username already taken.";
    }

    try {
      // Create Firebase Auth account
      UserCredential cred =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = cred.user!.uid;

      // Save profile to Firestore
      UserModel user = UserModel(
        uid: uid,
        username: name,
        email: email,
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .set(user.toMap());

      return "success";
    } catch (e) {
      return e.toString();
    }
  }



  Future<bool> isUsernameTaken(String username) async {
    final query = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  bool isPasswordStrong(String password) {
    if (password.length < 8) return false;

    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));

    return hasUpper && hasLower && hasNumber;
  }

  bool isUsernameValid(String username) {
    // Regex: start with letter, only letters/numbers/_ allowed, 3-20 chars
    final regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{2,19}$');
    return regex.hasMatch(username);
  }


}
