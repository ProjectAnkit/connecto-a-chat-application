class UserModel {

  String? name;
  String? email;
  String? phoneNumber;
  String? uid;
  String? imageurl;
  String? bio;
  String? gender;
  UserModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.uid,
    this.imageurl,
    this.bio,
    this.gender
  });
  

  UserModel fromMap(Map<String,dynamic> map){
    name = map['name'];
    email = map['email'];
    phoneNumber = map['phone number'];
    uid = map['id'];
    imageurl = map['profile url'];
    bio = map['bio'];
    gender = map['gender'];
    return UserModel(name: name, email: email, phoneNumber: phoneNumber, uid: uid, imageurl: imageurl,bio: bio,gender: gender);
  }
  

  Map<String,dynamic> toMap(){
    return {
      "uid" : uid,
      "email" : email,
      "phone number" : phoneNumber,
      "name" : name,
      "profile url" : imageurl,
      "bio" : bio,
      "gender": gender
    };
  }
}





