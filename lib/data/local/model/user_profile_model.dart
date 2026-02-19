class UserProfileModel {
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String? profileImageUrl;
  final String? medicalCondition;

  UserProfileModel({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.profileImageUrl,
    this.medicalCondition,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'profile_image_url': profileImageUrl,
      'medical_condition': medicalCondition,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      name: map['name'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      height: map['height'] as double,
      weight: map['weight'] as double,
      profileImageUrl: map['profile_image_url'] as String?,
      medicalCondition: map['medical_condition'] as String?,
    );
  }
}
