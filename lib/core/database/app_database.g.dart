// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VegetablesTable extends Vegetables
    with TableInfo<$VegetablesTable, Vegetable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VegetablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hexColorMeta =
      const VerificationMeta('hexColor');
  @override
  late final GeneratedColumn<String> hexColor = GeneratedColumn<String>(
      'hex_color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _monthsMeta = const VerificationMeta('months');
  @override
  late final GeneratedColumn<String> months = GeneratedColumn<String>(
      'months', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<int> tier = GeneratedColumn<int>(
      'tier', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, description, image, hexColor, months, tier, isFavorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vegetables';
  @override
  VerificationContext validateIntegrity(Insertable<Vegetable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('hex_color')) {
      context.handle(_hexColorMeta,
          hexColor.isAcceptableOrUnknown(data['hex_color']!, _hexColorMeta));
    } else if (isInserting) {
      context.missing(_hexColorMeta);
    }
    if (data.containsKey('months')) {
      context.handle(_monthsMeta,
          months.isAcceptableOrUnknown(data['months']!, _monthsMeta));
    } else if (isInserting) {
      context.missing(_monthsMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
          _tierMeta, tier.isAcceptableOrUnknown(data['tier']!, _tierMeta));
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vegetable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vegetable(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      hexColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hex_color'])!,
      months: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}months'])!,
      tier: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tier'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
    );
  }

  @override
  $VegetablesTable createAlias(String alias) {
    return $VegetablesTable(attachedDatabase, alias);
  }
}

class Vegetable extends DataClass implements Insertable<Vegetable> {
  final String id;
  final String name;
  final String type;
  final String? description;
  final String image;
  final String hexColor;
  final String months;
  final int tier;
  final bool isFavorite;
  const Vegetable(
      {required this.id,
      required this.name,
      required this.type,
      this.description,
      required this.image,
      required this.hexColor,
      required this.months,
      required this.tier,
      required this.isFavorite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['image'] = Variable<String>(image);
    map['hex_color'] = Variable<String>(hexColor);
    map['months'] = Variable<String>(months);
    map['tier'] = Variable<int>(tier);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  VegetablesCompanion toCompanion(bool nullToAbsent) {
    return VegetablesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      image: Value(image),
      hexColor: Value(hexColor),
      months: Value(months),
      tier: Value(tier),
      isFavorite: Value(isFavorite),
    );
  }

  factory Vegetable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vegetable(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String?>(json['description']),
      image: serializer.fromJson<String>(json['image']),
      hexColor: serializer.fromJson<String>(json['hexColor']),
      months: serializer.fromJson<String>(json['months']),
      tier: serializer.fromJson<int>(json['tier']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String?>(description),
      'image': serializer.toJson<String>(image),
      'hexColor': serializer.toJson<String>(hexColor),
      'months': serializer.toJson<String>(months),
      'tier': serializer.toJson<int>(tier),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Vegetable copyWith(
          {String? id,
          String? name,
          String? type,
          Value<String?> description = const Value.absent(),
          String? image,
          String? hexColor,
          String? months,
          int? tier,
          bool? isFavorite}) =>
      Vegetable(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        description: description.present ? description.value : this.description,
        image: image ?? this.image,
        hexColor: hexColor ?? this.hexColor,
        months: months ?? this.months,
        tier: tier ?? this.tier,
        isFavorite: isFavorite ?? this.isFavorite,
      );
  Vegetable copyWithCompanion(VegetablesCompanion data) {
    return Vegetable(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      description:
          data.description.present ? data.description.value : this.description,
      image: data.image.present ? data.image.value : this.image,
      hexColor: data.hexColor.present ? data.hexColor.value : this.hexColor,
      months: data.months.present ? data.months.value : this.months,
      tier: data.tier.present ? data.tier.value : this.tier,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vegetable(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('hexColor: $hexColor, ')
          ..write('months: $months, ')
          ..write('tier: $tier, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, type, description, image, hexColor, months, tier, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vegetable &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.description == this.description &&
          other.image == this.image &&
          other.hexColor == this.hexColor &&
          other.months == this.months &&
          other.tier == this.tier &&
          other.isFavorite == this.isFavorite);
}

class VegetablesCompanion extends UpdateCompanion<Vegetable> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> description;
  final Value<String> image;
  final Value<String> hexColor;
  final Value<String> months;
  final Value<int> tier;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const VegetablesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.hexColor = const Value.absent(),
    this.months = const Value.absent(),
    this.tier = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VegetablesCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.description = const Value.absent(),
    required String image,
    required String hexColor,
    required String months,
    required int tier,
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        image = Value(image),
        hexColor = Value(hexColor),
        months = Value(months),
        tier = Value(tier);
  static Insertable<Vegetable> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? description,
    Expression<String>? image,
    Expression<String>? hexColor,
    Expression<String>? months,
    Expression<int>? tier,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (hexColor != null) 'hex_color': hexColor,
      if (months != null) 'months': months,
      if (tier != null) 'tier': tier,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VegetablesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String?>? description,
      Value<String>? image,
      Value<String>? hexColor,
      Value<String>? months,
      Value<int>? tier,
      Value<bool>? isFavorite,
      Value<int>? rowid}) {
    return VegetablesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      image: image ?? this.image,
      hexColor: hexColor ?? this.hexColor,
      months: months ?? this.months,
      tier: tier ?? this.tier,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (hexColor.present) {
      map['hex_color'] = Variable<String>(hexColor.value);
    }
    if (months.present) {
      map['months'] = Variable<String>(months.value);
    }
    if (tier.present) {
      map['tier'] = Variable<int>(tier.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VegetablesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('hexColor: $hexColor, ')
          ..write('months: $months, ')
          ..write('tier: $tier, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _prepTimeMinMeta =
      const VerificationMeta('prepTimeMin');
  @override
  late final GeneratedColumn<int> prepTimeMin = GeneratedColumn<int>(
      'prep_time_min', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cookTimeMinMeta =
      const VerificationMeta('cookTimeMin');
  @override
  late final GeneratedColumn<int> cookTimeMin = GeneratedColumn<int>(
      'cook_time_min', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ingredientsMeta =
      const VerificationMeta('ingredients');
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
      'ingredients', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<String> steps = GeneratedColumn<String>(
      'steps', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vegetableIdMeta =
      const VerificationMeta('vegetableId');
  @override
  late final GeneratedColumn<String> vegetableId = GeneratedColumn<String>(
      'vegetable_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('curated'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPublicMeta =
      const VerificationMeta('isPublic');
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
      'is_public', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_public" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isVegetarianMeta =
      const VerificationMeta('isVegetarian');
  @override
  late final GeneratedColumn<bool> isVegetarian = GeneratedColumn<bool>(
      'is_vegetarian', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_vegetarian" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isVeganMeta =
      const VerificationMeta('isVegan');
  @override
  late final GeneratedColumn<bool> isVegan = GeneratedColumn<bool>(
      'is_vegan', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_vegan" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _containsGlutenMeta =
      const VerificationMeta('containsGluten');
  @override
  late final GeneratedColumn<bool> containsGluten = GeneratedColumn<bool>(
      'contains_gluten', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contains_gluten" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _containsLactoseMeta =
      const VerificationMeta('containsLactose');
  @override
  late final GeneratedColumn<bool> containsLactose = GeneratedColumn<bool>(
      'contains_lactose', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contains_lactose" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _containsNutsMeta =
      const VerificationMeta('containsNuts');
  @override
  late final GeneratedColumn<bool> containsNuts = GeneratedColumn<bool>(
      'contains_nuts', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contains_nuts" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _containsEggsMeta =
      const VerificationMeta('containsEggs');
  @override
  late final GeneratedColumn<bool> containsEggs = GeneratedColumn<bool>(
      'contains_eggs', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contains_eggs" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _containsSoyMeta =
      const VerificationMeta('containsSoy');
  @override
  late final GeneratedColumn<bool> containsSoy = GeneratedColumn<bool>(
      'contains_soy', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contains_soy" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _containsFishMeta =
      const VerificationMeta('containsFish');
  @override
  late final GeneratedColumn<bool> containsFish = GeneratedColumn<bool>(
      'contains_fish', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contains_fish" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _containsShellfishMeta =
      const VerificationMeta('containsShellfish');
  @override
  late final GeneratedColumn<bool> containsShellfish = GeneratedColumn<bool>(
      'contains_shellfish', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("contains_shellfish" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        image,
        prepTimeMin,
        cookTimeMin,
        servings,
        difficulty,
        ingredients,
        steps,
        vegetableId,
        source,
        userId,
        isPublic,
        isFavorite,
        isVegetarian,
        isVegan,
        containsGluten,
        containsLactose,
        containsNuts,
        containsEggs,
        containsSoy,
        containsFish,
        containsShellfish,
        category,
        tags
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<Recipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('prep_time_min')) {
      context.handle(
          _prepTimeMinMeta,
          prepTimeMin.isAcceptableOrUnknown(
              data['prep_time_min']!, _prepTimeMinMeta));
    }
    if (data.containsKey('cook_time_min')) {
      context.handle(
          _cookTimeMinMeta,
          cookTimeMin.isAcceptableOrUnknown(
              data['cook_time_min']!, _cookTimeMinMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('ingredients')) {
      context.handle(
          _ingredientsMeta,
          ingredients.isAcceptableOrUnknown(
              data['ingredients']!, _ingredientsMeta));
    } else if (isInserting) {
      context.missing(_ingredientsMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('vegetable_id')) {
      context.handle(
          _vegetableIdMeta,
          vegetableId.isAcceptableOrUnknown(
              data['vegetable_id']!, _vegetableIdMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('is_public')) {
      context.handle(_isPublicMeta,
          isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('is_vegetarian')) {
      context.handle(
          _isVegetarianMeta,
          isVegetarian.isAcceptableOrUnknown(
              data['is_vegetarian']!, _isVegetarianMeta));
    }
    if (data.containsKey('is_vegan')) {
      context.handle(_isVeganMeta,
          isVegan.isAcceptableOrUnknown(data['is_vegan']!, _isVeganMeta));
    }
    if (data.containsKey('contains_gluten')) {
      context.handle(
          _containsGlutenMeta,
          containsGluten.isAcceptableOrUnknown(
              data['contains_gluten']!, _containsGlutenMeta));
    }
    if (data.containsKey('contains_lactose')) {
      context.handle(
          _containsLactoseMeta,
          containsLactose.isAcceptableOrUnknown(
              data['contains_lactose']!, _containsLactoseMeta));
    }
    if (data.containsKey('contains_nuts')) {
      context.handle(
          _containsNutsMeta,
          containsNuts.isAcceptableOrUnknown(
              data['contains_nuts']!, _containsNutsMeta));
    }
    if (data.containsKey('contains_eggs')) {
      context.handle(
          _containsEggsMeta,
          containsEggs.isAcceptableOrUnknown(
              data['contains_eggs']!, _containsEggsMeta));
    }
    if (data.containsKey('contains_soy')) {
      context.handle(
          _containsSoyMeta,
          containsSoy.isAcceptableOrUnknown(
              data['contains_soy']!, _containsSoyMeta));
    }
    if (data.containsKey('contains_fish')) {
      context.handle(
          _containsFishMeta,
          containsFish.isAcceptableOrUnknown(
              data['contains_fish']!, _containsFishMeta));
    }
    if (data.containsKey('contains_shellfish')) {
      context.handle(
          _containsShellfishMeta,
          containsShellfish.isAcceptableOrUnknown(
              data['contains_shellfish']!, _containsShellfishMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      prepTimeMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prep_time_min'])!,
      cookTimeMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cook_time_min'])!,
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty']),
      ingredients: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ingredients'])!,
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}steps'])!,
      vegetableId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vegetable_id']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      isPublic: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_public'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      isVegetarian: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_vegetarian'])!,
      isVegan: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_vegan'])!,
      containsGluten: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}contains_gluten'])!,
      containsLactose: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}contains_lactose'])!,
      containsNuts: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}contains_nuts'])!,
      containsEggs: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}contains_eggs'])!,
      containsSoy: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}contains_soy'])!,
      containsFish: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}contains_fish'])!,
      containsShellfish: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}contains_shellfish'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String title;
  final String description;
  final String image;
  final int prepTimeMin;
  final int cookTimeMin;
  final int servings;
  final String? difficulty;
  final String ingredients;
  final String steps;
  final String? vegetableId;
  final String source;
  final String? userId;
  final bool isPublic;
  final bool isFavorite;
  final bool isVegetarian;
  final bool isVegan;
  final bool containsGluten;
  final bool containsLactose;
  final bool containsNuts;
  final bool containsEggs;
  final bool containsSoy;
  final bool containsFish;
  final bool containsShellfish;
  final String? category;
  final String tags;
  const Recipe(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.prepTimeMin,
      required this.cookTimeMin,
      required this.servings,
      this.difficulty,
      required this.ingredients,
      required this.steps,
      this.vegetableId,
      required this.source,
      this.userId,
      required this.isPublic,
      required this.isFavorite,
      required this.isVegetarian,
      required this.isVegan,
      required this.containsGluten,
      required this.containsLactose,
      required this.containsNuts,
      required this.containsEggs,
      required this.containsSoy,
      required this.containsFish,
      required this.containsShellfish,
      this.category,
      required this.tags});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['image'] = Variable<String>(image);
    map['prep_time_min'] = Variable<int>(prepTimeMin);
    map['cook_time_min'] = Variable<int>(cookTimeMin);
    map['servings'] = Variable<int>(servings);
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    map['ingredients'] = Variable<String>(ingredients);
    map['steps'] = Variable<String>(steps);
    if (!nullToAbsent || vegetableId != null) {
      map['vegetable_id'] = Variable<String>(vegetableId);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['is_public'] = Variable<bool>(isPublic);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_vegetarian'] = Variable<bool>(isVegetarian);
    map['is_vegan'] = Variable<bool>(isVegan);
    map['contains_gluten'] = Variable<bool>(containsGluten);
    map['contains_lactose'] = Variable<bool>(containsLactose);
    map['contains_nuts'] = Variable<bool>(containsNuts);
    map['contains_eggs'] = Variable<bool>(containsEggs);
    map['contains_soy'] = Variable<bool>(containsSoy);
    map['contains_fish'] = Variable<bool>(containsFish);
    map['contains_shellfish'] = Variable<bool>(containsShellfish);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['tags'] = Variable<String>(tags);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      image: Value(image),
      prepTimeMin: Value(prepTimeMin),
      cookTimeMin: Value(cookTimeMin),
      servings: Value(servings),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      ingredients: Value(ingredients),
      steps: Value(steps),
      vegetableId: vegetableId == null && nullToAbsent
          ? const Value.absent()
          : Value(vegetableId),
      source: Value(source),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      isPublic: Value(isPublic),
      isFavorite: Value(isFavorite),
      isVegetarian: Value(isVegetarian),
      isVegan: Value(isVegan),
      containsGluten: Value(containsGluten),
      containsLactose: Value(containsLactose),
      containsNuts: Value(containsNuts),
      containsEggs: Value(containsEggs),
      containsSoy: Value(containsSoy),
      containsFish: Value(containsFish),
      containsShellfish: Value(containsShellfish),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      tags: Value(tags),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      image: serializer.fromJson<String>(json['image']),
      prepTimeMin: serializer.fromJson<int>(json['prepTimeMin']),
      cookTimeMin: serializer.fromJson<int>(json['cookTimeMin']),
      servings: serializer.fromJson<int>(json['servings']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      steps: serializer.fromJson<String>(json['steps']),
      vegetableId: serializer.fromJson<String?>(json['vegetableId']),
      source: serializer.fromJson<String>(json['source']),
      userId: serializer.fromJson<String?>(json['userId']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isVegetarian: serializer.fromJson<bool>(json['isVegetarian']),
      isVegan: serializer.fromJson<bool>(json['isVegan']),
      containsGluten: serializer.fromJson<bool>(json['containsGluten']),
      containsLactose: serializer.fromJson<bool>(json['containsLactose']),
      containsNuts: serializer.fromJson<bool>(json['containsNuts']),
      containsEggs: serializer.fromJson<bool>(json['containsEggs']),
      containsSoy: serializer.fromJson<bool>(json['containsSoy']),
      containsFish: serializer.fromJson<bool>(json['containsFish']),
      containsShellfish: serializer.fromJson<bool>(json['containsShellfish']),
      category: serializer.fromJson<String?>(json['category']),
      tags: serializer.fromJson<String>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'image': serializer.toJson<String>(image),
      'prepTimeMin': serializer.toJson<int>(prepTimeMin),
      'cookTimeMin': serializer.toJson<int>(cookTimeMin),
      'servings': serializer.toJson<int>(servings),
      'difficulty': serializer.toJson<String?>(difficulty),
      'ingredients': serializer.toJson<String>(ingredients),
      'steps': serializer.toJson<String>(steps),
      'vegetableId': serializer.toJson<String?>(vegetableId),
      'source': serializer.toJson<String>(source),
      'userId': serializer.toJson<String?>(userId),
      'isPublic': serializer.toJson<bool>(isPublic),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isVegetarian': serializer.toJson<bool>(isVegetarian),
      'isVegan': serializer.toJson<bool>(isVegan),
      'containsGluten': serializer.toJson<bool>(containsGluten),
      'containsLactose': serializer.toJson<bool>(containsLactose),
      'containsNuts': serializer.toJson<bool>(containsNuts),
      'containsEggs': serializer.toJson<bool>(containsEggs),
      'containsSoy': serializer.toJson<bool>(containsSoy),
      'containsFish': serializer.toJson<bool>(containsFish),
      'containsShellfish': serializer.toJson<bool>(containsShellfish),
      'category': serializer.toJson<String?>(category),
      'tags': serializer.toJson<String>(tags),
    };
  }

  Recipe copyWith(
          {String? id,
          String? title,
          String? description,
          String? image,
          int? prepTimeMin,
          int? cookTimeMin,
          int? servings,
          Value<String?> difficulty = const Value.absent(),
          String? ingredients,
          String? steps,
          Value<String?> vegetableId = const Value.absent(),
          String? source,
          Value<String?> userId = const Value.absent(),
          bool? isPublic,
          bool? isFavorite,
          bool? isVegetarian,
          bool? isVegan,
          bool? containsGluten,
          bool? containsLactose,
          bool? containsNuts,
          bool? containsEggs,
          bool? containsSoy,
          bool? containsFish,
          bool? containsShellfish,
          Value<String?> category = const Value.absent(),
          String? tags}) =>
      Recipe(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        image: image ?? this.image,
        prepTimeMin: prepTimeMin ?? this.prepTimeMin,
        cookTimeMin: cookTimeMin ?? this.cookTimeMin,
        servings: servings ?? this.servings,
        difficulty: difficulty.present ? difficulty.value : this.difficulty,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
        vegetableId: vegetableId.present ? vegetableId.value : this.vegetableId,
        source: source ?? this.source,
        userId: userId.present ? userId.value : this.userId,
        isPublic: isPublic ?? this.isPublic,
        isFavorite: isFavorite ?? this.isFavorite,
        isVegetarian: isVegetarian ?? this.isVegetarian,
        isVegan: isVegan ?? this.isVegan,
        containsGluten: containsGluten ?? this.containsGluten,
        containsLactose: containsLactose ?? this.containsLactose,
        containsNuts: containsNuts ?? this.containsNuts,
        containsEggs: containsEggs ?? this.containsEggs,
        containsSoy: containsSoy ?? this.containsSoy,
        containsFish: containsFish ?? this.containsFish,
        containsShellfish: containsShellfish ?? this.containsShellfish,
        category: category.present ? category.value : this.category,
        tags: tags ?? this.tags,
      );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      image: data.image.present ? data.image.value : this.image,
      prepTimeMin:
          data.prepTimeMin.present ? data.prepTimeMin.value : this.prepTimeMin,
      cookTimeMin:
          data.cookTimeMin.present ? data.cookTimeMin.value : this.cookTimeMin,
      servings: data.servings.present ? data.servings.value : this.servings,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      ingredients:
          data.ingredients.present ? data.ingredients.value : this.ingredients,
      steps: data.steps.present ? data.steps.value : this.steps,
      vegetableId:
          data.vegetableId.present ? data.vegetableId.value : this.vegetableId,
      source: data.source.present ? data.source.value : this.source,
      userId: data.userId.present ? data.userId.value : this.userId,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isVegetarian: data.isVegetarian.present
          ? data.isVegetarian.value
          : this.isVegetarian,
      isVegan: data.isVegan.present ? data.isVegan.value : this.isVegan,
      containsGluten: data.containsGluten.present
          ? data.containsGluten.value
          : this.containsGluten,
      containsLactose: data.containsLactose.present
          ? data.containsLactose.value
          : this.containsLactose,
      containsNuts: data.containsNuts.present
          ? data.containsNuts.value
          : this.containsNuts,
      containsEggs: data.containsEggs.present
          ? data.containsEggs.value
          : this.containsEggs,
      containsSoy:
          data.containsSoy.present ? data.containsSoy.value : this.containsSoy,
      containsFish: data.containsFish.present
          ? data.containsFish.value
          : this.containsFish,
      containsShellfish: data.containsShellfish.present
          ? data.containsShellfish.value
          : this.containsShellfish,
      category: data.category.present ? data.category.value : this.category,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('prepTimeMin: $prepTimeMin, ')
          ..write('cookTimeMin: $cookTimeMin, ')
          ..write('servings: $servings, ')
          ..write('difficulty: $difficulty, ')
          ..write('ingredients: $ingredients, ')
          ..write('steps: $steps, ')
          ..write('vegetableId: $vegetableId, ')
          ..write('source: $source, ')
          ..write('userId: $userId, ')
          ..write('isPublic: $isPublic, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isVegetarian: $isVegetarian, ')
          ..write('isVegan: $isVegan, ')
          ..write('containsGluten: $containsGluten, ')
          ..write('containsLactose: $containsLactose, ')
          ..write('containsNuts: $containsNuts, ')
          ..write('containsEggs: $containsEggs, ')
          ..write('containsSoy: $containsSoy, ')
          ..write('containsFish: $containsFish, ')
          ..write('containsShellfish: $containsShellfish, ')
          ..write('category: $category, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        description,
        image,
        prepTimeMin,
        cookTimeMin,
        servings,
        difficulty,
        ingredients,
        steps,
        vegetableId,
        source,
        userId,
        isPublic,
        isFavorite,
        isVegetarian,
        isVegan,
        containsGluten,
        containsLactose,
        containsNuts,
        containsEggs,
        containsSoy,
        containsFish,
        containsShellfish,
        category,
        tags
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.image == this.image &&
          other.prepTimeMin == this.prepTimeMin &&
          other.cookTimeMin == this.cookTimeMin &&
          other.servings == this.servings &&
          other.difficulty == this.difficulty &&
          other.ingredients == this.ingredients &&
          other.steps == this.steps &&
          other.vegetableId == this.vegetableId &&
          other.source == this.source &&
          other.userId == this.userId &&
          other.isPublic == this.isPublic &&
          other.isFavorite == this.isFavorite &&
          other.isVegetarian == this.isVegetarian &&
          other.isVegan == this.isVegan &&
          other.containsGluten == this.containsGluten &&
          other.containsLactose == this.containsLactose &&
          other.containsNuts == this.containsNuts &&
          other.containsEggs == this.containsEggs &&
          other.containsSoy == this.containsSoy &&
          other.containsFish == this.containsFish &&
          other.containsShellfish == this.containsShellfish &&
          other.category == this.category &&
          other.tags == this.tags);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> image;
  final Value<int> prepTimeMin;
  final Value<int> cookTimeMin;
  final Value<int> servings;
  final Value<String?> difficulty;
  final Value<String> ingredients;
  final Value<String> steps;
  final Value<String?> vegetableId;
  final Value<String> source;
  final Value<String?> userId;
  final Value<bool> isPublic;
  final Value<bool> isFavorite;
  final Value<bool> isVegetarian;
  final Value<bool> isVegan;
  final Value<bool> containsGluten;
  final Value<bool> containsLactose;
  final Value<bool> containsNuts;
  final Value<bool> containsEggs;
  final Value<bool> containsSoy;
  final Value<bool> containsFish;
  final Value<bool> containsShellfish;
  final Value<String?> category;
  final Value<String> tags;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.image = const Value.absent(),
    this.prepTimeMin = const Value.absent(),
    this.cookTimeMin = const Value.absent(),
    this.servings = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.steps = const Value.absent(),
    this.vegetableId = const Value.absent(),
    this.source = const Value.absent(),
    this.userId = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isVegetarian = const Value.absent(),
    this.isVegan = const Value.absent(),
    this.containsGluten = const Value.absent(),
    this.containsLactose = const Value.absent(),
    this.containsNuts = const Value.absent(),
    this.containsEggs = const Value.absent(),
    this.containsSoy = const Value.absent(),
    this.containsFish = const Value.absent(),
    this.containsShellfish = const Value.absent(),
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required String image,
    this.prepTimeMin = const Value.absent(),
    this.cookTimeMin = const Value.absent(),
    this.servings = const Value.absent(),
    this.difficulty = const Value.absent(),
    required String ingredients,
    required String steps,
    this.vegetableId = const Value.absent(),
    this.source = const Value.absent(),
    this.userId = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isVegetarian = const Value.absent(),
    this.isVegan = const Value.absent(),
    this.containsGluten = const Value.absent(),
    this.containsLactose = const Value.absent(),
    this.containsNuts = const Value.absent(),
    this.containsEggs = const Value.absent(),
    this.containsSoy = const Value.absent(),
    this.containsFish = const Value.absent(),
    this.containsShellfish = const Value.absent(),
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        image = Value(image),
        ingredients = Value(ingredients),
        steps = Value(steps);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? image,
    Expression<int>? prepTimeMin,
    Expression<int>? cookTimeMin,
    Expression<int>? servings,
    Expression<String>? difficulty,
    Expression<String>? ingredients,
    Expression<String>? steps,
    Expression<String>? vegetableId,
    Expression<String>? source,
    Expression<String>? userId,
    Expression<bool>? isPublic,
    Expression<bool>? isFavorite,
    Expression<bool>? isVegetarian,
    Expression<bool>? isVegan,
    Expression<bool>? containsGluten,
    Expression<bool>? containsLactose,
    Expression<bool>? containsNuts,
    Expression<bool>? containsEggs,
    Expression<bool>? containsSoy,
    Expression<bool>? containsFish,
    Expression<bool>? containsShellfish,
    Expression<String>? category,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (image != null) 'image': image,
      if (prepTimeMin != null) 'prep_time_min': prepTimeMin,
      if (cookTimeMin != null) 'cook_time_min': cookTimeMin,
      if (servings != null) 'servings': servings,
      if (difficulty != null) 'difficulty': difficulty,
      if (ingredients != null) 'ingredients': ingredients,
      if (steps != null) 'steps': steps,
      if (vegetableId != null) 'vegetable_id': vegetableId,
      if (source != null) 'source': source,
      if (userId != null) 'user_id': userId,
      if (isPublic != null) 'is_public': isPublic,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isVegetarian != null) 'is_vegetarian': isVegetarian,
      if (isVegan != null) 'is_vegan': isVegan,
      if (containsGluten != null) 'contains_gluten': containsGluten,
      if (containsLactose != null) 'contains_lactose': containsLactose,
      if (containsNuts != null) 'contains_nuts': containsNuts,
      if (containsEggs != null) 'contains_eggs': containsEggs,
      if (containsSoy != null) 'contains_soy': containsSoy,
      if (containsFish != null) 'contains_fish': containsFish,
      if (containsShellfish != null) 'contains_shellfish': containsShellfish,
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? image,
      Value<int>? prepTimeMin,
      Value<int>? cookTimeMin,
      Value<int>? servings,
      Value<String?>? difficulty,
      Value<String>? ingredients,
      Value<String>? steps,
      Value<String?>? vegetableId,
      Value<String>? source,
      Value<String?>? userId,
      Value<bool>? isPublic,
      Value<bool>? isFavorite,
      Value<bool>? isVegetarian,
      Value<bool>? isVegan,
      Value<bool>? containsGluten,
      Value<bool>? containsLactose,
      Value<bool>? containsNuts,
      Value<bool>? containsEggs,
      Value<bool>? containsSoy,
      Value<bool>? containsFish,
      Value<bool>? containsShellfish,
      Value<String?>? category,
      Value<String>? tags,
      Value<int>? rowid}) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      prepTimeMin: prepTimeMin ?? this.prepTimeMin,
      cookTimeMin: cookTimeMin ?? this.cookTimeMin,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      vegetableId: vegetableId ?? this.vegetableId,
      source: source ?? this.source,
      userId: userId ?? this.userId,
      isPublic: isPublic ?? this.isPublic,
      isFavorite: isFavorite ?? this.isFavorite,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      containsGluten: containsGluten ?? this.containsGluten,
      containsLactose: containsLactose ?? this.containsLactose,
      containsNuts: containsNuts ?? this.containsNuts,
      containsEggs: containsEggs ?? this.containsEggs,
      containsSoy: containsSoy ?? this.containsSoy,
      containsFish: containsFish ?? this.containsFish,
      containsShellfish: containsShellfish ?? this.containsShellfish,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (prepTimeMin.present) {
      map['prep_time_min'] = Variable<int>(prepTimeMin.value);
    }
    if (cookTimeMin.present) {
      map['cook_time_min'] = Variable<int>(cookTimeMin.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (steps.present) {
      map['steps'] = Variable<String>(steps.value);
    }
    if (vegetableId.present) {
      map['vegetable_id'] = Variable<String>(vegetableId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isVegetarian.present) {
      map['is_vegetarian'] = Variable<bool>(isVegetarian.value);
    }
    if (isVegan.present) {
      map['is_vegan'] = Variable<bool>(isVegan.value);
    }
    if (containsGluten.present) {
      map['contains_gluten'] = Variable<bool>(containsGluten.value);
    }
    if (containsLactose.present) {
      map['contains_lactose'] = Variable<bool>(containsLactose.value);
    }
    if (containsNuts.present) {
      map['contains_nuts'] = Variable<bool>(containsNuts.value);
    }
    if (containsEggs.present) {
      map['contains_eggs'] = Variable<bool>(containsEggs.value);
    }
    if (containsSoy.present) {
      map['contains_soy'] = Variable<bool>(containsSoy.value);
    }
    if (containsFish.present) {
      map['contains_fish'] = Variable<bool>(containsFish.value);
    }
    if (containsShellfish.present) {
      map['contains_shellfish'] = Variable<bool>(containsShellfish.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('image: $image, ')
          ..write('prepTimeMin: $prepTimeMin, ')
          ..write('cookTimeMin: $cookTimeMin, ')
          ..write('servings: $servings, ')
          ..write('difficulty: $difficulty, ')
          ..write('ingredients: $ingredients, ')
          ..write('steps: $steps, ')
          ..write('vegetableId: $vegetableId, ')
          ..write('source: $source, ')
          ..write('userId: $userId, ')
          ..write('isPublic: $isPublic, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isVegetarian: $isVegetarian, ')
          ..write('isVegan: $isVegan, ')
          ..write('containsGluten: $containsGluten, ')
          ..write('containsLactose: $containsLactose, ')
          ..write('containsNuts: $containsNuts, ')
          ..write('containsEggs: $containsEggs, ')
          ..write('containsSoy: $containsSoy, ')
          ..write('containsFish: $containsFish, ')
          ..write('containsShellfish: $containsShellfish, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannedMealsTable extends PlannedMeals
    with TableInfo<$PlannedMealsTable, PlannedMeal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedMealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<String> slot = GeneratedColumn<String>(
      'slot', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customTitleMeta =
      const VerificationMeta('customTitle');
  @override
  late final GeneratedColumn<String> customTitle = GeneratedColumn<String>(
      'custom_title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, date, slot, recipeId, customTitle, servings];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_meals';
  @override
  VerificationContext validateIntegrity(Insertable<PlannedMeal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
          _slotMeta, slot.isAcceptableOrUnknown(data['slot']!, _slotMeta));
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    }
    if (data.containsKey('custom_title')) {
      context.handle(
          _customTitleMeta,
          customTitle.isAcceptableOrUnknown(
              data['custom_title']!, _customTitleMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedMeal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedMeal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      slot: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slot'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id']),
      customTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_title']),
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings'])!,
    );
  }

  @override
  $PlannedMealsTable createAlias(String alias) {
    return $PlannedMealsTable(attachedDatabase, alias);
  }
}

class PlannedMeal extends DataClass implements Insertable<PlannedMeal> {
  final String id;
  final String userId;
  final DateTime date;
  final String slot;
  final String? recipeId;
  final String? customTitle;
  final int servings;
  const PlannedMeal(
      {required this.id,
      required this.userId,
      required this.date,
      required this.slot,
      this.recipeId,
      this.customTitle,
      required this.servings});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['slot'] = Variable<String>(slot);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<String>(recipeId);
    }
    if (!nullToAbsent || customTitle != null) {
      map['custom_title'] = Variable<String>(customTitle);
    }
    map['servings'] = Variable<int>(servings);
    return map;
  }

  PlannedMealsCompanion toCompanion(bool nullToAbsent) {
    return PlannedMealsCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      slot: Value(slot),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      customTitle: customTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(customTitle),
      servings: Value(servings),
    );
  }

  factory PlannedMeal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedMeal(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      slot: serializer.fromJson<String>(json['slot']),
      recipeId: serializer.fromJson<String?>(json['recipeId']),
      customTitle: serializer.fromJson<String?>(json['customTitle']),
      servings: serializer.fromJson<int>(json['servings']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'slot': serializer.toJson<String>(slot),
      'recipeId': serializer.toJson<String?>(recipeId),
      'customTitle': serializer.toJson<String?>(customTitle),
      'servings': serializer.toJson<int>(servings),
    };
  }

  PlannedMeal copyWith(
          {String? id,
          String? userId,
          DateTime? date,
          String? slot,
          Value<String?> recipeId = const Value.absent(),
          Value<String?> customTitle = const Value.absent(),
          int? servings}) =>
      PlannedMeal(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        slot: slot ?? this.slot,
        recipeId: recipeId.present ? recipeId.value : this.recipeId,
        customTitle: customTitle.present ? customTitle.value : this.customTitle,
        servings: servings ?? this.servings,
      );
  PlannedMeal copyWithCompanion(PlannedMealsCompanion data) {
    return PlannedMeal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      slot: data.slot.present ? data.slot.value : this.slot,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      customTitle:
          data.customTitle.present ? data.customTitle.value : this.customTitle,
      servings: data.servings.present ? data.servings.value : this.servings,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedMeal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('slot: $slot, ')
          ..write('recipeId: $recipeId, ')
          ..write('customTitle: $customTitle, ')
          ..write('servings: $servings')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, date, slot, recipeId, customTitle, servings);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedMeal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.slot == this.slot &&
          other.recipeId == this.recipeId &&
          other.customTitle == this.customTitle &&
          other.servings == this.servings);
}

class PlannedMealsCompanion extends UpdateCompanion<PlannedMeal> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<String> slot;
  final Value<String?> recipeId;
  final Value<String?> customTitle;
  final Value<int> servings;
  final Value<int> rowid;
  const PlannedMealsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.slot = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.customTitle = const Value.absent(),
    this.servings = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannedMealsCompanion.insert({
    required String id,
    required String userId,
    required DateTime date,
    required String slot,
    this.recipeId = const Value.absent(),
    this.customTitle = const Value.absent(),
    this.servings = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        date = Value(date),
        slot = Value(slot);
  static Insertable<PlannedMeal> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<String>? slot,
    Expression<String>? recipeId,
    Expression<String>? customTitle,
    Expression<int>? servings,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (slot != null) 'slot': slot,
      if (recipeId != null) 'recipe_id': recipeId,
      if (customTitle != null) 'custom_title': customTitle,
      if (servings != null) 'servings': servings,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannedMealsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<DateTime>? date,
      Value<String>? slot,
      Value<String?>? recipeId,
      Value<String?>? customTitle,
      Value<int>? servings,
      Value<int>? rowid}) {
    return PlannedMealsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      slot: slot ?? this.slot,
      recipeId: recipeId ?? this.recipeId,
      customTitle: customTitle ?? this.customTitle,
      servings: servings ?? this.servings,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(slot.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (customTitle.present) {
      map['custom_title'] = Variable<String>(customTitle.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedMealsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('slot: $slot, ')
          ..write('recipeId: $recipeId, ')
          ..write('customTitle: $customTitle, ')
          ..write('servings: $servings, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VegetablesTable vegetables = $VegetablesTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $PlannedMealsTable plannedMeals = $PlannedMealsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [vegetables, recipes, plannedMeals];
}

typedef $$VegetablesTableCreateCompanionBuilder = VegetablesCompanion Function({
  required String id,
  required String name,
  required String type,
  Value<String?> description,
  required String image,
  required String hexColor,
  required String months,
  required int tier,
  Value<bool> isFavorite,
  Value<int> rowid,
});
typedef $$VegetablesTableUpdateCompanionBuilder = VegetablesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String?> description,
  Value<String> image,
  Value<String> hexColor,
  Value<String> months,
  Value<int> tier,
  Value<bool> isFavorite,
  Value<int> rowid,
});

class $$VegetablesTableFilterComposer
    extends Composer<_$AppDatabase, $VegetablesTable> {
  $$VegetablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hexColor => $composableBuilder(
      column: $table.hexColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get months => $composableBuilder(
      column: $table.months, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));
}

class $$VegetablesTableOrderingComposer
    extends Composer<_$AppDatabase, $VegetablesTable> {
  $$VegetablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hexColor => $composableBuilder(
      column: $table.hexColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get months => $composableBuilder(
      column: $table.months, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));
}

class $$VegetablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VegetablesTable> {
  $$VegetablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<String> get hexColor =>
      $composableBuilder(column: $table.hexColor, builder: (column) => column);

  GeneratedColumn<String> get months =>
      $composableBuilder(column: $table.months, builder: (column) => column);

  GeneratedColumn<int> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);
}

class $$VegetablesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VegetablesTable,
    Vegetable,
    $$VegetablesTableFilterComposer,
    $$VegetablesTableOrderingComposer,
    $$VegetablesTableAnnotationComposer,
    $$VegetablesTableCreateCompanionBuilder,
    $$VegetablesTableUpdateCompanionBuilder,
    (Vegetable, BaseReferences<_$AppDatabase, $VegetablesTable, Vegetable>),
    Vegetable,
    PrefetchHooks Function()> {
  $$VegetablesTableTableManager(_$AppDatabase db, $VegetablesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VegetablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VegetablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VegetablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> image = const Value.absent(),
            Value<String> hexColor = const Value.absent(),
            Value<String> months = const Value.absent(),
            Value<int> tier = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VegetablesCompanion(
            id: id,
            name: name,
            type: type,
            description: description,
            image: image,
            hexColor: hexColor,
            months: months,
            tier: tier,
            isFavorite: isFavorite,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            Value<String?> description = const Value.absent(),
            required String image,
            required String hexColor,
            required String months,
            required int tier,
            Value<bool> isFavorite = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VegetablesCompanion.insert(
            id: id,
            name: name,
            type: type,
            description: description,
            image: image,
            hexColor: hexColor,
            months: months,
            tier: tier,
            isFavorite: isFavorite,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VegetablesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VegetablesTable,
    Vegetable,
    $$VegetablesTableFilterComposer,
    $$VegetablesTableOrderingComposer,
    $$VegetablesTableAnnotationComposer,
    $$VegetablesTableCreateCompanionBuilder,
    $$VegetablesTableUpdateCompanionBuilder,
    (Vegetable, BaseReferences<_$AppDatabase, $VegetablesTable, Vegetable>),
    Vegetable,
    PrefetchHooks Function()>;
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  required String id,
  required String title,
  Value<String> description,
  required String image,
  Value<int> prepTimeMin,
  Value<int> cookTimeMin,
  Value<int> servings,
  Value<String?> difficulty,
  required String ingredients,
  required String steps,
  Value<String?> vegetableId,
  Value<String> source,
  Value<String?> userId,
  Value<bool> isPublic,
  Value<bool> isFavorite,
  Value<bool> isVegetarian,
  Value<bool> isVegan,
  Value<bool> containsGluten,
  Value<bool> containsLactose,
  Value<bool> containsNuts,
  Value<bool> containsEggs,
  Value<bool> containsSoy,
  Value<bool> containsFish,
  Value<bool> containsShellfish,
  Value<String?> category,
  Value<String> tags,
  Value<int> rowid,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> image,
  Value<int> prepTimeMin,
  Value<int> cookTimeMin,
  Value<int> servings,
  Value<String?> difficulty,
  Value<String> ingredients,
  Value<String> steps,
  Value<String?> vegetableId,
  Value<String> source,
  Value<String?> userId,
  Value<bool> isPublic,
  Value<bool> isFavorite,
  Value<bool> isVegetarian,
  Value<bool> isVegan,
  Value<bool> containsGluten,
  Value<bool> containsLactose,
  Value<bool> containsNuts,
  Value<bool> containsEggs,
  Value<bool> containsSoy,
  Value<bool> containsFish,
  Value<bool> containsShellfish,
  Value<String?> category,
  Value<String> tags,
  Value<int> rowid,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get prepTimeMin => $composableBuilder(
      column: $table.prepTimeMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookTimeMin => $composableBuilder(
      column: $table.cookTimeMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredients => $composableBuilder(
      column: $table.ingredients, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vegetableId => $composableBuilder(
      column: $table.vegetableId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPublic => $composableBuilder(
      column: $table.isPublic, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVegetarian => $composableBuilder(
      column: $table.isVegetarian, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVegan => $composableBuilder(
      column: $table.isVegan, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get containsGluten => $composableBuilder(
      column: $table.containsGluten,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get containsLactose => $composableBuilder(
      column: $table.containsLactose,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get containsNuts => $composableBuilder(
      column: $table.containsNuts, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get containsEggs => $composableBuilder(
      column: $table.containsEggs, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get containsSoy => $composableBuilder(
      column: $table.containsSoy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get containsFish => $composableBuilder(
      column: $table.containsFish, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get containsShellfish => $composableBuilder(
      column: $table.containsShellfish,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get prepTimeMin => $composableBuilder(
      column: $table.prepTimeMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookTimeMin => $composableBuilder(
      column: $table.cookTimeMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredients => $composableBuilder(
      column: $table.ingredients, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vegetableId => $composableBuilder(
      column: $table.vegetableId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPublic => $composableBuilder(
      column: $table.isPublic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVegetarian => $composableBuilder(
      column: $table.isVegetarian,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVegan => $composableBuilder(
      column: $table.isVegan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get containsGluten => $composableBuilder(
      column: $table.containsGluten,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get containsLactose => $composableBuilder(
      column: $table.containsLactose,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get containsNuts => $composableBuilder(
      column: $table.containsNuts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get containsEggs => $composableBuilder(
      column: $table.containsEggs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get containsSoy => $composableBuilder(
      column: $table.containsSoy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get containsFish => $composableBuilder(
      column: $table.containsFish,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get containsShellfish => $composableBuilder(
      column: $table.containsShellfish,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get prepTimeMin => $composableBuilder(
      column: $table.prepTimeMin, builder: (column) => column);

  GeneratedColumn<int> get cookTimeMin => $composableBuilder(
      column: $table.cookTimeMin, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get ingredients => $composableBuilder(
      column: $table.ingredients, builder: (column) => column);

  GeneratedColumn<String> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get vegetableId => $composableBuilder(
      column: $table.vegetableId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<bool> get isVegetarian => $composableBuilder(
      column: $table.isVegetarian, builder: (column) => column);

  GeneratedColumn<bool> get isVegan =>
      $composableBuilder(column: $table.isVegan, builder: (column) => column);

  GeneratedColumn<bool> get containsGluten => $composableBuilder(
      column: $table.containsGluten, builder: (column) => column);

  GeneratedColumn<bool> get containsLactose => $composableBuilder(
      column: $table.containsLactose, builder: (column) => column);

  GeneratedColumn<bool> get containsNuts => $composableBuilder(
      column: $table.containsNuts, builder: (column) => column);

  GeneratedColumn<bool> get containsEggs => $composableBuilder(
      column: $table.containsEggs, builder: (column) => column);

  GeneratedColumn<bool> get containsSoy => $composableBuilder(
      column: $table.containsSoy, builder: (column) => column);

  GeneratedColumn<bool> get containsFish => $composableBuilder(
      column: $table.containsFish, builder: (column) => column);

  GeneratedColumn<bool> get containsShellfish => $composableBuilder(
      column: $table.containsShellfish, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
    Recipe,
    PrefetchHooks Function()> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> image = const Value.absent(),
            Value<int> prepTimeMin = const Value.absent(),
            Value<int> cookTimeMin = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            Value<String> ingredients = const Value.absent(),
            Value<String> steps = const Value.absent(),
            Value<String?> vegetableId = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<bool> isPublic = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isVegetarian = const Value.absent(),
            Value<bool> isVegan = const Value.absent(),
            Value<bool> containsGluten = const Value.absent(),
            Value<bool> containsLactose = const Value.absent(),
            Value<bool> containsNuts = const Value.absent(),
            Value<bool> containsEggs = const Value.absent(),
            Value<bool> containsSoy = const Value.absent(),
            Value<bool> containsFish = const Value.absent(),
            Value<bool> containsShellfish = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            title: title,
            description: description,
            image: image,
            prepTimeMin: prepTimeMin,
            cookTimeMin: cookTimeMin,
            servings: servings,
            difficulty: difficulty,
            ingredients: ingredients,
            steps: steps,
            vegetableId: vegetableId,
            source: source,
            userId: userId,
            isPublic: isPublic,
            isFavorite: isFavorite,
            isVegetarian: isVegetarian,
            isVegan: isVegan,
            containsGluten: containsGluten,
            containsLactose: containsLactose,
            containsNuts: containsNuts,
            containsEggs: containsEggs,
            containsSoy: containsSoy,
            containsFish: containsFish,
            containsShellfish: containsShellfish,
            category: category,
            tags: tags,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> description = const Value.absent(),
            required String image,
            Value<int> prepTimeMin = const Value.absent(),
            Value<int> cookTimeMin = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<String?> difficulty = const Value.absent(),
            required String ingredients,
            required String steps,
            Value<String?> vegetableId = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<bool> isPublic = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isVegetarian = const Value.absent(),
            Value<bool> isVegan = const Value.absent(),
            Value<bool> containsGluten = const Value.absent(),
            Value<bool> containsLactose = const Value.absent(),
            Value<bool> containsNuts = const Value.absent(),
            Value<bool> containsEggs = const Value.absent(),
            Value<bool> containsSoy = const Value.absent(),
            Value<bool> containsFish = const Value.absent(),
            Value<bool> containsShellfish = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesCompanion.insert(
            id: id,
            title: title,
            description: description,
            image: image,
            prepTimeMin: prepTimeMin,
            cookTimeMin: cookTimeMin,
            servings: servings,
            difficulty: difficulty,
            ingredients: ingredients,
            steps: steps,
            vegetableId: vegetableId,
            source: source,
            userId: userId,
            isPublic: isPublic,
            isFavorite: isFavorite,
            isVegetarian: isVegetarian,
            isVegan: isVegan,
            containsGluten: containsGluten,
            containsLactose: containsLactose,
            containsNuts: containsNuts,
            containsEggs: containsEggs,
            containsSoy: containsSoy,
            containsFish: containsFish,
            containsShellfish: containsShellfish,
            category: category,
            tags: tags,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
    Recipe,
    PrefetchHooks Function()>;
typedef $$PlannedMealsTableCreateCompanionBuilder = PlannedMealsCompanion
    Function({
  required String id,
  required String userId,
  required DateTime date,
  required String slot,
  Value<String?> recipeId,
  Value<String?> customTitle,
  Value<int> servings,
  Value<int> rowid,
});
typedef $$PlannedMealsTableUpdateCompanionBuilder = PlannedMealsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<DateTime> date,
  Value<String> slot,
  Value<String?> recipeId,
  Value<String?> customTitle,
  Value<int> servings,
  Value<int> rowid,
});

class $$PlannedMealsTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedMealsTable> {
  $$PlannedMealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slot => $composableBuilder(
      column: $table.slot, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));
}

class $$PlannedMealsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedMealsTable> {
  $$PlannedMealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slot => $composableBuilder(
      column: $table.slot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));
}

class $$PlannedMealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedMealsTable> {
  $$PlannedMealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);
}

class $$PlannedMealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlannedMealsTable,
    PlannedMeal,
    $$PlannedMealsTableFilterComposer,
    $$PlannedMealsTableOrderingComposer,
    $$PlannedMealsTableAnnotationComposer,
    $$PlannedMealsTableCreateCompanionBuilder,
    $$PlannedMealsTableUpdateCompanionBuilder,
    (
      PlannedMeal,
      BaseReferences<_$AppDatabase, $PlannedMealsTable, PlannedMeal>
    ),
    PlannedMeal,
    PrefetchHooks Function()> {
  $$PlannedMealsTableTableManager(_$AppDatabase db, $PlannedMealsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedMealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedMealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedMealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> slot = const Value.absent(),
            Value<String?> recipeId = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlannedMealsCompanion(
            id: id,
            userId: userId,
            date: date,
            slot: slot,
            recipeId: recipeId,
            customTitle: customTitle,
            servings: servings,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required DateTime date,
            required String slot,
            Value<String?> recipeId = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlannedMealsCompanion.insert(
            id: id,
            userId: userId,
            date: date,
            slot: slot,
            recipeId: recipeId,
            customTitle: customTitle,
            servings: servings,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlannedMealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlannedMealsTable,
    PlannedMeal,
    $$PlannedMealsTableFilterComposer,
    $$PlannedMealsTableOrderingComposer,
    $$PlannedMealsTableAnnotationComposer,
    $$PlannedMealsTableCreateCompanionBuilder,
    $$PlannedMealsTableUpdateCompanionBuilder,
    (
      PlannedMeal,
      BaseReferences<_$AppDatabase, $PlannedMealsTable, PlannedMeal>
    ),
    PlannedMeal,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VegetablesTableTableManager get vegetables =>
      $$VegetablesTableTableManager(_db, _db.vegetables);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$PlannedMealsTableTableManager get plannedMeals =>
      $$PlannedMealsTableTableManager(_db, _db.plannedMeals);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'18ce5c8c4d8ddbfe5a7d819d8fb7d5aca76bf416';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
