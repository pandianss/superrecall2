// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_schemas.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSrsIntervalSchemaCollection on Isar {
  IsarCollection<SrsIntervalSchema> get srsIntervalSchemas => this.collection();
}

const SrsIntervalSchemaSchema = CollectionSchema(
  name: r'SrsIntervalSchema',
  id: 3271109152694939136,
  properties: {
    r'easeFactor': PropertySchema(
      id: 0,
      name: r'easeFactor',
      type: IsarType.double,
    ),
    r'intervalDays': PropertySchema(
      id: 1,
      name: r'intervalDays',
      type: IsarType.long,
    ),
    r'itemId': PropertySchema(
      id: 2,
      name: r'itemId',
      type: IsarType.string,
    ),
    r'nextReview': PropertySchema(
      id: 3,
      name: r'nextReview',
      type: IsarType.dateTime,
    ),
    r'repetitions': PropertySchema(
      id: 4,
      name: r'repetitions',
      type: IsarType.long,
    )
  },
  estimateSize: _srsIntervalSchemaEstimateSize,
  serialize: _srsIntervalSchemaSerialize,
  deserialize: _srsIntervalSchemaDeserialize,
  deserializeProp: _srsIntervalSchemaDeserializeProp,
  idName: r'id',
  indexes: {
    r'itemId': IndexSchema(
      id: -5342806140158601216,
      name: r'itemId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'itemId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _srsIntervalSchemaGetId,
  getLinks: _srsIntervalSchemaGetLinks,
  attach: _srsIntervalSchemaAttach,
  version: '3.1.0+1',
);

int _srsIntervalSchemaEstimateSize(
  SrsIntervalSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.itemId.length * 3;
  return bytesCount;
}

void _srsIntervalSchemaSerialize(
  SrsIntervalSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.easeFactor);
  writer.writeLong(offsets[1], object.intervalDays);
  writer.writeString(offsets[2], object.itemId);
  writer.writeDateTime(offsets[3], object.nextReview);
  writer.writeLong(offsets[4], object.repetitions);
}

SrsIntervalSchema _srsIntervalSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SrsIntervalSchema();
  object.easeFactor = reader.readDouble(offsets[0]);
  object.id = id;
  object.intervalDays = reader.readLong(offsets[1]);
  object.itemId = reader.readString(offsets[2]);
  object.nextReview = reader.readDateTime(offsets[3]);
  object.repetitions = reader.readLong(offsets[4]);
  return object;
}

P _srsIntervalSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _srsIntervalSchemaGetId(SrsIntervalSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _srsIntervalSchemaGetLinks(
    SrsIntervalSchema object) {
  return [];
}

void _srsIntervalSchemaAttach(
    IsarCollection<dynamic> col, Id id, SrsIntervalSchema object) {
  object.id = id;
}

extension SrsIntervalSchemaByIndex on IsarCollection<SrsIntervalSchema> {
  Future<SrsIntervalSchema?> getByItemId(String itemId) {
    return getByIndex(r'itemId', [itemId]);
  }

  SrsIntervalSchema? getByItemIdSync(String itemId) {
    return getByIndexSync(r'itemId', [itemId]);
  }

  Future<bool> deleteByItemId(String itemId) {
    return deleteByIndex(r'itemId', [itemId]);
  }

  bool deleteByItemIdSync(String itemId) {
    return deleteByIndexSync(r'itemId', [itemId]);
  }

  Future<List<SrsIntervalSchema?>> getAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'itemId', values);
  }

  List<SrsIntervalSchema?> getAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'itemId', values);
  }

  Future<int> deleteAllByItemId(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'itemId', values);
  }

  int deleteAllByItemIdSync(List<String> itemIdValues) {
    final values = itemIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'itemId', values);
  }

  Future<Id> putByItemId(SrsIntervalSchema object) {
    return putByIndex(r'itemId', object);
  }

  Id putByItemIdSync(SrsIntervalSchema object, {bool saveLinks = true}) {
    return putByIndexSync(r'itemId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByItemId(List<SrsIntervalSchema> objects) {
    return putAllByIndex(r'itemId', objects);
  }

  List<Id> putAllByItemIdSync(List<SrsIntervalSchema> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'itemId', objects, saveLinks: saveLinks);
  }
}

extension SrsIntervalSchemaQueryWhereSort
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QWhere> {
  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SrsIntervalSchemaQueryWhere
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QWhereClause> {
  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhereClause>
      itemIdEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'itemId',
        value: [itemId],
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterWhereClause>
      itemIdNotEqualTo(String itemId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [],
              upper: [itemId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [itemId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [itemId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'itemId',
              lower: [],
              upper: [itemId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SrsIntervalSchemaQueryFilter
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QFilterCondition> {
  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      easeFactorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      easeFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      easeFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      easeFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'easeFactor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      intervalDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      intervalDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      intervalDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      intervalDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemId',
        value: '',
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      nextReviewEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextReview',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      nextReviewGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextReview',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      nextReviewLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextReview',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      nextReviewBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextReview',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      repetitionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      repetitionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      repetitionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterFilterCondition>
      repetitionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repetitions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SrsIntervalSchemaQueryObject
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QFilterCondition> {}

extension SrsIntervalSchemaQueryLinks
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QFilterCondition> {}

extension SrsIntervalSchemaQuerySortBy
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QSortBy> {
  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByNextReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByNextReviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      sortByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }
}

extension SrsIntervalSchemaQuerySortThenBy
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QSortThenBy> {
  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByNextReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByNextReviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.desc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QAfterSortBy>
      thenByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }
}

extension SrsIntervalSchemaQueryWhereDistinct
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QDistinct> {
  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QDistinct>
      distinctByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'easeFactor');
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QDistinct>
      distinctByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalDays');
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QDistinct>
      distinctByItemId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QDistinct>
      distinctByNextReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextReview');
    });
  }

  QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QDistinct>
      distinctByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repetitions');
    });
  }
}

extension SrsIntervalSchemaQueryProperty
    on QueryBuilder<SrsIntervalSchema, SrsIntervalSchema, QQueryProperty> {
  QueryBuilder<SrsIntervalSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SrsIntervalSchema, double, QQueryOperations>
      easeFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'easeFactor');
    });
  }

  QueryBuilder<SrsIntervalSchema, int, QQueryOperations>
      intervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalDays');
    });
  }

  QueryBuilder<SrsIntervalSchema, String, QQueryOperations> itemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemId');
    });
  }

  QueryBuilder<SrsIntervalSchema, DateTime, QQueryOperations>
      nextReviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextReview');
    });
  }

  QueryBuilder<SrsIntervalSchema, int, QQueryOperations> repetitionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repetitions');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProgressSchemaCollection on Isar {
  IsarCollection<UserProgressSchema> get userProgressSchemas =>
      this.collection();
}

const UserProgressSchemaSchema = CollectionSchema(
  name: r'UserProgressSchema',
  id: -3434638153052932096,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'lessonId': PropertySchema(
      id: 1,
      name: r'lessonId',
      type: IsarType.string,
    )
  },
  estimateSize: _userProgressSchemaEstimateSize,
  serialize: _userProgressSchemaSerialize,
  deserialize: _userProgressSchemaDeserialize,
  deserializeProp: _userProgressSchemaDeserializeProp,
  idName: r'id',
  indexes: {
    r'lessonId': IndexSchema(
      id: 2130166291500416768,
      name: r'lessonId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'lessonId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userProgressSchemaGetId,
  getLinks: _userProgressSchemaGetLinks,
  attach: _userProgressSchemaAttach,
  version: '3.1.0+1',
);

int _userProgressSchemaEstimateSize(
  UserProgressSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lessonId.length * 3;
  return bytesCount;
}

void _userProgressSchemaSerialize(
  UserProgressSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeString(offsets[1], object.lessonId);
}

UserProgressSchema _userProgressSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProgressSchema();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.lessonId = reader.readString(offsets[1]);
  return object;
}

P _userProgressSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProgressSchemaGetId(UserProgressSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProgressSchemaGetLinks(
    UserProgressSchema object) {
  return [];
}

void _userProgressSchemaAttach(
    IsarCollection<dynamic> col, Id id, UserProgressSchema object) {
  object.id = id;
}

extension UserProgressSchemaByIndex on IsarCollection<UserProgressSchema> {
  Future<UserProgressSchema?> getByLessonId(String lessonId) {
    return getByIndex(r'lessonId', [lessonId]);
  }

  UserProgressSchema? getByLessonIdSync(String lessonId) {
    return getByIndexSync(r'lessonId', [lessonId]);
  }

  Future<bool> deleteByLessonId(String lessonId) {
    return deleteByIndex(r'lessonId', [lessonId]);
  }

  bool deleteByLessonIdSync(String lessonId) {
    return deleteByIndexSync(r'lessonId', [lessonId]);
  }

  Future<List<UserProgressSchema?>> getAllByLessonId(
      List<String> lessonIdValues) {
    final values = lessonIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'lessonId', values);
  }

  List<UserProgressSchema?> getAllByLessonIdSync(List<String> lessonIdValues) {
    final values = lessonIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'lessonId', values);
  }

  Future<int> deleteAllByLessonId(List<String> lessonIdValues) {
    final values = lessonIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'lessonId', values);
  }

  int deleteAllByLessonIdSync(List<String> lessonIdValues) {
    final values = lessonIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'lessonId', values);
  }

  Future<Id> putByLessonId(UserProgressSchema object) {
    return putByIndex(r'lessonId', object);
  }

  Id putByLessonIdSync(UserProgressSchema object, {bool saveLinks = true}) {
    return putByIndexSync(r'lessonId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLessonId(List<UserProgressSchema> objects) {
    return putAllByIndex(r'lessonId', objects);
  }

  List<Id> putAllByLessonIdSync(List<UserProgressSchema> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'lessonId', objects, saveLinks: saveLinks);
  }
}

extension UserProgressSchemaQueryWhereSort
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QWhere> {
  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProgressSchemaQueryWhere
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QWhereClause> {
  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhereClause>
      lessonIdEqualTo(String lessonId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lessonId',
        value: [lessonId],
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterWhereClause>
      lessonIdNotEqualTo(String lessonId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lessonId',
              lower: [],
              upper: [lessonId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lessonId',
              lower: [lessonId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lessonId',
              lower: [lessonId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lessonId',
              lower: [],
              upper: [lessonId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension UserProgressSchemaQueryFilter
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QFilterCondition> {
  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      completedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lessonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lessonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lessonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lessonId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lessonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lessonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lessonId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lessonId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lessonId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterFilterCondition>
      lessonIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lessonId',
        value: '',
      ));
    });
  }
}

extension UserProgressSchemaQueryObject
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QFilterCondition> {}

extension UserProgressSchemaQueryLinks
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QFilterCondition> {}

extension UserProgressSchemaQuerySortBy
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QSortBy> {
  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      sortByLessonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.asc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      sortByLessonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.desc);
    });
  }
}

extension UserProgressSchemaQuerySortThenBy
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QSortThenBy> {
  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      thenByLessonId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.asc);
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QAfterSortBy>
      thenByLessonIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lessonId', Sort.desc);
    });
  }
}

extension UserProgressSchemaQueryWhereDistinct
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QDistinct> {
  QueryBuilder<UserProgressSchema, UserProgressSchema, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<UserProgressSchema, UserProgressSchema, QDistinct>
      distinctByLessonId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lessonId', caseSensitive: caseSensitive);
    });
  }
}

extension UserProgressSchemaQueryProperty
    on QueryBuilder<UserProgressSchema, UserProgressSchema, QQueryProperty> {
  QueryBuilder<UserProgressSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProgressSchema, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<UserProgressSchema, String, QQueryOperations>
      lessonIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lessonId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQuizAttemptSchemaCollection on Isar {
  IsarCollection<QuizAttemptSchema> get quizAttemptSchemas => this.collection();
}

const QuizAttemptSchemaSchema = CollectionSchema(
  name: r'QuizAttemptSchema',
  id: -3257794720480054784,
  properties: {
    r'attemptedAt': PropertySchema(
      id: 0,
      name: r'attemptedAt',
      type: IsarType.dateTime,
    ),
    r'averageLatencyMs': PropertySchema(
      id: 1,
      name: r'averageLatencyMs',
      type: IsarType.long,
    ),
    r'correctCount': PropertySchema(
      id: 2,
      name: r'correctCount',
      type: IsarType.long,
    ),
    r'quizId': PropertySchema(
      id: 3,
      name: r'quizId',
      type: IsarType.string,
    ),
    r'totalQuestions': PropertySchema(
      id: 4,
      name: r'totalQuestions',
      type: IsarType.long,
    )
  },
  estimateSize: _quizAttemptSchemaEstimateSize,
  serialize: _quizAttemptSchemaSerialize,
  deserialize: _quizAttemptSchemaDeserialize,
  deserializeProp: _quizAttemptSchemaDeserializeProp,
  idName: r'id',
  indexes: {
    r'quizId': IndexSchema(
      id: -3109243004246223360,
      name: r'quizId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'quizId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _quizAttemptSchemaGetId,
  getLinks: _quizAttemptSchemaGetLinks,
  attach: _quizAttemptSchemaAttach,
  version: '3.1.0+1',
);

int _quizAttemptSchemaEstimateSize(
  QuizAttemptSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.quizId.length * 3;
  return bytesCount;
}

void _quizAttemptSchemaSerialize(
  QuizAttemptSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.attemptedAt);
  writer.writeLong(offsets[1], object.averageLatencyMs);
  writer.writeLong(offsets[2], object.correctCount);
  writer.writeString(offsets[3], object.quizId);
  writer.writeLong(offsets[4], object.totalQuestions);
}

QuizAttemptSchema _quizAttemptSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QuizAttemptSchema();
  object.attemptedAt = reader.readDateTime(offsets[0]);
  object.averageLatencyMs = reader.readLongOrNull(offsets[1]);
  object.correctCount = reader.readLong(offsets[2]);
  object.id = id;
  object.quizId = reader.readString(offsets[3]);
  object.totalQuestions = reader.readLong(offsets[4]);
  return object;
}

P _quizAttemptSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _quizAttemptSchemaGetId(QuizAttemptSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _quizAttemptSchemaGetLinks(
    QuizAttemptSchema object) {
  return [];
}

void _quizAttemptSchemaAttach(
    IsarCollection<dynamic> col, Id id, QuizAttemptSchema object) {
  object.id = id;
}

extension QuizAttemptSchemaByIndex on IsarCollection<QuizAttemptSchema> {
  Future<QuizAttemptSchema?> getByQuizId(String quizId) {
    return getByIndex(r'quizId', [quizId]);
  }

  QuizAttemptSchema? getByQuizIdSync(String quizId) {
    return getByIndexSync(r'quizId', [quizId]);
  }

  Future<bool> deleteByQuizId(String quizId) {
    return deleteByIndex(r'quizId', [quizId]);
  }

  bool deleteByQuizIdSync(String quizId) {
    return deleteByIndexSync(r'quizId', [quizId]);
  }

  Future<List<QuizAttemptSchema?>> getAllByQuizId(List<String> quizIdValues) {
    final values = quizIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'quizId', values);
  }

  List<QuizAttemptSchema?> getAllByQuizIdSync(List<String> quizIdValues) {
    final values = quizIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'quizId', values);
  }

  Future<int> deleteAllByQuizId(List<String> quizIdValues) {
    final values = quizIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'quizId', values);
  }

  int deleteAllByQuizIdSync(List<String> quizIdValues) {
    final values = quizIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'quizId', values);
  }

  Future<Id> putByQuizId(QuizAttemptSchema object) {
    return putByIndex(r'quizId', object);
  }

  Id putByQuizIdSync(QuizAttemptSchema object, {bool saveLinks = true}) {
    return putByIndexSync(r'quizId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQuizId(List<QuizAttemptSchema> objects) {
    return putAllByIndex(r'quizId', objects);
  }

  List<Id> putAllByQuizIdSync(List<QuizAttemptSchema> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'quizId', objects, saveLinks: saveLinks);
  }
}

extension QuizAttemptSchemaQueryWhereSort
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QWhere> {
  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QuizAttemptSchemaQueryWhere
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QWhereClause> {
  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhereClause>
      quizIdEqualTo(String quizId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'quizId',
        value: [quizId],
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterWhereClause>
      quizIdNotEqualTo(String quizId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quizId',
              lower: [],
              upper: [quizId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quizId',
              lower: [quizId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quizId',
              lower: [quizId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quizId',
              lower: [],
              upper: [quizId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension QuizAttemptSchemaQueryFilter
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QFilterCondition> {
  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      attemptedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attemptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      attemptedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attemptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      attemptedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attemptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      attemptedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attemptedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      averageLatencyMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'averageLatencyMs',
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      averageLatencyMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'averageLatencyMs',
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      averageLatencyMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageLatencyMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      averageLatencyMsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageLatencyMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      averageLatencyMsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageLatencyMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      averageLatencyMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageLatencyMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      correctCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctCount',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      correctCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correctCount',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      correctCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correctCount',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      correctCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correctCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quizId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quizId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quizId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quizId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quizId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quizId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quizId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quizId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quizId',
        value: '',
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      quizIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quizId',
        value: '',
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      totalQuestionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      totalQuestionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      totalQuestionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterFilterCondition>
      totalQuestionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalQuestions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension QuizAttemptSchemaQueryObject
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QFilterCondition> {}

extension QuizAttemptSchemaQueryLinks
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QFilterCondition> {}

extension QuizAttemptSchemaQuerySortBy
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QSortBy> {
  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByAttemptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByAttemptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByAverageLatencyMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageLatencyMs', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByAverageLatencyMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageLatencyMs', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByCorrectCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByQuizId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quizId', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByQuizIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quizId', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByTotalQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      sortByTotalQuestionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.desc);
    });
  }
}

extension QuizAttemptSchemaQuerySortThenBy
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QSortThenBy> {
  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByAttemptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByAttemptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByAverageLatencyMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageLatencyMs', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByAverageLatencyMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageLatencyMs', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByCorrectCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByQuizId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quizId', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByQuizIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quizId', Sort.desc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByTotalQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.asc);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QAfterSortBy>
      thenByTotalQuestionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQuestions', Sort.desc);
    });
  }
}

extension QuizAttemptSchemaQueryWhereDistinct
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QDistinct> {
  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QDistinct>
      distinctByAttemptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attemptedAt');
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QDistinct>
      distinctByAverageLatencyMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageLatencyMs');
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QDistinct>
      distinctByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctCount');
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QDistinct>
      distinctByQuizId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quizId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QDistinct>
      distinctByTotalQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalQuestions');
    });
  }
}

extension QuizAttemptSchemaQueryProperty
    on QueryBuilder<QuizAttemptSchema, QuizAttemptSchema, QQueryProperty> {
  QueryBuilder<QuizAttemptSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<QuizAttemptSchema, DateTime, QQueryOperations>
      attemptedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attemptedAt');
    });
  }

  QueryBuilder<QuizAttemptSchema, int?, QQueryOperations>
      averageLatencyMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageLatencyMs');
    });
  }

  QueryBuilder<QuizAttemptSchema, int, QQueryOperations>
      correctCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctCount');
    });
  }

  QueryBuilder<QuizAttemptSchema, String, QQueryOperations> quizIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quizId');
    });
  }

  QueryBuilder<QuizAttemptSchema, int, QQueryOperations>
      totalQuestionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalQuestions');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEngagementSchemaCollection on Isar {
  IsarCollection<EngagementSchema> get engagementSchemas => this.collection();
}

const EngagementSchemaSchema = CollectionSchema(
  name: r'EngagementSchema',
  id: -6535769019692990464,
  properties: {
    r'currentStreak': PropertySchema(
      id: 0,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'lastStudyDate': PropertySchema(
      id: 1,
      name: r'lastStudyDate',
      type: IsarType.dateTime,
    ),
    r'studyHistory': PropertySchema(
      id: 2,
      name: r'studyHistory',
      type: IsarType.objectList,
      target: r'DailyXpEntry',
    ),
    r'totalXp': PropertySchema(
      id: 3,
      name: r'totalXp',
      type: IsarType.long,
    )
  },
  estimateSize: _engagementSchemaEstimateSize,
  serialize: _engagementSchemaSerialize,
  deserialize: _engagementSchemaDeserialize,
  deserializeProp: _engagementSchemaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'DailyXpEntry': DailyXpEntrySchema},
  getId: _engagementSchemaGetId,
  getLinks: _engagementSchemaGetLinks,
  attach: _engagementSchemaAttach,
  version: '3.1.0+1',
);

int _engagementSchemaEstimateSize(
  EngagementSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.studyHistory.length * 3;
  {
    final offsets = allOffsets[DailyXpEntry]!;
    for (var i = 0; i < object.studyHistory.length; i++) {
      final value = object.studyHistory[i];
      bytesCount += DailyXpEntrySchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _engagementSchemaSerialize(
  EngagementSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentStreak);
  writer.writeDateTime(offsets[1], object.lastStudyDate);
  writer.writeObjectList<DailyXpEntry>(
    offsets[2],
    allOffsets,
    DailyXpEntrySchema.serialize,
    object.studyHistory,
  );
  writer.writeLong(offsets[3], object.totalXp);
}

EngagementSchema _engagementSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EngagementSchema();
  object.currentStreak = reader.readLong(offsets[0]);
  object.id = id;
  object.lastStudyDate = reader.readDateTimeOrNull(offsets[1]);
  object.studyHistory = reader.readObjectList<DailyXpEntry>(
        offsets[2],
        DailyXpEntrySchema.deserialize,
        allOffsets,
        DailyXpEntry(),
      ) ??
      [];
  object.totalXp = reader.readLong(offsets[3]);
  return object;
}

P _engagementSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readObjectList<DailyXpEntry>(
            offset,
            DailyXpEntrySchema.deserialize,
            allOffsets,
            DailyXpEntry(),
          ) ??
          []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _engagementSchemaGetId(EngagementSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _engagementSchemaGetLinks(EngagementSchema object) {
  return [];
}

void _engagementSchemaAttach(
    IsarCollection<dynamic> col, Id id, EngagementSchema object) {
  object.id = id;
}

extension EngagementSchemaQueryWhereSort
    on QueryBuilder<EngagementSchema, EngagementSchema, QWhere> {
  QueryBuilder<EngagementSchema, EngagementSchema, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EngagementSchemaQueryWhere
    on QueryBuilder<EngagementSchema, EngagementSchema, QWhereClause> {
  QueryBuilder<EngagementSchema, EngagementSchema, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EngagementSchemaQueryFilter
    on QueryBuilder<EngagementSchema, EngagementSchema, QFilterCondition> {
  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      lastStudyDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastStudyDate',
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      lastStudyDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastStudyDate',
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      lastStudyDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastStudyDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      lastStudyDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastStudyDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      lastStudyDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastStudyDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      lastStudyDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastStudyDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      studyHistoryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'studyHistory',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      studyHistoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'studyHistory',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      studyHistoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'studyHistory',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      studyHistoryLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'studyHistory',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      studyHistoryLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'studyHistory',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      studyHistoryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'studyHistory',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      totalXpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalXp',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      totalXpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalXp',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      totalXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalXp',
        value: value,
      ));
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      totalXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalXp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EngagementSchemaQueryObject
    on QueryBuilder<EngagementSchema, EngagementSchema, QFilterCondition> {
  QueryBuilder<EngagementSchema, EngagementSchema, QAfterFilterCondition>
      studyHistoryElement(FilterQuery<DailyXpEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'studyHistory');
    });
  }
}

extension EngagementSchemaQueryLinks
    on QueryBuilder<EngagementSchema, EngagementSchema, QFilterCondition> {}

extension EngagementSchemaQuerySortBy
    on QueryBuilder<EngagementSchema, EngagementSchema, QSortBy> {
  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      sortByLastStudyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStudyDate', Sort.asc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      sortByLastStudyDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStudyDate', Sort.desc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      sortByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.asc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      sortByTotalXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.desc);
    });
  }
}

extension EngagementSchemaQuerySortThenBy
    on QueryBuilder<EngagementSchema, EngagementSchema, QSortThenBy> {
  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      thenByLastStudyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStudyDate', Sort.asc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      thenByLastStudyDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastStudyDate', Sort.desc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      thenByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.asc);
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QAfterSortBy>
      thenByTotalXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.desc);
    });
  }
}

extension EngagementSchemaQueryWhereDistinct
    on QueryBuilder<EngagementSchema, EngagementSchema, QDistinct> {
  QueryBuilder<EngagementSchema, EngagementSchema, QDistinct>
      distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QDistinct>
      distinctByLastStudyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastStudyDate');
    });
  }

  QueryBuilder<EngagementSchema, EngagementSchema, QDistinct>
      distinctByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalXp');
    });
  }
}

extension EngagementSchemaQueryProperty
    on QueryBuilder<EngagementSchema, EngagementSchema, QQueryProperty> {
  QueryBuilder<EngagementSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EngagementSchema, int, QQueryOperations>
      currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<EngagementSchema, DateTime?, QQueryOperations>
      lastStudyDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastStudyDate');
    });
  }

  QueryBuilder<EngagementSchema, List<DailyXpEntry>, QQueryOperations>
      studyHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'studyHistory');
    });
  }

  QueryBuilder<EngagementSchema, int, QQueryOperations> totalXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalXp');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsSchemaCollection on Isar {
  IsarCollection<AppSettingsSchema> get appSettingsSchemas => this.collection();
}

const AppSettingsSchemaSchema = CollectionSchema(
  name: r'AppSettingsSchema',
  id: 8456715016247925760,
  properties: {
    r'monthsToGoal': PropertySchema(
      id: 0,
      name: r'monthsToGoal',
      type: IsarType.long,
    ),
    r'reminderHour': PropertySchema(
      id: 1,
      name: r'reminderHour',
      type: IsarType.long,
    ),
    r'reminderMinute': PropertySchema(
      id: 2,
      name: r'reminderMinute',
      type: IsarType.long,
    ),
    r'remindersEnabled': PropertySchema(
      id: 3,
      name: r'remindersEnabled',
      type: IsarType.bool,
    )
  },
  estimateSize: _appSettingsSchemaEstimateSize,
  serialize: _appSettingsSchemaSerialize,
  deserialize: _appSettingsSchemaDeserialize,
  deserializeProp: _appSettingsSchemaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsSchemaGetId,
  getLinks: _appSettingsSchemaGetLinks,
  attach: _appSettingsSchemaAttach,
  version: '3.1.0+1',
);

int _appSettingsSchemaEstimateSize(
  AppSettingsSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _appSettingsSchemaSerialize(
  AppSettingsSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.monthsToGoal);
  writer.writeLong(offsets[1], object.reminderHour);
  writer.writeLong(offsets[2], object.reminderMinute);
  writer.writeBool(offsets[3], object.remindersEnabled);
}

AppSettingsSchema _appSettingsSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingsSchema();
  object.id = id;
  object.monthsToGoal = reader.readLong(offsets[0]);
  object.reminderHour = reader.readLong(offsets[1]);
  object.reminderMinute = reader.readLong(offsets[2]);
  object.remindersEnabled = reader.readBool(offsets[3]);
  return object;
}

P _appSettingsSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsSchemaGetId(AppSettingsSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsSchemaGetLinks(
    AppSettingsSchema object) {
  return [];
}

void _appSettingsSchemaAttach(
    IsarCollection<dynamic> col, Id id, AppSettingsSchema object) {
  object.id = id;
}

extension AppSettingsSchemaQueryWhereSort
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QWhere> {
  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsSchemaQueryWhere
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QWhereClause> {
  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppSettingsSchemaQueryFilter
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QFilterCondition> {
  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      monthsToGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthsToGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      monthsToGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthsToGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      monthsToGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthsToGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      monthsToGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthsToGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderHour',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderHour',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderHour',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      reminderMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterFilterCondition>
      remindersEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remindersEnabled',
        value: value,
      ));
    });
  }
}

extension AppSettingsSchemaQueryObject
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QFilterCondition> {}

extension AppSettingsSchemaQueryLinks
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QFilterCondition> {}

extension AppSettingsSchemaQuerySortBy
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QSortBy> {
  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByMonthsToGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthsToGoal', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByMonthsToGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthsToGoal', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderHour', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByReminderHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderHour', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMinute', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByReminderMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMinute', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByRemindersEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      sortByRemindersEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.desc);
    });
  }
}

extension AppSettingsSchemaQuerySortThenBy
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QSortThenBy> {
  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByMonthsToGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthsToGoal', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByMonthsToGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthsToGoal', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderHour', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByReminderHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderHour', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMinute', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByReminderMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderMinute', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByRemindersEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QAfterSortBy>
      thenByRemindersEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.desc);
    });
  }
}

extension AppSettingsSchemaQueryWhereDistinct
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QDistinct> {
  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QDistinct>
      distinctByMonthsToGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthsToGoal');
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QDistinct>
      distinctByReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderHour');
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QDistinct>
      distinctByReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderMinute');
    });
  }

  QueryBuilder<AppSettingsSchema, AppSettingsSchema, QDistinct>
      distinctByRemindersEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remindersEnabled');
    });
  }
}

extension AppSettingsSchemaQueryProperty
    on QueryBuilder<AppSettingsSchema, AppSettingsSchema, QQueryProperty> {
  QueryBuilder<AppSettingsSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingsSchema, int, QQueryOperations>
      monthsToGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthsToGoal');
    });
  }

  QueryBuilder<AppSettingsSchema, int, QQueryOperations>
      reminderHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderHour');
    });
  }

  QueryBuilder<AppSettingsSchema, int, QQueryOperations>
      reminderMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderMinute');
    });
  }

  QueryBuilder<AppSettingsSchema, bool, QQueryOperations>
      remindersEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remindersEnabled');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPurchasedSubjectSchemaCollection on Isar {
  IsarCollection<PurchasedSubjectSchema> get purchasedSubjectSchemas =>
      this.collection();
}

const PurchasedSubjectSchemaSchema = CollectionSchema(
  name: r'PurchasedSubjectSchema',
  id: -6948633597884204032,
  properties: {
    r'purchasedAt': PropertySchema(
      id: 0,
      name: r'purchasedAt',
      type: IsarType.dateTime,
    ),
    r'subjectId': PropertySchema(
      id: 1,
      name: r'subjectId',
      type: IsarType.string,
    )
  },
  estimateSize: _purchasedSubjectSchemaEstimateSize,
  serialize: _purchasedSubjectSchemaSerialize,
  deserialize: _purchasedSubjectSchemaDeserialize,
  deserializeProp: _purchasedSubjectSchemaDeserializeProp,
  idName: r'id',
  indexes: {
    r'subjectId': IndexSchema(
      id: 440306668014800000,
      name: r'subjectId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'subjectId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _purchasedSubjectSchemaGetId,
  getLinks: _purchasedSubjectSchemaGetLinks,
  attach: _purchasedSubjectSchemaAttach,
  version: '3.1.0+1',
);

int _purchasedSubjectSchemaEstimateSize(
  PurchasedSubjectSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.subjectId.length * 3;
  return bytesCount;
}

void _purchasedSubjectSchemaSerialize(
  PurchasedSubjectSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.purchasedAt);
  writer.writeString(offsets[1], object.subjectId);
}

PurchasedSubjectSchema _purchasedSubjectSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PurchasedSubjectSchema();
  object.id = id;
  object.purchasedAt = reader.readDateTime(offsets[0]);
  object.subjectId = reader.readString(offsets[1]);
  return object;
}

P _purchasedSubjectSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _purchasedSubjectSchemaGetId(PurchasedSubjectSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _purchasedSubjectSchemaGetLinks(
    PurchasedSubjectSchema object) {
  return [];
}

void _purchasedSubjectSchemaAttach(
    IsarCollection<dynamic> col, Id id, PurchasedSubjectSchema object) {
  object.id = id;
}

extension PurchasedSubjectSchemaByIndex
    on IsarCollection<PurchasedSubjectSchema> {
  Future<PurchasedSubjectSchema?> getBySubjectId(String subjectId) {
    return getByIndex(r'subjectId', [subjectId]);
  }

  PurchasedSubjectSchema? getBySubjectIdSync(String subjectId) {
    return getByIndexSync(r'subjectId', [subjectId]);
  }

  Future<bool> deleteBySubjectId(String subjectId) {
    return deleteByIndex(r'subjectId', [subjectId]);
  }

  bool deleteBySubjectIdSync(String subjectId) {
    return deleteByIndexSync(r'subjectId', [subjectId]);
  }

  Future<List<PurchasedSubjectSchema?>> getAllBySubjectId(
      List<String> subjectIdValues) {
    final values = subjectIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'subjectId', values);
  }

  List<PurchasedSubjectSchema?> getAllBySubjectIdSync(
      List<String> subjectIdValues) {
    final values = subjectIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'subjectId', values);
  }

  Future<int> deleteAllBySubjectId(List<String> subjectIdValues) {
    final values = subjectIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'subjectId', values);
  }

  int deleteAllBySubjectIdSync(List<String> subjectIdValues) {
    final values = subjectIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'subjectId', values);
  }

  Future<Id> putBySubjectId(PurchasedSubjectSchema object) {
    return putByIndex(r'subjectId', object);
  }

  Id putBySubjectIdSync(PurchasedSubjectSchema object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'subjectId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySubjectId(List<PurchasedSubjectSchema> objects) {
    return putAllByIndex(r'subjectId', objects);
  }

  List<Id> putAllBySubjectIdSync(List<PurchasedSubjectSchema> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'subjectId', objects, saveLinks: saveLinks);
  }
}

extension PurchasedSubjectSchemaQueryWhereSort
    on QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QWhere> {
  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PurchasedSubjectSchemaQueryWhere on QueryBuilder<
    PurchasedSubjectSchema, PurchasedSubjectSchema, QWhereClause> {
  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterWhereClause> subjectIdEqualTo(String subjectId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'subjectId',
        value: [subjectId],
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterWhereClause> subjectIdNotEqualTo(String subjectId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subjectId',
              lower: [],
              upper: [subjectId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subjectId',
              lower: [subjectId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subjectId',
              lower: [subjectId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'subjectId',
              lower: [],
              upper: [subjectId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PurchasedSubjectSchemaQueryFilter on QueryBuilder<
    PurchasedSubjectSchema, PurchasedSubjectSchema, QFilterCondition> {
  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> purchasedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchasedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> purchasedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchasedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> purchasedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchasedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> purchasedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchasedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subjectId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
          QAfterFilterCondition>
      subjectIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
          QAfterFilterCondition>
      subjectIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subjectId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectId',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema,
      QAfterFilterCondition> subjectIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subjectId',
        value: '',
      ));
    });
  }
}

extension PurchasedSubjectSchemaQueryObject on QueryBuilder<
    PurchasedSubjectSchema, PurchasedSubjectSchema, QFilterCondition> {}

extension PurchasedSubjectSchemaQueryLinks on QueryBuilder<
    PurchasedSubjectSchema, PurchasedSubjectSchema, QFilterCondition> {}

extension PurchasedSubjectSchemaQuerySortBy
    on QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QSortBy> {
  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      sortByPurchasedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasedAt', Sort.asc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      sortByPurchasedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasedAt', Sort.desc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      sortBySubjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectId', Sort.asc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      sortBySubjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectId', Sort.desc);
    });
  }
}

extension PurchasedSubjectSchemaQuerySortThenBy on QueryBuilder<
    PurchasedSubjectSchema, PurchasedSubjectSchema, QSortThenBy> {
  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      thenByPurchasedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasedAt', Sort.asc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      thenByPurchasedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchasedAt', Sort.desc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      thenBySubjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectId', Sort.asc);
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QAfterSortBy>
      thenBySubjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subjectId', Sort.desc);
    });
  }
}

extension PurchasedSubjectSchemaQueryWhereDistinct
    on QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QDistinct> {
  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QDistinct>
      distinctByPurchasedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchasedAt');
    });
  }

  QueryBuilder<PurchasedSubjectSchema, PurchasedSubjectSchema, QDistinct>
      distinctBySubjectId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subjectId', caseSensitive: caseSensitive);
    });
  }
}

extension PurchasedSubjectSchemaQueryProperty on QueryBuilder<
    PurchasedSubjectSchema, PurchasedSubjectSchema, QQueryProperty> {
  QueryBuilder<PurchasedSubjectSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PurchasedSubjectSchema, DateTime, QQueryOperations>
      purchasedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchasedAt');
    });
  }

  QueryBuilder<PurchasedSubjectSchema, String, QQueryOperations>
      subjectIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subjectId');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DailyXpEntrySchema = Schema(
  name: r'DailyXpEntry',
  id: -15949938519644508,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'xp': PropertySchema(
      id: 1,
      name: r'xp',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyXpEntryEstimateSize,
  serialize: _dailyXpEntrySerialize,
  deserialize: _dailyXpEntryDeserialize,
  deserializeProp: _dailyXpEntryDeserializeProp,
);

int _dailyXpEntryEstimateSize(
  DailyXpEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  return bytesCount;
}

void _dailyXpEntrySerialize(
  DailyXpEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeLong(offsets[1], object.xp);
}

DailyXpEntry _dailyXpEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyXpEntry();
  object.date = reader.readString(offsets[0]);
  object.xp = reader.readLong(offsets[1]);
  return object;
}

P _dailyXpEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DailyXpEntryQueryFilter
    on QueryBuilder<DailyXpEntry, DailyXpEntry, QFilterCondition> {
  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition>
      dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> dateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> dateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> xpEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xp',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> xpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xp',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> xpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xp',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyXpEntry, DailyXpEntry, QAfterFilterCondition> xpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyXpEntryQueryObject
    on QueryBuilder<DailyXpEntry, DailyXpEntry, QFilterCondition> {}
