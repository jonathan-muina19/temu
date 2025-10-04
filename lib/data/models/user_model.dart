class UserModel{
  final String uid;
  final String username;
  final String email;

  UserModel({
    required this.uid,
    required this.username,
    required this.email
  });

  // Factory pour convertir Firestore en ==> objet Dart
  factory UserModel.fromMap(Map<String, dynamic> data, String uid){
    return UserModel(
        uid: uid,
        username: data["username"] ?? "",
        email: data["email"] ?? ""
    );
  }

  // Convertir objet Dart en Map pour Firestore
  Map<String, dynamic> toMap(){
    return {
      "username" : username,
      "email"    : email
    };
  }

}
