class UserModel {
  final String uid;
  final String name;
  final String profilePic;
  final bool isOnline;
  final bool isTyping;
  final String phoneNumber;
  final List<String> groupId;

  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.isOnline,
    required this.isTyping,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'isTyping': isTyping,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'] ?? '',
      profilePic: map['profilePic']??'',
      isOnline: map['isOnline'] ?? false,
      isTyping: map['isTyping'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}
