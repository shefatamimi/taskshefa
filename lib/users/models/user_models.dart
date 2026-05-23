class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? phoneNumber;
  final String userRole;
  String? photoUrl;
  String? address;
  String? education;
  String? experience;
  String? jobTitle;
  String? aboutYou;
  String? skills;
  String? interests;
  String? languages;
  String? linkedIn;


  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.userRole,
    this.photoUrl,
    this.address,
    this.education,
    this.experience,
    this.jobTitle,
    this.aboutYou,
    this.skills,
    this.interests,
    this.languages,
    this.linkedIn
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'],
      userRole: map['userRole'] ?? 'user',
      photoUrl: map['photoUrl'],
      address: map['address'],
      education: map['education'],
      experience: map['experience'],
      jobTitle: map['jobTitle'],
      aboutYou: map['aboutYou'],
      skills: map['skills'],
      interests: map['interests'],
      languages: map['languages'],
      linkedIn: map['linkedIn'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'userRole': userRole,
      'photoUrl': photoUrl,
      'address': address,
      'education': education,
      'experience': experience,
      'jobTitle': jobTitle,
      'aboutYou': aboutYou,
      'skills': skills,
      'interests': interests,
      'languages': languages,
      'linkedIn': linkedIn,

    };
  }
}