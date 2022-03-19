///
//  Generated code. Do not modify.
//  source: proto/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use lostArkEventDescriptor instead')
const LostArkEvent$json = const {
  '1': 'LostArkEvent',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'type', '3': 2, '4': 1, '5': 5, '10': 'type'},
    const {'1': 'rec_item_level', '3': 3, '4': 1, '5': 5, '10': 'recItemLevel'},
    const {'1': 'icon_path', '3': 4, '4': 1, '5': 9, '10': 'iconPath'},
    const {'1': 'fallback_name', '3': 5, '4': 1, '5': 9, '10': 'fallbackName'},
    const {'1': 'schedule', '3': 6, '4': 3, '5': 11, '6': '.LostArkEvent.LostArkEventSchedule', '10': 'schedule'},
  ],
  '3': const [LostArkEvent_LostArkEventSchedule$json],
};

@$core.Deprecated('Use lostArkEventDescriptor instead')
const LostArkEvent_LostArkEventSchedule$json = const {
  '1': 'LostArkEventSchedule',
  '2': const [
    const {'1': 'time_start', '3': 1, '4': 1, '5': 3, '10': 'timeStart'},
    const {'1': 'time_end', '3': 2, '4': 1, '5': 3, '10': 'timeEnd'},
  ],
};

/// Descriptor for `LostArkEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lostArkEventDescriptor = $convert.base64Decode('CgxMb3N0QXJrRXZlbnQSDgoCaWQYASABKAVSAmlkEhIKBHR5cGUYAiABKAVSBHR5cGUSJAoOcmVjX2l0ZW1fbGV2ZWwYAyABKAVSDHJlY0l0ZW1MZXZlbBIbCglpY29uX3BhdGgYBCABKAlSCGljb25QYXRoEiMKDWZhbGxiYWNrX25hbWUYBSABKAlSDGZhbGxiYWNrTmFtZRI+CghzY2hlZHVsZRgGIAMoCzIiLkxvc3RBcmtFdmVudC5Mb3N0QXJrRXZlbnRTY2hlZHVsZVIIc2NoZWR1bGUaUAoUTG9zdEFya0V2ZW50U2NoZWR1bGUSHQoKdGltZV9zdGFydBgBIAEoA1IJdGltZVN0YXJ0EhkKCHRpbWVfZW5kGAIgASgDUgd0aW1lRW5k');
