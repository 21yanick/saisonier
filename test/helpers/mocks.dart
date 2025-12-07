import 'package:mockito/annotations.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';

@GenerateMocks([
  PocketBase,
  RecordService,
  AuthStore,
  VegetableRepository,
  RecipeRepository,
])
void main() {}
