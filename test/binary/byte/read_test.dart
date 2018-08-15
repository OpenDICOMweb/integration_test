//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:io';
import 'dart:typed_data';

import 'package:core/server.dart' hide group;
import 'package:test/test.dart';

import 'package:converter/converter.dart';

void main() {
  Server.initialize(
      name: 'dcm_reader_test', level: Level.debug, throwOnError: true);
  const path0 = 'C:/odw_test_data/mweb/TransferUIDs/1.2.840.10008.1.2.5.dcm';

  group('description', () {
    test('instance', () {
      final Uint8List uint8List = File(path0).readAsBytesSync();
      final bytes = Bytes.typedDataView(uint8List);
      final TagRootDataset rds = TagReader.readBytes(bytes);
      log.debug('${rds.info}');
      for (var e in rds.elements) log.debug('$e');
      final entity = activeStudies.entityFromRootDataset(rds);
      log.debug('${entity.info}');
    });
  });
}
