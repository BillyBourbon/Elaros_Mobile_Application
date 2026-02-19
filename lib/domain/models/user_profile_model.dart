class UserProfileEntity {
  final String name;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String? profileImageUrl;
  final String? medicalCondition;

  UserProfileEntity({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.profileImageUrl,
    this.medicalCondition,
  });

  bool equals(UserProfileEntity other) {
    if (other.name == name &&
        other.age == age &&
        other.gender == gender &&
        other.height == height &&
        other.weight == weight &&
        other.profileImageUrl == profileImageUrl &&
        other.medicalCondition == medicalCondition) {
      return true;
    }

    return false;
  }

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

  factory UserProfileEntity.fromMap(Map<String, dynamic> map) {
    return UserProfileEntity(
      name: map['name'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
      height: map['height'] as double,
      weight: map['weight'] as double,
      profileImageUrl: map['profile_image_url'] as String?,
      medicalCondition: map['medical_condition'] as String?,
    );
  }

  UserProfileEntity copyWith({
    String? name,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? profileImageUrl,
    String? medicalCondition,
  }) => UserProfileEntity(
    name: name ?? this.name,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    medicalCondition: medicalCondition ?? this.medicalCondition,
  );

  UserProfileEntity copyWithByKey(String key, String value) {
    if (key == 'name') {
      return copyWith(name: value);
    } else if (key == 'age') {
      return copyWith(age: int.parse(value));
    } else if (key == 'gender') {
      return copyWith(gender: value);
    } else if (key == 'height') {
      return copyWith(height: double.parse(value));
    } else if (key == 'weight') {
      return copyWith(weight: double.parse(value));
    } else if (key == 'profile_image_url') {
      return copyWith(profileImageUrl: value);
    } else if (key == 'medical_condition') {
      return copyWith(medicalCondition: value);
    } else {
      throw Exception('Unknown key: $key');
    }
  }

  UserProfileEntity.clone(UserProfileEntity userProfile)
    : this(
        name: userProfile.name,
        age: userProfile.age,
        gender: userProfile.gender,
        height: userProfile.height,
        weight: userProfile.weight,
        profileImageUrl: userProfile.profileImageUrl,
        medicalCondition: userProfile.medicalCondition,
      );
}
