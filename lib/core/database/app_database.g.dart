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

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
      'item', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCheckedMeta =
      const VerificationMeta('isChecked');
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
      'is_checked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_checked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sourceRecipeIdMeta =
      const VerificationMeta('sourceRecipeId');
  @override
  late final GeneratedColumn<String> sourceRecipeId = GeneratedColumn<String>(
      'source_recipe_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        item,
        amount,
        unit,
        note,
        isChecked,
        sourceRecipeId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingItem> instance,
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
    if (data.containsKey('item')) {
      context.handle(
          _itemMeta, item.isAcceptableOrUnknown(data['item']!, _itemMeta));
    } else if (isInserting) {
      context.missing(_itemMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_checked')) {
      context.handle(_isCheckedMeta,
          isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta));
    }
    if (data.containsKey('source_recipe_id')) {
      context.handle(
          _sourceRecipeIdMeta,
          sourceRecipeId.isAcceptableOrUnknown(
              data['source_recipe_id']!, _sourceRecipeIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      item: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isChecked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_checked'])!,
      sourceRecipeId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_recipe_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final String id;
  final String userId;
  final String item;
  final double? amount;
  final String? unit;
  final String? note;
  final bool isChecked;
  final String? sourceRecipeId;
  final DateTime createdAt;
  const ShoppingItem(
      {required this.id,
      required this.userId,
      required this.item,
      this.amount,
      this.unit,
      this.note,
      required this.isChecked,
      this.sourceRecipeId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['item'] = Variable<String>(item);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_checked'] = Variable<bool>(isChecked);
    if (!nullToAbsent || sourceRecipeId != null) {
      map['source_recipe_id'] = Variable<String>(sourceRecipeId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      userId: Value(userId),
      item: Value(item),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isChecked: Value(isChecked),
      sourceRecipeId: sourceRecipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRecipeId),
      createdAt: Value(createdAt),
    );
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      item: serializer.fromJson<String>(json['item']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      note: serializer.fromJson<String?>(json['note']),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
      sourceRecipeId: serializer.fromJson<String?>(json['sourceRecipeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'item': serializer.toJson<String>(item),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'note': serializer.toJson<String?>(note),
      'isChecked': serializer.toJson<bool>(isChecked),
      'sourceRecipeId': serializer.toJson<String?>(sourceRecipeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShoppingItem copyWith(
          {String? id,
          String? userId,
          String? item,
          Value<double?> amount = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? isChecked,
          Value<String?> sourceRecipeId = const Value.absent(),
          DateTime? createdAt}) =>
      ShoppingItem(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        item: item ?? this.item,
        amount: amount.present ? amount.value : this.amount,
        unit: unit.present ? unit.value : this.unit,
        note: note.present ? note.value : this.note,
        isChecked: isChecked ?? this.isChecked,
        sourceRecipeId:
            sourceRecipeId.present ? sourceRecipeId.value : this.sourceRecipeId,
        createdAt: createdAt ?? this.createdAt,
      );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      item: data.item.present ? data.item.value : this.item,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      note: data.note.present ? data.note.value : this.note,
      isChecked: data.isChecked.present ? data.isChecked.value : this.isChecked,
      sourceRecipeId: data.sourceRecipeId.present
          ? data.sourceRecipeId.value
          : this.sourceRecipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('item: $item, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('isChecked: $isChecked, ')
          ..write('sourceRecipeId: $sourceRecipeId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, item, amount, unit, note,
      isChecked, sourceRecipeId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.item == this.item &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.note == this.note &&
          other.isChecked == this.isChecked &&
          other.sourceRecipeId == this.sourceRecipeId &&
          other.createdAt == this.createdAt);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> item;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> note;
  final Value<bool> isChecked;
  final Value<String?> sourceRecipeId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.item = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.sourceRecipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    required String id,
    required String userId,
    required String item,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.sourceRecipeId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        item = Value(item),
        createdAt = Value(createdAt);
  static Insertable<ShoppingItem> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? item,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? note,
    Expression<bool>? isChecked,
    Expression<String>? sourceRecipeId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (item != null) 'item': item,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (isChecked != null) 'is_checked': isChecked,
      if (sourceRecipeId != null) 'source_recipe_id': sourceRecipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? item,
      Value<double?>? amount,
      Value<String?>? unit,
      Value<String?>? note,
      Value<bool>? isChecked,
      Value<String?>? sourceRecipeId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      item: item ?? this.item,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      isChecked: isChecked ?? this.isChecked,
      sourceRecipeId: sourceRecipeId ?? this.sourceRecipeId,
      createdAt: createdAt ?? this.createdAt,
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
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (sourceRecipeId.present) {
      map['source_recipe_id'] = Variable<String>(sourceRecipeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('item: $item, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('isChecked: $isChecked, ')
          ..write('sourceRecipeId: $sourceRecipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AIProfilesTable extends AIProfiles
    with TableInfo<$AIProfilesTable, AIProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AIProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cuisinePreferencesMeta =
      const VerificationMeta('cuisinePreferences');
  @override
  late final GeneratedColumn<String> cuisinePreferences =
      GeneratedColumn<String>('cuisine_preferences', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _flavorProfileMeta =
      const VerificationMeta('flavorProfile');
  @override
  late final GeneratedColumn<String> flavorProfile = GeneratedColumn<String>(
      'flavor_profile', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<String> likes = GeneratedColumn<String>(
      'likes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _proteinPreferencesMeta =
      const VerificationMeta('proteinPreferences');
  @override
  late final GeneratedColumn<String> proteinPreferences =
      GeneratedColumn<String>('protein_preferences', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _budgetLevelMeta =
      const VerificationMeta('budgetLevel');
  @override
  late final GeneratedColumn<String> budgetLevel = GeneratedColumn<String>(
      'budget_level', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('normal'));
  static const VerificationMeta _mealPrepStyleMeta =
      const VerificationMeta('mealPrepStyle');
  @override
  late final GeneratedColumn<String> mealPrepStyle = GeneratedColumn<String>(
      'meal_prep_style', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('mixed'));
  static const VerificationMeta _cookingDaysPerWeekMeta =
      const VerificationMeta('cookingDaysPerWeek');
  @override
  late final GeneratedColumn<int> cookingDaysPerWeek = GeneratedColumn<int>(
      'cooking_days_per_week', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _healthGoalsMeta =
      const VerificationMeta('healthGoals');
  @override
  late final GeneratedColumn<String> healthGoals = GeneratedColumn<String>(
      'health_goals', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _nutritionFocusMeta =
      const VerificationMeta('nutritionFocus');
  @override
  late final GeneratedColumn<String> nutritionFocus = GeneratedColumn<String>(
      'nutrition_focus', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('balanced'));
  static const VerificationMeta _equipmentMeta =
      const VerificationMeta('equipment');
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
      'equipment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _learningContextMeta =
      const VerificationMeta('learningContext');
  @override
  late final GeneratedColumn<String> learningContext = GeneratedColumn<String>(
      'learning_context', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
      'onboarding_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("onboarding_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        cuisinePreferences,
        flavorProfile,
        likes,
        proteinPreferences,
        budgetLevel,
        mealPrepStyle,
        cookingDaysPerWeek,
        healthGoals,
        nutritionFocus,
        equipment,
        learningContext,
        onboardingCompleted,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'a_i_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<AIProfile> instance,
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
    if (data.containsKey('cuisine_preferences')) {
      context.handle(
          _cuisinePreferencesMeta,
          cuisinePreferences.isAcceptableOrUnknown(
              data['cuisine_preferences']!, _cuisinePreferencesMeta));
    }
    if (data.containsKey('flavor_profile')) {
      context.handle(
          _flavorProfileMeta,
          flavorProfile.isAcceptableOrUnknown(
              data['flavor_profile']!, _flavorProfileMeta));
    }
    if (data.containsKey('likes')) {
      context.handle(
          _likesMeta, likes.isAcceptableOrUnknown(data['likes']!, _likesMeta));
    }
    if (data.containsKey('protein_preferences')) {
      context.handle(
          _proteinPreferencesMeta,
          proteinPreferences.isAcceptableOrUnknown(
              data['protein_preferences']!, _proteinPreferencesMeta));
    }
    if (data.containsKey('budget_level')) {
      context.handle(
          _budgetLevelMeta,
          budgetLevel.isAcceptableOrUnknown(
              data['budget_level']!, _budgetLevelMeta));
    }
    if (data.containsKey('meal_prep_style')) {
      context.handle(
          _mealPrepStyleMeta,
          mealPrepStyle.isAcceptableOrUnknown(
              data['meal_prep_style']!, _mealPrepStyleMeta));
    }
    if (data.containsKey('cooking_days_per_week')) {
      context.handle(
          _cookingDaysPerWeekMeta,
          cookingDaysPerWeek.isAcceptableOrUnknown(
              data['cooking_days_per_week']!, _cookingDaysPerWeekMeta));
    }
    if (data.containsKey('health_goals')) {
      context.handle(
          _healthGoalsMeta,
          healthGoals.isAcceptableOrUnknown(
              data['health_goals']!, _healthGoalsMeta));
    }
    if (data.containsKey('nutrition_focus')) {
      context.handle(
          _nutritionFocusMeta,
          nutritionFocus.isAcceptableOrUnknown(
              data['nutrition_focus']!, _nutritionFocusMeta));
    }
    if (data.containsKey('equipment')) {
      context.handle(_equipmentMeta,
          equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta));
    }
    if (data.containsKey('learning_context')) {
      context.handle(
          _learningContextMeta,
          learningContext.isAcceptableOrUnknown(
              data['learning_context']!, _learningContextMeta));
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
          _onboardingCompletedMeta,
          onboardingCompleted.isAcceptableOrUnknown(
              data['onboarding_completed']!, _onboardingCompletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AIProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AIProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      cuisinePreferences: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cuisine_preferences'])!,
      flavorProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flavor_profile'])!,
      likes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}likes'])!,
      proteinPreferences: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}protein_preferences'])!,
      budgetLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}budget_level'])!,
      mealPrepStyle: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}meal_prep_style'])!,
      cookingDaysPerWeek: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}cooking_days_per_week'])!,
      healthGoals: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}health_goals'])!,
      nutritionFocus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nutrition_focus'])!,
      equipment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!,
      learningContext: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}learning_context'])!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}onboarding_completed'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $AIProfilesTable createAlias(String alias) {
    return $AIProfilesTable(attachedDatabase, alias);
  }
}

class AIProfile extends DataClass implements Insertable<AIProfile> {
  final String id;
  final String userId;
  final String cuisinePreferences;
  final String flavorProfile;
  final String likes;
  final String proteinPreferences;
  final String budgetLevel;
  final String mealPrepStyle;
  final int cookingDaysPerWeek;
  final String healthGoals;
  final String nutritionFocus;
  final String equipment;
  final String learningContext;
  final bool onboardingCompleted;
  final DateTime? updatedAt;
  const AIProfile(
      {required this.id,
      required this.userId,
      required this.cuisinePreferences,
      required this.flavorProfile,
      required this.likes,
      required this.proteinPreferences,
      required this.budgetLevel,
      required this.mealPrepStyle,
      required this.cookingDaysPerWeek,
      required this.healthGoals,
      required this.nutritionFocus,
      required this.equipment,
      required this.learningContext,
      required this.onboardingCompleted,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['cuisine_preferences'] = Variable<String>(cuisinePreferences);
    map['flavor_profile'] = Variable<String>(flavorProfile);
    map['likes'] = Variable<String>(likes);
    map['protein_preferences'] = Variable<String>(proteinPreferences);
    map['budget_level'] = Variable<String>(budgetLevel);
    map['meal_prep_style'] = Variable<String>(mealPrepStyle);
    map['cooking_days_per_week'] = Variable<int>(cookingDaysPerWeek);
    map['health_goals'] = Variable<String>(healthGoals);
    map['nutrition_focus'] = Variable<String>(nutritionFocus);
    map['equipment'] = Variable<String>(equipment);
    map['learning_context'] = Variable<String>(learningContext);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  AIProfilesCompanion toCompanion(bool nullToAbsent) {
    return AIProfilesCompanion(
      id: Value(id),
      userId: Value(userId),
      cuisinePreferences: Value(cuisinePreferences),
      flavorProfile: Value(flavorProfile),
      likes: Value(likes),
      proteinPreferences: Value(proteinPreferences),
      budgetLevel: Value(budgetLevel),
      mealPrepStyle: Value(mealPrepStyle),
      cookingDaysPerWeek: Value(cookingDaysPerWeek),
      healthGoals: Value(healthGoals),
      nutritionFocus: Value(nutritionFocus),
      equipment: Value(equipment),
      learningContext: Value(learningContext),
      onboardingCompleted: Value(onboardingCompleted),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory AIProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AIProfile(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      cuisinePreferences:
          serializer.fromJson<String>(json['cuisinePreferences']),
      flavorProfile: serializer.fromJson<String>(json['flavorProfile']),
      likes: serializer.fromJson<String>(json['likes']),
      proteinPreferences:
          serializer.fromJson<String>(json['proteinPreferences']),
      budgetLevel: serializer.fromJson<String>(json['budgetLevel']),
      mealPrepStyle: serializer.fromJson<String>(json['mealPrepStyle']),
      cookingDaysPerWeek: serializer.fromJson<int>(json['cookingDaysPerWeek']),
      healthGoals: serializer.fromJson<String>(json['healthGoals']),
      nutritionFocus: serializer.fromJson<String>(json['nutritionFocus']),
      equipment: serializer.fromJson<String>(json['equipment']),
      learningContext: serializer.fromJson<String>(json['learningContext']),
      onboardingCompleted:
          serializer.fromJson<bool>(json['onboardingCompleted']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'cuisinePreferences': serializer.toJson<String>(cuisinePreferences),
      'flavorProfile': serializer.toJson<String>(flavorProfile),
      'likes': serializer.toJson<String>(likes),
      'proteinPreferences': serializer.toJson<String>(proteinPreferences),
      'budgetLevel': serializer.toJson<String>(budgetLevel),
      'mealPrepStyle': serializer.toJson<String>(mealPrepStyle),
      'cookingDaysPerWeek': serializer.toJson<int>(cookingDaysPerWeek),
      'healthGoals': serializer.toJson<String>(healthGoals),
      'nutritionFocus': serializer.toJson<String>(nutritionFocus),
      'equipment': serializer.toJson<String>(equipment),
      'learningContext': serializer.toJson<String>(learningContext),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  AIProfile copyWith(
          {String? id,
          String? userId,
          String? cuisinePreferences,
          String? flavorProfile,
          String? likes,
          String? proteinPreferences,
          String? budgetLevel,
          String? mealPrepStyle,
          int? cookingDaysPerWeek,
          String? healthGoals,
          String? nutritionFocus,
          String? equipment,
          String? learningContext,
          bool? onboardingCompleted,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      AIProfile(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        cuisinePreferences: cuisinePreferences ?? this.cuisinePreferences,
        flavorProfile: flavorProfile ?? this.flavorProfile,
        likes: likes ?? this.likes,
        proteinPreferences: proteinPreferences ?? this.proteinPreferences,
        budgetLevel: budgetLevel ?? this.budgetLevel,
        mealPrepStyle: mealPrepStyle ?? this.mealPrepStyle,
        cookingDaysPerWeek: cookingDaysPerWeek ?? this.cookingDaysPerWeek,
        healthGoals: healthGoals ?? this.healthGoals,
        nutritionFocus: nutritionFocus ?? this.nutritionFocus,
        equipment: equipment ?? this.equipment,
        learningContext: learningContext ?? this.learningContext,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  AIProfile copyWithCompanion(AIProfilesCompanion data) {
    return AIProfile(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      cuisinePreferences: data.cuisinePreferences.present
          ? data.cuisinePreferences.value
          : this.cuisinePreferences,
      flavorProfile: data.flavorProfile.present
          ? data.flavorProfile.value
          : this.flavorProfile,
      likes: data.likes.present ? data.likes.value : this.likes,
      proteinPreferences: data.proteinPreferences.present
          ? data.proteinPreferences.value
          : this.proteinPreferences,
      budgetLevel:
          data.budgetLevel.present ? data.budgetLevel.value : this.budgetLevel,
      mealPrepStyle: data.mealPrepStyle.present
          ? data.mealPrepStyle.value
          : this.mealPrepStyle,
      cookingDaysPerWeek: data.cookingDaysPerWeek.present
          ? data.cookingDaysPerWeek.value
          : this.cookingDaysPerWeek,
      healthGoals:
          data.healthGoals.present ? data.healthGoals.value : this.healthGoals,
      nutritionFocus: data.nutritionFocus.present
          ? data.nutritionFocus.value
          : this.nutritionFocus,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      learningContext: data.learningContext.present
          ? data.learningContext.value
          : this.learningContext,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AIProfile(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cuisinePreferences: $cuisinePreferences, ')
          ..write('flavorProfile: $flavorProfile, ')
          ..write('likes: $likes, ')
          ..write('proteinPreferences: $proteinPreferences, ')
          ..write('budgetLevel: $budgetLevel, ')
          ..write('mealPrepStyle: $mealPrepStyle, ')
          ..write('cookingDaysPerWeek: $cookingDaysPerWeek, ')
          ..write('healthGoals: $healthGoals, ')
          ..write('nutritionFocus: $nutritionFocus, ')
          ..write('equipment: $equipment, ')
          ..write('learningContext: $learningContext, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      cuisinePreferences,
      flavorProfile,
      likes,
      proteinPreferences,
      budgetLevel,
      mealPrepStyle,
      cookingDaysPerWeek,
      healthGoals,
      nutritionFocus,
      equipment,
      learningContext,
      onboardingCompleted,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AIProfile &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.cuisinePreferences == this.cuisinePreferences &&
          other.flavorProfile == this.flavorProfile &&
          other.likes == this.likes &&
          other.proteinPreferences == this.proteinPreferences &&
          other.budgetLevel == this.budgetLevel &&
          other.mealPrepStyle == this.mealPrepStyle &&
          other.cookingDaysPerWeek == this.cookingDaysPerWeek &&
          other.healthGoals == this.healthGoals &&
          other.nutritionFocus == this.nutritionFocus &&
          other.equipment == this.equipment &&
          other.learningContext == this.learningContext &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.updatedAt == this.updatedAt);
}

class AIProfilesCompanion extends UpdateCompanion<AIProfile> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> cuisinePreferences;
  final Value<String> flavorProfile;
  final Value<String> likes;
  final Value<String> proteinPreferences;
  final Value<String> budgetLevel;
  final Value<String> mealPrepStyle;
  final Value<int> cookingDaysPerWeek;
  final Value<String> healthGoals;
  final Value<String> nutritionFocus;
  final Value<String> equipment;
  final Value<String> learningContext;
  final Value<bool> onboardingCompleted;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const AIProfilesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.cuisinePreferences = const Value.absent(),
    this.flavorProfile = const Value.absent(),
    this.likes = const Value.absent(),
    this.proteinPreferences = const Value.absent(),
    this.budgetLevel = const Value.absent(),
    this.mealPrepStyle = const Value.absent(),
    this.cookingDaysPerWeek = const Value.absent(),
    this.healthGoals = const Value.absent(),
    this.nutritionFocus = const Value.absent(),
    this.equipment = const Value.absent(),
    this.learningContext = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AIProfilesCompanion.insert({
    required String id,
    required String userId,
    this.cuisinePreferences = const Value.absent(),
    this.flavorProfile = const Value.absent(),
    this.likes = const Value.absent(),
    this.proteinPreferences = const Value.absent(),
    this.budgetLevel = const Value.absent(),
    this.mealPrepStyle = const Value.absent(),
    this.cookingDaysPerWeek = const Value.absent(),
    this.healthGoals = const Value.absent(),
    this.nutritionFocus = const Value.absent(),
    this.equipment = const Value.absent(),
    this.learningContext = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId);
  static Insertable<AIProfile> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? cuisinePreferences,
    Expression<String>? flavorProfile,
    Expression<String>? likes,
    Expression<String>? proteinPreferences,
    Expression<String>? budgetLevel,
    Expression<String>? mealPrepStyle,
    Expression<int>? cookingDaysPerWeek,
    Expression<String>? healthGoals,
    Expression<String>? nutritionFocus,
    Expression<String>? equipment,
    Expression<String>? learningContext,
    Expression<bool>? onboardingCompleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (cuisinePreferences != null) 'cuisine_preferences': cuisinePreferences,
      if (flavorProfile != null) 'flavor_profile': flavorProfile,
      if (likes != null) 'likes': likes,
      if (proteinPreferences != null) 'protein_preferences': proteinPreferences,
      if (budgetLevel != null) 'budget_level': budgetLevel,
      if (mealPrepStyle != null) 'meal_prep_style': mealPrepStyle,
      if (cookingDaysPerWeek != null)
        'cooking_days_per_week': cookingDaysPerWeek,
      if (healthGoals != null) 'health_goals': healthGoals,
      if (nutritionFocus != null) 'nutrition_focus': nutritionFocus,
      if (equipment != null) 'equipment': equipment,
      if (learningContext != null) 'learning_context': learningContext,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AIProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? cuisinePreferences,
      Value<String>? flavorProfile,
      Value<String>? likes,
      Value<String>? proteinPreferences,
      Value<String>? budgetLevel,
      Value<String>? mealPrepStyle,
      Value<int>? cookingDaysPerWeek,
      Value<String>? healthGoals,
      Value<String>? nutritionFocus,
      Value<String>? equipment,
      Value<String>? learningContext,
      Value<bool>? onboardingCompleted,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return AIProfilesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cuisinePreferences: cuisinePreferences ?? this.cuisinePreferences,
      flavorProfile: flavorProfile ?? this.flavorProfile,
      likes: likes ?? this.likes,
      proteinPreferences: proteinPreferences ?? this.proteinPreferences,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      mealPrepStyle: mealPrepStyle ?? this.mealPrepStyle,
      cookingDaysPerWeek: cookingDaysPerWeek ?? this.cookingDaysPerWeek,
      healthGoals: healthGoals ?? this.healthGoals,
      nutritionFocus: nutritionFocus ?? this.nutritionFocus,
      equipment: equipment ?? this.equipment,
      learningContext: learningContext ?? this.learningContext,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (cuisinePreferences.present) {
      map['cuisine_preferences'] = Variable<String>(cuisinePreferences.value);
    }
    if (flavorProfile.present) {
      map['flavor_profile'] = Variable<String>(flavorProfile.value);
    }
    if (likes.present) {
      map['likes'] = Variable<String>(likes.value);
    }
    if (proteinPreferences.present) {
      map['protein_preferences'] = Variable<String>(proteinPreferences.value);
    }
    if (budgetLevel.present) {
      map['budget_level'] = Variable<String>(budgetLevel.value);
    }
    if (mealPrepStyle.present) {
      map['meal_prep_style'] = Variable<String>(mealPrepStyle.value);
    }
    if (cookingDaysPerWeek.present) {
      map['cooking_days_per_week'] = Variable<int>(cookingDaysPerWeek.value);
    }
    if (healthGoals.present) {
      map['health_goals'] = Variable<String>(healthGoals.value);
    }
    if (nutritionFocus.present) {
      map['nutrition_focus'] = Variable<String>(nutritionFocus.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (learningContext.present) {
      map['learning_context'] = Variable<String>(learningContext.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AIProfilesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cuisinePreferences: $cuisinePreferences, ')
          ..write('flavorProfile: $flavorProfile, ')
          ..write('likes: $likes, ')
          ..write('proteinPreferences: $proteinPreferences, ')
          ..write('budgetLevel: $budgetLevel, ')
          ..write('mealPrepStyle: $mealPrepStyle, ')
          ..write('cookingDaysPerWeek: $cookingDaysPerWeek, ')
          ..write('healthGoals: $healthGoals, ')
          ..write('nutritionFocus: $nutritionFocus, ')
          ..write('equipment: $equipment, ')
          ..write('learningContext: $learningContext, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $AIProfilesTable aIProfiles = $AIProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [vegetables, recipes, plannedMeals, shoppingItems, aIProfiles];
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
typedef $$ShoppingItemsTableCreateCompanionBuilder = ShoppingItemsCompanion
    Function({
  required String id,
  required String userId,
  required String item,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
  Value<bool> isChecked,
  Value<String?> sourceRecipeId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ShoppingItemsTableUpdateCompanionBuilder = ShoppingItemsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> item,
  Value<double?> amount,
  Value<String?> unit,
  Value<String?> note,
  Value<bool> isChecked,
  Value<String?> sourceRecipeId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
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

  ColumnFilters<String> get item => $composableBuilder(
      column: $table.item, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isChecked => $composableBuilder(
      column: $table.isChecked, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceRecipeId => $composableBuilder(
      column: $table.sourceRecipeId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
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

  ColumnOrderings<String> get item => $composableBuilder(
      column: $table.item, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isChecked => $composableBuilder(
      column: $table.isChecked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceRecipeId => $composableBuilder(
      column: $table.sourceRecipeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isChecked =>
      $composableBuilder(column: $table.isChecked, builder: (column) => column);

  GeneratedColumn<String> get sourceRecipeId => $composableBuilder(
      column: $table.sourceRecipeId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ShoppingItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingItemsTable,
    ShoppingItem,
    $$ShoppingItemsTableFilterComposer,
    $$ShoppingItemsTableOrderingComposer,
    $$ShoppingItemsTableAnnotationComposer,
    $$ShoppingItemsTableCreateCompanionBuilder,
    $$ShoppingItemsTableUpdateCompanionBuilder,
    (
      ShoppingItem,
      BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>
    ),
    ShoppingItem,
    PrefetchHooks Function()> {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> item = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isChecked = const Value.absent(),
            Value<String?> sourceRecipeId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingItemsCompanion(
            id: id,
            userId: userId,
            item: item,
            amount: amount,
            unit: unit,
            note: note,
            isChecked: isChecked,
            sourceRecipeId: sourceRecipeId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String item,
            Value<double?> amount = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isChecked = const Value.absent(),
            Value<String?> sourceRecipeId = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ShoppingItemsCompanion.insert(
            id: id,
            userId: userId,
            item: item,
            amount: amount,
            unit: unit,
            note: note,
            isChecked: isChecked,
            sourceRecipeId: sourceRecipeId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShoppingItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingItemsTable,
    ShoppingItem,
    $$ShoppingItemsTableFilterComposer,
    $$ShoppingItemsTableOrderingComposer,
    $$ShoppingItemsTableAnnotationComposer,
    $$ShoppingItemsTableCreateCompanionBuilder,
    $$ShoppingItemsTableUpdateCompanionBuilder,
    (
      ShoppingItem,
      BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>
    ),
    ShoppingItem,
    PrefetchHooks Function()>;
typedef $$AIProfilesTableCreateCompanionBuilder = AIProfilesCompanion Function({
  required String id,
  required String userId,
  Value<String> cuisinePreferences,
  Value<String> flavorProfile,
  Value<String> likes,
  Value<String> proteinPreferences,
  Value<String> budgetLevel,
  Value<String> mealPrepStyle,
  Value<int> cookingDaysPerWeek,
  Value<String> healthGoals,
  Value<String> nutritionFocus,
  Value<String> equipment,
  Value<String> learningContext,
  Value<bool> onboardingCompleted,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$AIProfilesTableUpdateCompanionBuilder = AIProfilesCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> cuisinePreferences,
  Value<String> flavorProfile,
  Value<String> likes,
  Value<String> proteinPreferences,
  Value<String> budgetLevel,
  Value<String> mealPrepStyle,
  Value<int> cookingDaysPerWeek,
  Value<String> healthGoals,
  Value<String> nutritionFocus,
  Value<String> equipment,
  Value<String> learningContext,
  Value<bool> onboardingCompleted,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$AIProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $AIProfilesTable> {
  $$AIProfilesTableFilterComposer({
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

  ColumnFilters<String> get cuisinePreferences => $composableBuilder(
      column: $table.cuisinePreferences,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flavorProfile => $composableBuilder(
      column: $table.flavorProfile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get likes => $composableBuilder(
      column: $table.likes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proteinPreferences => $composableBuilder(
      column: $table.proteinPreferences,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetLevel => $composableBuilder(
      column: $table.budgetLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealPrepStyle => $composableBuilder(
      column: $table.mealPrepStyle, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookingDaysPerWeek => $composableBuilder(
      column: $table.cookingDaysPerWeek,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get healthGoals => $composableBuilder(
      column: $table.healthGoals, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nutritionFocus => $composableBuilder(
      column: $table.nutritionFocus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get learningContext => $composableBuilder(
      column: $table.learningContext,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AIProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $AIProfilesTable> {
  $$AIProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get cuisinePreferences => $composableBuilder(
      column: $table.cuisinePreferences,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flavorProfile => $composableBuilder(
      column: $table.flavorProfile,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get likes => $composableBuilder(
      column: $table.likes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proteinPreferences => $composableBuilder(
      column: $table.proteinPreferences,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetLevel => $composableBuilder(
      column: $table.budgetLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealPrepStyle => $composableBuilder(
      column: $table.mealPrepStyle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookingDaysPerWeek => $composableBuilder(
      column: $table.cookingDaysPerWeek,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get healthGoals => $composableBuilder(
      column: $table.healthGoals, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nutritionFocus => $composableBuilder(
      column: $table.nutritionFocus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get learningContext => $composableBuilder(
      column: $table.learningContext,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AIProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AIProfilesTable> {
  $$AIProfilesTableAnnotationComposer({
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

  GeneratedColumn<String> get cuisinePreferences => $composableBuilder(
      column: $table.cuisinePreferences, builder: (column) => column);

  GeneratedColumn<String> get flavorProfile => $composableBuilder(
      column: $table.flavorProfile, builder: (column) => column);

  GeneratedColumn<String> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<String> get proteinPreferences => $composableBuilder(
      column: $table.proteinPreferences, builder: (column) => column);

  GeneratedColumn<String> get budgetLevel => $composableBuilder(
      column: $table.budgetLevel, builder: (column) => column);

  GeneratedColumn<String> get mealPrepStyle => $composableBuilder(
      column: $table.mealPrepStyle, builder: (column) => column);

  GeneratedColumn<int> get cookingDaysPerWeek => $composableBuilder(
      column: $table.cookingDaysPerWeek, builder: (column) => column);

  GeneratedColumn<String> get healthGoals => $composableBuilder(
      column: $table.healthGoals, builder: (column) => column);

  GeneratedColumn<String> get nutritionFocus => $composableBuilder(
      column: $table.nutritionFocus, builder: (column) => column);

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get learningContext => $composableBuilder(
      column: $table.learningContext, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
      column: $table.onboardingCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AIProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AIProfilesTable,
    AIProfile,
    $$AIProfilesTableFilterComposer,
    $$AIProfilesTableOrderingComposer,
    $$AIProfilesTableAnnotationComposer,
    $$AIProfilesTableCreateCompanionBuilder,
    $$AIProfilesTableUpdateCompanionBuilder,
    (AIProfile, BaseReferences<_$AppDatabase, $AIProfilesTable, AIProfile>),
    AIProfile,
    PrefetchHooks Function()> {
  $$AIProfilesTableTableManager(_$AppDatabase db, $AIProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AIProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AIProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AIProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> cuisinePreferences = const Value.absent(),
            Value<String> flavorProfile = const Value.absent(),
            Value<String> likes = const Value.absent(),
            Value<String> proteinPreferences = const Value.absent(),
            Value<String> budgetLevel = const Value.absent(),
            Value<String> mealPrepStyle = const Value.absent(),
            Value<int> cookingDaysPerWeek = const Value.absent(),
            Value<String> healthGoals = const Value.absent(),
            Value<String> nutritionFocus = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> learningContext = const Value.absent(),
            Value<bool> onboardingCompleted = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AIProfilesCompanion(
            id: id,
            userId: userId,
            cuisinePreferences: cuisinePreferences,
            flavorProfile: flavorProfile,
            likes: likes,
            proteinPreferences: proteinPreferences,
            budgetLevel: budgetLevel,
            mealPrepStyle: mealPrepStyle,
            cookingDaysPerWeek: cookingDaysPerWeek,
            healthGoals: healthGoals,
            nutritionFocus: nutritionFocus,
            equipment: equipment,
            learningContext: learningContext,
            onboardingCompleted: onboardingCompleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String> cuisinePreferences = const Value.absent(),
            Value<String> flavorProfile = const Value.absent(),
            Value<String> likes = const Value.absent(),
            Value<String> proteinPreferences = const Value.absent(),
            Value<String> budgetLevel = const Value.absent(),
            Value<String> mealPrepStyle = const Value.absent(),
            Value<int> cookingDaysPerWeek = const Value.absent(),
            Value<String> healthGoals = const Value.absent(),
            Value<String> nutritionFocus = const Value.absent(),
            Value<String> equipment = const Value.absent(),
            Value<String> learningContext = const Value.absent(),
            Value<bool> onboardingCompleted = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AIProfilesCompanion.insert(
            id: id,
            userId: userId,
            cuisinePreferences: cuisinePreferences,
            flavorProfile: flavorProfile,
            likes: likes,
            proteinPreferences: proteinPreferences,
            budgetLevel: budgetLevel,
            mealPrepStyle: mealPrepStyle,
            cookingDaysPerWeek: cookingDaysPerWeek,
            healthGoals: healthGoals,
            nutritionFocus: nutritionFocus,
            equipment: equipment,
            learningContext: learningContext,
            onboardingCompleted: onboardingCompleted,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AIProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AIProfilesTable,
    AIProfile,
    $$AIProfilesTableFilterComposer,
    $$AIProfilesTableOrderingComposer,
    $$AIProfilesTableAnnotationComposer,
    $$AIProfilesTableCreateCompanionBuilder,
    $$AIProfilesTableUpdateCompanionBuilder,
    (AIProfile, BaseReferences<_$AppDatabase, $AIProfilesTable, AIProfile>),
    AIProfile,
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
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$AIProfilesTableTableManager get aIProfiles =>
      $$AIProfilesTableTableManager(_db, _db.aIProfiles);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'448adad5717e7b1c0b3ca3ca7e03d0b2116237af';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
