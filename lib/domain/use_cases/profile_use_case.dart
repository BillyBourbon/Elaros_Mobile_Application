import 'package:elaros_mobile_app/data/local/repositories/user_profile_repository.dart';
import 'package:elaros_mobile_app/domain/models/user_profile_model.dart';

class ProfileUseCase {
  final UserProfileRepository userProfileRepository;
  ProfileUseCase({required this.userProfileRepository});

  Future<List<UserProfileEntity>> getUserProfile() async {
    final data = await userProfileRepository.getUserProfile();

    return data.map((e) => UserProfileEntity.fromMap(e.toMap())).toList();
  }

  Future<void> insertUserProfile(UserProfileEntity userProfile) async {
    await userProfileRepository.insertUserProfile(userProfile);
  }

  Future<void> updateUserProfile(UserProfileEntity userProfile) async {
    await userProfileRepository.updateUserProfile(userProfile);
  }
}
