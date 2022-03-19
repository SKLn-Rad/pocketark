///
//  Generated code. Do not modify.
//  source: proto/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class LostArkEvent_LostArkEventSchedule extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LostArkEvent.LostArkEventSchedule', createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeStart')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeEnd')
    ..hasRequiredFields = false
  ;

  LostArkEvent_LostArkEventSchedule._() : super();
  factory LostArkEvent_LostArkEventSchedule({
    $fixnum.Int64? timeStart,
    $fixnum.Int64? timeEnd,
  }) {
    final _result = create();
    if (timeStart != null) {
      _result.timeStart = timeStart;
    }
    if (timeEnd != null) {
      _result.timeEnd = timeEnd;
    }
    return _result;
  }
  factory LostArkEvent_LostArkEventSchedule.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LostArkEvent_LostArkEventSchedule.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LostArkEvent_LostArkEventSchedule clone() => LostArkEvent_LostArkEventSchedule()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LostArkEvent_LostArkEventSchedule copyWith(void Function(LostArkEvent_LostArkEventSchedule) updates) => super.copyWith((message) => updates(message as LostArkEvent_LostArkEventSchedule)) as LostArkEvent_LostArkEventSchedule; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LostArkEvent_LostArkEventSchedule create() => LostArkEvent_LostArkEventSchedule._();
  LostArkEvent_LostArkEventSchedule createEmptyInstance() => create();
  static $pb.PbList<LostArkEvent_LostArkEventSchedule> createRepeated() => $pb.PbList<LostArkEvent_LostArkEventSchedule>();
  @$core.pragma('dart2js:noInline')
  static LostArkEvent_LostArkEventSchedule getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LostArkEvent_LostArkEventSchedule>(create);
  static LostArkEvent_LostArkEventSchedule? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timeStart => $_getI64(0);
  @$pb.TagNumber(1)
  set timeStart($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimeStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeStart() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timeEnd => $_getI64(1);
  @$pb.TagNumber(2)
  set timeEnd($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimeEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeEnd() => clearField(2);
}

class LostArkEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LostArkEvent', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recItemLevel', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iconPath')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fallbackName')
    ..pc<LostArkEvent_LostArkEventSchedule>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'schedule', $pb.PbFieldType.PM, subBuilder: LostArkEvent_LostArkEventSchedule.create)
    ..hasRequiredFields = false
  ;

  LostArkEvent._() : super();
  factory LostArkEvent({
    $core.int? id,
    $core.int? type,
    $core.int? recItemLevel,
    $core.String? iconPath,
    $core.String? fallbackName,
    $core.Iterable<LostArkEvent_LostArkEventSchedule>? schedule,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (type != null) {
      _result.type = type;
    }
    if (recItemLevel != null) {
      _result.recItemLevel = recItemLevel;
    }
    if (iconPath != null) {
      _result.iconPath = iconPath;
    }
    if (fallbackName != null) {
      _result.fallbackName = fallbackName;
    }
    if (schedule != null) {
      _result.schedule.addAll(schedule);
    }
    return _result;
  }
  factory LostArkEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LostArkEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LostArkEvent clone() => LostArkEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LostArkEvent copyWith(void Function(LostArkEvent) updates) => super.copyWith((message) => updates(message as LostArkEvent)) as LostArkEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LostArkEvent create() => LostArkEvent._();
  LostArkEvent createEmptyInstance() => create();
  static $pb.PbList<LostArkEvent> createRepeated() => $pb.PbList<LostArkEvent>();
  @$core.pragma('dart2js:noInline')
  static LostArkEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LostArkEvent>(create);
  static LostArkEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get type => $_getIZ(1);
  @$pb.TagNumber(2)
  set type($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get recItemLevel => $_getIZ(2);
  @$pb.TagNumber(3)
  set recItemLevel($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecItemLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecItemLevel() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get iconPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set iconPath($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIconPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconPath() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get fallbackName => $_getSZ(4);
  @$pb.TagNumber(5)
  set fallbackName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFallbackName() => $_has(4);
  @$pb.TagNumber(5)
  void clearFallbackName() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<LostArkEvent_LostArkEventSchedule> get schedule => $_getList(5);
}

