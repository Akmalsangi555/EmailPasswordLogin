
class UserModel{

  String? uId;
  String? email;
  String? firstName;
  String? lastName;

  UserModel({this.uId, this.email, this.firstName, this.lastName});

  // sending data to our server
  Map<String, dynamic> toMap(){
    return {
      'uid' : uId,
      'email' : email,
      'firstname' : firstName,
      'lastname' : lastName
    };
  }

  // receiving data from server
  factory UserModel.fromMap(map){
    return UserModel(
        uId: map['uid'],
        email: map['email'],
        firstName: map['firstname'],
        lastName: map['lastname'],
    );
  }
}
