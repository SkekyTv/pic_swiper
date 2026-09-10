// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swipe_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SwipePageState {

 List<AssetEntity> get photos; int get currentIndex; Set<String> get pendingDeletionIds;
/// Create a copy of SwipePageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwipePageStateCopyWith<SwipePageState> get copyWith => _$SwipePageStateCopyWithImpl<SwipePageState>(this as SwipePageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwipePageState&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.pendingDeletionIds, pendingDeletionIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(photos),currentIndex,const DeepCollectionEquality().hash(pendingDeletionIds));

@override
String toString() {
  return 'SwipePageState(photos: $photos, currentIndex: $currentIndex, pendingDeletionIds: $pendingDeletionIds)';
}


}

/// @nodoc
abstract mixin class $SwipePageStateCopyWith<$Res>  {
  factory $SwipePageStateCopyWith(SwipePageState value, $Res Function(SwipePageState) _then) = _$SwipePageStateCopyWithImpl;
@useResult
$Res call({
 List<AssetEntity> photos, int currentIndex, Set<String> pendingDeletionIds
});




}
/// @nodoc
class _$SwipePageStateCopyWithImpl<$Res>
    implements $SwipePageStateCopyWith<$Res> {
  _$SwipePageStateCopyWithImpl(this._self, this._then);

  final SwipePageState _self;
  final $Res Function(SwipePageState) _then;

/// Create a copy of SwipePageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photos = null,Object? currentIndex = null,Object? pendingDeletionIds = null,}) {
  return _then(SwipePageState(
photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<AssetEntity>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,pendingDeletionIds: null == pendingDeletionIds ? _self.pendingDeletionIds : pendingDeletionIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SwipePageState].
extension SwipePageStatePatterns on SwipePageState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwipePageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwipePageState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwipePageState value)  $default,){
final _that = this;
switch (_that) {
case _SwipePageState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwipePageState value)?  $default,){
final _that = this;
switch (_that) {
case _SwipePageState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AssetEntity> photos,  int currentIndex,  Set<String> pendingDeletionIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwipePageState() when $default != null:
return $default(_that.photos,_that.currentIndex,_that.pendingDeletionIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AssetEntity> photos,  int currentIndex,  Set<String> pendingDeletionIds)  $default,) {final _that = this;
switch (_that) {
case _SwipePageState():
return $default(_that.photos,_that.currentIndex,_that.pendingDeletionIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AssetEntity> photos,  int currentIndex,  Set<String> pendingDeletionIds)?  $default,) {final _that = this;
switch (_that) {
case _SwipePageState() when $default != null:
return $default(_that.photos,_that.currentIndex,_that.pendingDeletionIds);case _:
  return null;

}
}

}

/// @nodoc


class _SwipePageState extends SwipePageState {
  const _SwipePageState({required  List<AssetEntity> photos, required this.currentIndex,  Set<String> pendingDeletionIds = const <String>{}}): _photos = photos,_pendingDeletionIds = pendingDeletionIds,super._();
  

 final  List<AssetEntity> _photos;
@override List<AssetEntity> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  int currentIndex;
 final  Set<String> _pendingDeletionIds;
@override@JsonKey() Set<String> get pendingDeletionIds {
  if (_pendingDeletionIds is EqualUnmodifiableSetView) return _pendingDeletionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDeletionIds);
}


/// Create a copy of SwipePageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwipePageStateCopyWith<_SwipePageState> get copyWith => __$SwipePageStateCopyWithImpl<_SwipePageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwipePageState&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other._pendingDeletionIds, _pendingDeletionIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_photos),currentIndex,const DeepCollectionEquality().hash(_pendingDeletionIds));

@override
String toString() {
  return 'SwipePageState(photos: $photos, currentIndex: $currentIndex, pendingDeletionIds: $pendingDeletionIds)';
}


}

/// @nodoc
abstract mixin class _$SwipePageStateCopyWith<$Res> implements $SwipePageStateCopyWith<$Res> {
  factory _$SwipePageStateCopyWith(_SwipePageState value, $Res Function(_SwipePageState) _then) = __$SwipePageStateCopyWithImpl;
@override @useResult
$Res call({
 List<AssetEntity> photos, int currentIndex, Set<String> pendingDeletionIds
});




}
/// @nodoc
class __$SwipePageStateCopyWithImpl<$Res>
    implements _$SwipePageStateCopyWith<$Res> {
  __$SwipePageStateCopyWithImpl(this._self, this._then);

  final _SwipePageState _self;
  final $Res Function(_SwipePageState) _then;

/// Create a copy of SwipePageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photos = null,Object? currentIndex = null,Object? pendingDeletionIds = null,}) {
  return _then(_SwipePageState(
photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<AssetEntity>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,pendingDeletionIds: null == pendingDeletionIds ? _self._pendingDeletionIds : pendingDeletionIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
