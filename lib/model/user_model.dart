
class UserModel {
  String? uId;
  String? email;
  String? firstName;
  String? secondName;

  UserModel({this.uId, this.email, this.firstName, this.secondName});


  // receiving data from server
  factory UserModel.fromMap(map){
    return UserModel(
      uId: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],

    );
  }

  // sending data to our server
Map<String, dynamic> toMap(){
    return {
      'uid': uId,
      'email' : email,
      'firstName' : firstName,
      'secondName' : secondName
    };
}

}