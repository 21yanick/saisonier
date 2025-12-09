// Helper functions for PocketBase data handling.
//
// PocketBase uses "zero-defaults" for all fields. For relation fields,
// this means empty string "" instead of null. These helpers normalize
// the data for idiomatic Dart usage.
//
// See: https://pocketbase.io/docs/collections/

/// Converts empty strings to null for nullable ID fields.
///
/// PocketBase returns "" for empty single-relation fields instead of null.
/// Use this with `@JsonKey(fromJson: emptyToNull)` in Freezed DTOs.
///
/// Example:
/// ```dart
/// @JsonKey(name: 'recipe_id', fromJson: emptyToNull)
/// String? recipeId,
/// ```
String? emptyToNull(dynamic value) {
  if (value == null) return null;
  if (value is! String) return null;
  if (value.isEmpty) return null;
  return value;
}
