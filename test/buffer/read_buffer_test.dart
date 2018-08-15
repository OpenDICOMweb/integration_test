// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'test_utilities.dart';

const String magicAsString = 'DICOM-MD';
final Uint8List magic = magicAsString.codeUnits;

void main() {
  Server.initialize(name: 'read_buffer_test.dart', level: Level.info0);

  test('Read MetadataFile Magic value', () {
    const s = 'DICOM-MD';
    //List<int> cu = s.codeUnits;
    //log.debug('code units = $cu');
    final list = toUtf8(s);
    log..debug('utf8= $list')..debug('list= $list');
    final reader = ReadBuffer.fromList(list);
    log.debug('reader= $reader');
    final name = reader.readString(8);
    log.debug('name= "$name:"');
    expect(name, equals('DICOM-MD'));
  });

  test('Read String', () {
    final list = ['foo', 'bar', 'baz'];
    final strings = list.join('\\');
    final bytes = Bytes.fromAscii(strings);
    final reader = ReadBuffer(bytes);
    final s = reader.readString(bytes.length);
    expect(s, equals(strings));
  });

  test('Read String List', () {
    final list = ['foo', 'bar', 'baz'];
    final strings = list.join('\\');
    final bytes = Bytes.fromAscii(strings);
    final reader = ReadBuffer(bytes);
    final l1 = reader.readStringList(strings.length);
    expect(l1, equals(list));
  });

  test('Read Uint8 Values', () {
    final uints = [0, 1, 2, 3, 4];
    final bytes = Bytes.fromList(uints);
    final reader = ReadBuffer(bytes);
    var n = reader.readUint8();
    log.debug('Uint8 = $n');
    expect(n, equals(uints[0]));
    n = reader.readUint8();
    log.debug('Uint8 = $n');
    expect(n, equals(uints[1]));
    n = reader.readUint8();
    log.debug('Uint8 = $n');
    expect(n, equals(uints[2]));
    n = reader.readUint8();
    log.debug('Uint8 = $n');
    expect(n, equals(uints[3]));
  });

  test('Read Uint8List Values', () {
    final uints = [0, 1, 2, 3, 4];
    final bytes = Bytes.fromList(uints);
    final reader = ReadBuffer(bytes);

    final list = reader.readUint8List(bytes.length);
    log.debug('Uint8List = $list');
    expect(list, equals(uints));
  });

  test('Read Int8 Values', () {
    final ints = [0, -1, 2, -3, 4];
    final bytes = Bytes.fromList(ints);
    final reader = ReadBuffer(bytes);

    var n = reader.readInt8();
    log.debug('Int8 = $n');
    expect(n, equals(ints[0]));
    n = reader.readInt8();
    log.debug('Int8 = $n');
    expect(n, equals(ints[1]));
    n = reader.readInt8();
    log.debug('Int8 = $n');
    expect(n, equals(ints[2]));
    n = reader.readInt8();
    log.debug('Int8 = $n');
    expect(n, equals(ints[3]));
  });

  test('Read Int8List Values', () {
    final ints = [0, -1, 2, -3, 4];
    final bytes = Bytes.fromList(ints);
    final buf = ReadBuffer(bytes);

    final list = buf.readInt8List(bytes.length);
    log.debug('Int8List = $list');
    expect(list, equals(ints));
  });

  test('Read Uint16 Values', () {
    final uint16s = [257, 3401, 2000, 3000, 4000];
    final uint16List = Uint16List.fromList(uint16s);
    final bytes = Bytes.typedDataView(uint16List);
    log
      ..debug('Uint16s: $uint16s')
      ..debug('Uint16list: $uint16List')
      ..debug('bytes: $bytes');
    final reader = ReadBuffer(bytes);

    var n = reader.readUint16();
    log.debug('Uint16 = $n');
    expect(n, equals(uint16s[0]));

    n = reader.readUint16();
    log.debug('Uint16 = $n');
    expect(n, equals(uint16s[1]));

    n = reader.readUint16();
    log.debug('Uint16 = $n');
    expect(n, equals(uint16s[2]));

    n = reader.readUint16();
    log.debug('Uint16 = $n');
    expect(n, equals(uint16s[3]));
  });

  test('Read Uint16List Values', () {
    log.debug('*** Read Uint16List Values');
    final uint16s = [257, 3401, 2000, 3000, 4000];
    final uint16List = Uint16List.fromList(uint16s);
    final bytes = Bytes.typedDataView(uint16List);
    log
      ..debug('uint16s: $uint16s')
      ..debug('uint16list: $uint16List')
      ..debug('bytes: $bytes');
    final reader = ReadBuffer(bytes);

    log.debug('Uint16List.lengthInBytes= ${uint16List.length}');
    final list = reader.readUint16List(uint16List.length);
    log.debug('readList = $list');
    expect(list, equals(uint16s));
  });

  test('Read Int16 Values', () {
    final int16s = [-257, 3401, -2000, 3000, -4000];
    final int16List = Int16List.fromList(int16s);
    final bytes = Bytes.typedDataView(int16List);
    log
      ..debug('int16s: $int16s')
      ..debug('int16list: $int16List')
      ..debug('bytes: $bytes');
    final reader = ReadBuffer(bytes);

    var n = reader.readInt16();
    log.debug('Int16 = $n');
    expect(n, equals(int16s[0]));

    n = reader.readInt16();
    log.debug('Int16 = $n');
    expect(n, equals(int16s[1]));

    n = reader.readInt16();
    log.debug('Int16 = $n');
    expect(n, equals(int16s[2]));

    n = reader.readInt16();
    log.debug('Int16 = $n');
    expect(n, equals(int16s[3]));
  });

  test('Read Int16List Values', () {
    log.debug('*** Read Int16List Values');
    final int16s = [-257, 3401, -2000, 3000, -4000];
    final int16List = Int16List.fromList(int16s);
    final bytes = Bytes.typedDataView(int16List);
    log
      ..debug('int16s: $int16s')
      ..debug('int16list: $int16List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    log.debug('int16List.lengthInBytes= ${int16List.length}');
    final list = buf.readInt16List(int16List.length);
    log.debug('Int16List = $list');
    expect(list, equals(int16s));
  });

  test('Read Uint32 Values', () {
    final uint32s = [2570000, 34010000, 20000000, 30000000, 400000000];
    final uint32List = Uint32List.fromList(uint32s);
    final bytes = Bytes.typedDataView(uint32List);
    log
      ..debug('Uint32s: $uint32s')
      ..debug('Uint32list: $uint32List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    var n = buf.readUint32();
    log.debug('Uint32 = $n');
    expect(n, equals(uint32s[0]));

    n = buf.readUint32();
    log.debug('Uint32 = $n');
    expect(n, equals(uint32s[1]));

    n = buf.readUint32();
    log.debug('Uint32 = $n');
    expect(n, equals(uint32s[2]));

    n = buf.readUint32();
    log.debug('Uint32 = $n');
    expect(n, equals(uint32s[3]));
  });

  test('Read Uint32List Values', () {
    log.debug('*** Read Uint32List Values');
    final uint32s = [2570000, 34010000, 20000000, 30000000, 40000000];
    final uint32List = Uint32List.fromList(uint32s);
    final bytes = Bytes.typedDataView(uint32List);
    log
      ..debug('int32s: $uint32s')
      ..debug('int32list: $uint32List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    log.debug('int32List.lengthInBytes= ${uint32List.length}');
    final list = buf.readUint32List(uint32List.length);
    log.debug('Uint32List = $list');
    expect(list, equals(uint32s));
  });

  test('Read Int32 Values', () {
    final int32s = [-257000, 3401000, -2000000, 3000000, -4000000];
    final int32List = Int32List.fromList(int32s);
    final bytes = Bytes.typedDataView(int32List);
    log
      ..debug('int32s: $int32s')
      ..debug('int32list: $int32List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    var n = buf.readInt32();
    log.debug('Int32 = $n');
    expect(n, equals(int32s[0]));

    n = buf.readInt32();
    log.debug('Int32 = $n');
    expect(n, equals(int32s[1]));

    n = buf.readInt32();
    log.debug('Int32 = $n');
    expect(n, equals(int32s[2]));

    n = buf.readInt32();
    log.debug('Int32 = $n');
    expect(n, equals(int32s[3]));
  });

  test('Read Int32List Values', () {
    log.debug('*** Read Int32List Values');
    final int32s = [-257000, 3401000, -2000000, 3000000, -4000000];
    final int32List = Int32List.fromList(int32s);
    final bytes = Bytes.typedDataView(int32List);
    log
      ..debug('int32s: $int32s')
      ..debug('int32list: $int32List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    log.debug('int32List.lengthInBytes= ${int32List.lengthInBytes}');
    final list = buf.readInt32List(int32List.length);
    log.debug('int32List = $list');
    expect(list, equals(int32s));
  });

  test('Read Uint64 Values', () {
    final uint64s = [
      25700000000,
      34010000000,
      200000000000,
      300000000000,
      4000000000000
    ];
    final uint64list = Uint64List.fromList(uint64s);
    final bytes = Bytes.typedDataView(uint64list);
    log
      ..debug('Uint64s: $uint64s')
      ..debug('Uint64list: $uint64list')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    var n = buf.readUint64();
    log.debug('Uint64 = $n');
    expect(n, equals(uint64s[0]));

    n = buf.readUint64();
    log.debug('Uint64 = $n');
    expect(n, equals(uint64s[1]));

    n = buf.readUint64();
    log.debug('Uint64 = $n');
    expect(n, equals(uint64s[2]));

    n = buf.readUint64();
    log.debug('Uint64 = $n');
    expect(n, equals(uint64s[3]));
  });

  test('Read Uint64List Values', () {
    log.debug('*** Read Int64List Values');
    final uint64s = [
      25700000000,
      34010000000,
      200000000000,
      300000000000,
      4000000000000
    ];
    final uint64List = Uint64List.fromList(uint64s);
    final bytes = Bytes.typedDataView(uint64List);
    log
      ..debug('int64s: $uint64s')
      ..debug('int64list: $uint64List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    log.debug('int64List.lengthInBytes= ${uint64List.lengthInBytes}');
    final list = buf.readUint64List(uint64List.length);
    log.debug('UInt64List = $list');
    expect(list, equals(uint64s));
  });

  test('Read Int64 Values', () {
    final int64s = [
      -25700000000,
      34010000000,
      -200000000000,
      300000000000,
      -4000000000000
    ];
    final int64List = Int64List.fromList(int64s);
    final bytes = Bytes.typedDataView(int64List);
    log
      ..debug('int64s: $int64s')
      ..debug('int64list: $int64List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    var n = buf.readInt64();
    log.debug('Int64 = $n');
    expect(n, equals(int64s[0]));

    n = buf.readInt64();
    log.debug('Int64 = $n');
    expect(n, equals(int64s[1]));

    n = buf.readInt64();
    log.debug('Int64 = $n');
    expect(n, equals(int64s[2]));

    n = buf.readInt64();
    log.debug('Int64 = $n');
    expect(n, equals(int64s[3]));
  });

  test('Read Int64List Values', () {
    log.debug('*** Read Int64List Values');
    final int64s = [
      -25700000000,
      34010000000,
      -200000000000,
      300000000000,
      -4000000000000
    ];
    final int64List = Int64List.fromList(int64s);
    final bytes = Bytes.typedDataView(int64List);
    log
      ..debug('int64s: $int64s')
      ..debug('int64list: $int64List')
      ..debug('bytes: $bytes');
    final buf = ReadBuffer(bytes);

    final list = buf.readInt64List(int64List.length);
    log
      ..debug('int64List.lengthInBytes= ${int64List.lengthInBytes}')
      ..debug('int64List = $list');
    expect(list, equals(int64s));
  });

  test('Read Float32 Values', () {
    final floats = [0.0, -1.1, 2.2, -3.3, 4.4];
    final float32List = Float32List.fromList(floats);
    log..debug('float32List: $float32List');

    final buf = ReadBuffer.fromTypedData(float32List);
    var a = buf.readFloat32();
    log.debug('Float32 = $a');
    expect(a, equals(float32List[0]));
    a = buf.readFloat32();
    log.debug('Float32 = $a');
    expect(a, equals(float32List[1]));
    a = buf.readFloat32();
    log.debug('Float32 = $a');
    expect(a, equals(float32List[2]));
    a = buf.readFloat32();
    log.debug('Float32 = $a');
    expect(a, equals(float32List[3]));
  });

  test('Read Float32List Values', () {
    final floats = [0.0, -1.1, 2.2, -3.3, 4.4];
    final float32List = Float32List.fromList(floats);
    final bytes = Bytes.typedDataView(float32List);
    log..debug('float32List: $float32List');

    final buf = ReadBuffer(bytes);
    final list = buf.readFloat32List(float32List.length);
    log.debug('Float32List = $list');
    expect(list, equals(float32List));
  });

  test('Read Float64 Values', () {
    final floats = [0.0, -1.1e10, 2.2e11, -3.3e12, 4.4e13];
    final float64List = Float64List.fromList(floats);
    log..debug('float64List: $float64List')..debug('float8List: $float64List');

    final bytes = Bytes.typedDataView(float64List);
    final buf = ReadBuffer(bytes);
    var a = buf.readFloat64();
    log.debug('Float64 = $a');
    expect(a, equals(float64List[0]));
    a = buf.readFloat64();
    log.debug('Float64 = $a');
    expect(a, equals(float64List[1]));
    a = buf.readFloat64();
    log.debug('Float64 = $a');
    expect(a, equals(float64List[2]));
    a = buf.readFloat64();
    log.debug('Float64 = $a');
    expect(a, equals(float64List[3]));
  });

  test('Read Float64List Values', () {
    final floats = [0.0, -1.1e10, 2.2e11, -3.3e12, 4.4e13];
    final float64List = Float64List.fromList(floats);
    log..debug('float64List: $float64List');

    final bytes = Bytes.typedDataView(float64List);
    final buf = ReadBuffer(bytes);
    final list = buf.readFloat64List(float64List.length);
    log.debug('Float64List = $list');
    expect(list, equals(float64List));
  });
}
