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

String magicAsString = 'DICOM-MD';
final Uint8List magic = magicAsString.codeUnits;

void main() {
  Server.initialize(name: 'bytes_test.dart', level: Level.debug);
  test('Read MetadataFile Magic value', () {
	  const s = 'DICOM-MD';
    final list = toUtf8(s);

    final rb = new ReadBuffer.fromList(list);
    final name = rb.readString(8);
    expect(name, equals('DICOM-MD'));
  });

  test('Create Bytes Read String', () {
    final listIn = ['foo', 'bar', 'baz'];
    final strings = listIn.join('\\');
    final bytes = Bytes.fromAscii(strings);

    final s = bytes.getAscii();
    expect(s, equals(strings));

    final listOut = s.split(r'\');
    expect(listOut, listIn);
  });


  test('Write then Read String', () {
    final listIn = ['foo', 'bar', 'baz'];
    final s = listIn.join('\\');
    log.debug('s: $s');
    final bytes = Bytes()..setAscii(0, s);
    final sOut = bytes.getAscii(offset:0, length: s.length);
    expect(sOut, equals(s));

    final listOut = s.split(r'\');
    expect(listOut, equals(listIn));
  });

  test('Write then Read String List', () {
    final listIn = ['foo', 'bar', 'baz'];
    final s = listIn.join(r'\');
    final bytes = Bytes()..setAscii(0, s);
    final listOut = bytes.getAsciiList(offset:0, length: s.length);
    expect(listOut, equals(listIn));
  });


  test('Read String List', () {
    final list = ['foo', 'bar', 'baz'];
    final strings = list.join('\\');
    final bytes = byteBufFromString(strings);
    final l1 = bytes.readStringList(strings.length);
    expect(l1, equals(list));
  });

  test('Read Int8 Values', () {
    final ints = [0, -1, 2, -3, 4];
    final int8list = new Int8List.fromList(ints);
    final bytes = int8list.buffer.asUint8List();
    final reader = new ReadBuffer.fromTypedData(bytes);

    var n = reader.readInt8();
    expect(n, equals(ints[0]));
    n = reader.readInt8();
    expect(n, equals(ints[1]));
    n = reader.readInt8();
    expect(n, equals(ints[2]));
    n = reader.readInt8();
    expect(n, equals(ints[3]));
  });

/*
  test('Read Int8List Values', () {
    final ints = [0, -1, 2, -3, 4];
    final int8list = new Int8List.fromList(ints);
    final bytes = int8list.buffer.asUint8List();
    var rb = new ReadBuffer.fromTypedData(bytes);

    var list = rb.readInt8List(int8list.lengthInBytes);
    expect(list, equals(ints));

    rb = new Bytes()..setInt8List(ints);
    list = rb.readInt8List(ints.length);
    expect(list, equals(ints));
  });
*/

/*
  test('Read Uint8 Values', () {
    final uints = <int>[0, 1, 2, 3, 4];
    final uint8list = new Uint8List.fromList(uints);
    final bytes = uint8list.buffer.asUint8List();
    final s = 'aaaaaaa aaaaaaa aaaaaaa aaaaaaaab';
    final bytes = new ReadBuffer();

    bytes.writeString(s)..writeUint8List(bytes);
    final t = bytes.getAscii(0, s.length);
    expect(t, equals(s));

    var n = bytes.readUint8();
    expect(n, equals(uints[0]));
    n = bytes.readUint8();
    expect(n, equals(uints[1]));
    n = bytes.readUint8();
    expect(n, equals(uints[2]));
    n = bytes.readUint8();
    expect(n, equals(uints[3]));
  });
*/

/*
  test('Read Uint8List Values', () {
    final uints = [0, 1, 2, 3, 4];
    final uint8List = new Uint8List.fromList(uints);
    final bytes = uint8List.buffer.asUint8List();
    var s = '01234567';
    var wb = new WriteBuffer()
      ..writeString(s)
      ..writeUint8List(bytes);
    var t = wb.readString(s.length);
    expect(t, equals(s));

    var list = wb.readUint8List(bytes.lengthInBytes);
    expect(list, equals(uints));

    s = 'aaaaaaaab';
    wb = new Bytes()
      ..writeString(s)
      ..writeUint8List(bytes);

    t = wb.readString(s.length);
    expect(t, equals(s));

    list = wb.readUint8List(uint8List.lengthInBytes);
    expect(list, equals(uints));

    wb = new Bytes()..setUint8List(uint8List);
    list = wb.readUint8List(uints.length);
    expect(list, equals(uints));
  });
*/

  test('Read Int16 Values', () {
    final int16s = [-257, 3401, -2000, 3000, -4000];
    final int16list = new Int16List.fromList(int16s);
    final uint8List = int16list.buffer.asUint8List();
    final bytes = new Bytes.fromList(uint8List);

    var n = bytes.getInt16(0);
    expect(n, equals(int16s[0]));
    n = bytes.getInt16(2);
    expect(n, equals(int16s[1]));
    n = bytes.getInt16(4);
    expect(n, equals(int16s[2]));
    n = bytes.getInt16(6);
    expect(n, equals(int16s[3]));
  });

  test('Read Int16List Values', () {
    final int16s = [-257, 3401, -2000, 3000, -4000];
    final int16List = new Int16List.fromList(int16s);

    final bytes0 = Bytes.typedDataView(int16List);
   // final rBuf = ReadBuffer(bytes);

    final list0 = bytes0.getInt16List(0, int16List.length);
    expect(list0, equals(int16s));

    final bytes1 = Bytes()..setInt16List(0, int16s);
    final list1 = bytes1.getInt16List(0, int16s.length);
    expect(list1, equals(int16s));
  });

  test('Read Uint16 Values', () {
    final ints = [257, 3401, 2000, 3000, 4000];
    final uint16List = Uint16List.fromList(ints);
    final bytes = Bytes.typedDataView(uint16List);

    var n = bytes.getUint16(0);
    expect(n, equals(ints[0]));
    n = bytes.getUint16(2);
    expect(n, equals(ints[1]));
    n = bytes.getUint16(4);
    expect(n, equals(ints[2]));
    n = bytes.getUint16(6);
    expect(n, equals(ints[3]));
  });

  test('Read Uint16List Values', () {
    final uint16s = <int>[257, 3401, 2000, 3000, 4000];
    final uint16List = new Uint16List.fromList(uint16s);
    var bytes = Bytes.typedDataView(uint16List);

    //  print(bytes.info);
    var list = bytes.getUint16List(0, uint16List.length);

    expect(uint16s, equals(uint16s));

    bytes = new Bytes()..setUint16List(0, uint16List);
    list = bytes.getUint16List(0, uint16s.length);
    expect(list, equals(uint16s));
  });

  test('Read Int32 Values', () {
    final int32s = [-257000, 3401000, -2000000, 3000000, -4000000];
    final int32list = new Int32List.fromList(int32s);
    final bytes = Bytes.typedDataView(int32list);

    var n = bytes.getInt32(0);
    expect(n, equals(int32s[0]));
    n = bytes.getInt32(4);
    expect(n, equals(int32s[1]));
    n = bytes.getInt32(8);
    expect(n, equals(int32s[2]));
    n = bytes.getInt32(12);
    expect(n, equals(int32s[3]));
  });

  test('Read Int32List Values', () {
    final int32s = [-257000, 3401000, -2000000, 3000000, -4000000];
    final int32List = new Int32List.fromList(int32s);
    var bytes = Bytes.typedDataView(int32List);
    var list = bytes.getInt32List();
    expect(list, equals(int32s));

    bytes = new Bytes()..setInt32List(0, int32List);
    list = bytes.getInt32List(0, int32s.length);
    expect(list, equals(int32s));
  });

  test('Read Uint32 Values', () {
    final uint32s = [2570000, 34010000, 20000000, 30000000, 400000000];
    final uint32list = new Uint32List.fromList(uint32s);
    final bytes = Bytes.typedDataView(uint32list);

    var n = bytes.getUint32(0);
    expect(n, equals(uint32s[0]));
    n = bytes.getUint32(4);
    expect(n, equals(uint32s[1]));
    n = bytes.getUint32(8);
    expect(n, equals(uint32s[2]));
    n = bytes.getUint32(12);
    expect(n, equals(uint32s[3]));
  });

  test('Read Uint32List Values', () {
    final uint32s = [2570000, 34010000, 20000000, 30000000, 40000000];
    final uint32list = new Uint32List.fromList(uint32s);
    var bytes = Bytes.typedDataView(uint32list);
    var list = bytes.getUint32List();
    expect(list, equals(uint32s));

    bytes = new Bytes()..setUint32List(0, uint32s);
    list = bytes.getUint32List(0, uint32s.length);
    expect(list, equals(uint32s));
  });

  test('Read Int64 Values', () {
    final int64s = [
      -25700000000,
      34010000000,
      -200000000000,
      300000000000,
      -4000000000000
    ];
    final int64list = new Int64List.fromList(int64s);
    final bytes = Bytes.typedDataView(int64list);

    var n = bytes.getInt64(0);
    expect(n, equals(int64s[0]));
    n = bytes.getInt64(8);
    expect(n, equals(int64s[1]));
    n = bytes.getInt64(16);
    expect(n, equals(int64s[2]));
    n = bytes.getInt64(24);
    expect(n, equals(int64s[3]));
  });

  test('Read Int64List Values', () {
    final int64s = [
      -25700000000,
      34010000000,
      -200000000000,
      300000000000,
      -4000000000000
    ];
    final int64list = new Int64List.fromList(int64s);
    var bytes = Bytes.typedDataView(int64list);
    var list = bytes.getInt64List(0, int64list.length);
    expect(list, equals(int64s));

    bytes = new Bytes()..setInt64List(0, int64s);
    list = bytes.getInt64List(0, int64s.length);
    expect(list, equals(int64s));
  });

  test('Read Uint64 Values', () {
    final uint64s = [25700000000, 34010000000, 200000000000, 300000000000, 4000000000000];
    final uint64list = new Uint64List.fromList(uint64s);
    final bytes = Bytes.typedDataView(uint64list);

    var n = bytes.getUint64(0);
    expect(n, equals(uint64s[0]));
    n = bytes.getUint64(8);
    expect(n, equals(uint64s[1]));
    n = bytes.getUint64(16);
    expect(n, equals(uint64s[2]));
    n = bytes.getUint64(24);
    expect(n, equals(uint64s[3]));
  });

  test('Read Uint64List Values', () {
    final uint64s = [25700000000, 34010000000, 200000000000, 300000000000, 4000000000000];
    final uint64list = new Uint64List.fromList(uint64s);
    var bytes = Bytes.typedDataView(uint64list);
    var list = bytes.getUint64List();
    expect(list, equals(uint64s));

    bytes = new Bytes()..setUint64List(0, uint64s);
    list = bytes.getUint64List(0, uint64s.length);
    expect(list, equals(uint64s));
  });

  test('Read Float32 Values', () {
    final floats = [0.0, -1.1, 2.2, -3.3, 4.4];
    final float32List = new Float32List.fromList(floats);
    final bytes = Bytes.typedDataView(float32List);

    var a = bytes.getFloat32(0);
    expect(a, equals(float32List[0]));
    a = bytes.getFloat32(4);
    expect(a, equals(float32List[1]));
    a = bytes.getFloat32(8);
    expect(a, equals(float32List[2]));
    a = bytes.getFloat32(12);
    expect(a, equals(float32List[3]));
  });

  test('Read Float32List Values', () {
    final floats = [0.0, -1.1, 2.2, -3.3, 4.4];
    final float32List = new Float32List.fromList(floats);
    final float8List = float32List.buffer.asUint8List();
    var bytes = Bytes.typedDataView(float8List);

    var list = bytes.getFloat32List(0, float32List.length);
    expect(list, equals(float32List));

    bytes = new Bytes()..setFloat32List(0, float32List);
    list = bytes.getFloat32List(0, floats.length);
    expect(list, equals(float32List));
  });

  test('Read Float64 Values', () {
    final floats = [0.0, -1.1e10, 2.2e11, -3.3e12, 4.4e13];
    final float64List = new Float64List.fromList(floats);
    final float8List = float64List.buffer.asUint8List();
    final bytes = Bytes.typedDataView(float8List);

    var a = bytes.getFloat64(0);
    expect(a, equals(float64List[0]));
    a = bytes.getFloat64(8);
    expect(a, equals(float64List[1]));
    a = bytes.getFloat64(16);
    expect(a, equals(float64List[2]));
    a = bytes.getFloat64(24);
    expect(a, equals(float64List[3]));
  });

  test('Read Float64List Values', () {
    final floats = [0.0, -1.1e10, 2.2e11, -3.3e12, 4.4e13];
    final float64List = new Float64List.fromList(floats);
    final float8List = float64List.buffer.asUint8List();
    var bytes = Bytes.typedDataView(float8List);
    var list = bytes.getFloat64List(0, float64List.length);
    expect(list, equals(float64List));

    bytes = new Bytes()..setFloat64List(0, floats);
    list = bytes.getFloat64List(0, floats.length);
    expect(list, equals(float64List));
  });
}
