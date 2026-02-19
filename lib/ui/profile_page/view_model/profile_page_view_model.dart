import 'package:elaros_mobile_app/domain/models/user_profile_model.dart';
import 'package:elaros_mobile_app/domain/use_cases/profile_use_case.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';

class ProfilePageViewModel extends BaseViewModel {
  final ProfileUseCase profileUseCase;

  // using two user profiles to retain the original user profile without extra db queries
  UserProfileEntity _userProfile = UserProfileEntity(
    name: 'John',
    age: 21,
    gender: 'Male',
    height: 150,
    weight: 100,
    profileImageUrl: null,
    medicalCondition: null,
  );

  UserProfileEntity _modifiedUserProfile = UserProfileEntity(
    name: 'John',
    age: 21,
    gender: 'Male',
    height: 150,
    weight: 100,
    profileImageUrl: null,
    medicalCondition: null,
  );

  UserProfileEntity get userProfile => _modifiedUserProfile;

  ProfilePageViewModel({required this.profileUseCase});

  /// Fetches the user profile
  Future<void> getUserProfile({bool isInitialLoad = false}) async {
    setLoading();

    try {
      final data = await profileUseCase.getUserProfile();
      _userProfile = data[0];
      _modifiedUserProfile = data[0];
      if (!isInitialLoad) message = 'Successfully fetched user profile';
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the users modifiable profile fields
  void updateField(String key, String value) =>
      _modifiedUserProfile = _modifiedUserProfile.copyWithByKey(key, value);

  /// Checks the value of the field and throws an exception if any values are invalid
  bool checkFields(String key, String value) {
    try {
      String trimmed = value.trim();
      switch (key.trim().toLowerCase()) {
        case 'name':
          if (trimmed.length <= 3 || trimmed.length > 40) {
            isError = true;
            errorMessage = 'Name must be between 1 and 40 characters';
            return false;
          }
          break;
        case 'age':
          int age = int.parse(trimmed);
          if (age < 0 || age > 100) {
            isError = true;
            errorMessage = 'Age must be between 0 and 130';
            return false;
          }
          break;
        case 'gender':
          String lc = trimmed.toLowerCase();
          List<String> genders = ['male', 'female', 'other'];
          if (!genders.contains(lc)) {
            isError = true;
            errorMessage =
                'Gender must be one of \'male\', \'female\', or \'other\'';
            return false;
          }
          break;
        case 'height':
          double height = double.parse(trimmed);
          if (height < 1 || height > 300) {
            isError = true;
            errorMessage = 'Height must be between 1 and 300cm';
            return false;
          }
          break;
        case 'weight':
          double weight = double.parse(trimmed);
          if (weight < 1 || weight > 300) {
            isError = true;
            errorMessage = 'Weight must be between 1 and 300kg';
            return false;
          }
          break;
        case 'profile_image_url': // nullable field so no need to check
        case 'medical_condition':
          break;
        default:
          throw Exception('Unknown key: $key');
      }

      _userProfile = _userProfile.copyWithByKey(key, value);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }

    if (isError) throw Exception(errorMessage);

    return true;
  }

  /// Saves the user profile using the modified user profile
  Future<void> saveUserProfile() async {
    setLoading();

    if (_modifiedUserProfile.equals(_userProfile)) {
      isError = true;
      errorMessage = 'Aborting save as User profile is unchanged';
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      var map = _modifiedUserProfile.toMap();
      for (var key in map.keys) {
        try {
          bool isValid = checkFields(key, map[key].toString());

          if (!isValid) {
            throw Exception(
              'Invalid value \'${map[key].toString()}\' for \'$key\'',
            );
          }
        } catch (e) {
          isError = true;
          errorMessage = e.toString();
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      await profileUseCase.updateUserProfile(_modifiedUserProfile);
      message = 'Successfully saved user profile';
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Resets the user profile changes back to the original user profile
  void resetUserProfileChanges() {
    setLoading();
    try {
      _modifiedUserProfile = UserProfileEntity.clone(_userProfile);
      message = 'User profile changes reset';
    } catch (e) {
      errorMessage = e.toString();
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
