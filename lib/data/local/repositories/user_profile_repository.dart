import 'package:elaros_mobile_app/data/local/model/user_profile_model.dart';
import 'package:elaros_mobile_app/data/local/services/user_profile_service.dart';
import 'package:elaros_mobile_app/domain/models/user_profile_model.dart';

class UserProfileRepository {
  final UserProfileService _userProfileService;
  static final UserProfileRepository _instance =
      UserProfileRepository._internal(UserProfileService());
  factory UserProfileRepository() => _instance;
  UserProfileRepository._internal(this._userProfileService);

  factory UserProfileRepository.forTest(UserProfileService service) {
    return UserProfileRepository._internal(service);
  }

  Future<List<UserProfileModel>> getUserProfile() async {
    var sampleUser = UserProfileModel(
      name: 'John',
      age: 21,
      gender: 'Male',
      height: 150,
      weight: 100,
      profileImageUrl: null,
      medicalCondition: null,
    );

    var data = await _userProfileService.getUserProfile();

    if (data.isEmpty) {
      await _userProfileService.insertUserProfile(sampleUser);
      return [sampleUser];
    }

    return data.map((e) => UserProfileModel.fromMap(e)).toList();
  }

  Future<void> insertUserProfile(UserProfileEntity userProfile) async {
    await _userProfileService.insertUserProfile(
      UserProfileModel.fromMap(userProfile.toMap()),
    );
  }

  Future<void> updateUserProfile(UserProfileEntity userProfile) async {
    await _userProfileService.updateUserProfile(
      UserProfileModel.fromMap(userProfile.toMap()),
    );
  }
}
