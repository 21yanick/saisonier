import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/profile/data/repositories/user_profile_repository.dart';
import 'package:saisonier/features/profile/domain/models/user_profile.dart';

part 'user_profile_controller.g.dart';

@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  FutureOr<UserProfile?> build() async {
    final userState = ref.watch(currentUserProvider);
    final user = userState.value;
    
    if (user == null) {
      return null;
    }
    
    // Fetch profile
    return ref.watch(userProfileRepositoryProvider).getProfile(user.id);
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(userProfileRepositoryProvider).createOrUpdateProfile(profile);
      return profile;
    });
  }
}
