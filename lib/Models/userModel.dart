
import '../dependencies.dart';
import '../pages.dart';
// function: basic user model structure
class UserModel
{
  String _name;
  String _email;
  String _password ;
  String _confirmPassword ;

// we are creating a db folder that is being referred as Users
// which is created as Instance (Root Collection/folder)
// CollectionReference contains all reference points from firebase
//the entire store data could be accessed through the instance names USERS
//what we want to add to the db
  UserModel({required String name, required String email,required String password,
    required String confirmPassword})
      : _name = name,
        _email = email,
        _password = password,
        _confirmPassword = confirmPassword;



String get name {
  return _name;
}

void set name(String name)
{
  this._name = name;
}

  String get email {
    return _email;
  }

  void set email(String email)
  {
    this._email = email;
  }
  String get password {
    return _password;
  }

  void set password(String password)
  {
    this._password = password;
  }
  String get confirmPassword {
    return _confirmPassword;
  }

  void set confirmPassword(String confirmPassword)
  {
    this._confirmPassword = confirmPassword;
  }


  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'email': _email,
      'password': _password,
      'confirmPassword': _confirmPassword,
    };
  }
}
