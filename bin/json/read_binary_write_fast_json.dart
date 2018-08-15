//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:async';
import 'dart:io';

import 'package:converter/converter.dart';
import 'package:core/server.dart';

import 'package:integration_test/data/test_files.dart';

Future main() async {
  Server.initialize(
      name: 'Read Binary write FastJson',
      level: Level.debug,
      throwOnError: true);

  final inPath = cleanPath(k6684x0);
  log.info('path: $inPath');
  stdout.writeln('Reading(byte): $inPath');

  final rds = ByteReader.readPath(inPath, doLogging: false);
  if (rds == null) {
    log.warn('Invalid DICOM file: $inPath');
  } else {
    log.info('${rds.summary}');
  }

  final study = rds.getUid(kStudyInstanceUID);
  final series = rds.getUid(kSeriesInstanceUID);
  final instance = rds.getUid(kSOPInstanceUID);
  final base = '$study-$series-$instance';
  final outPath =
      getOutputPath(inPath, dir: 'bin/output', base: base, ext: 'fjson');
  log.info('outPath: $outPath');
  final out =
      new FastJsonWriter(rds, outPath, separateBulkdata: true, tabSize: 2)
          .write();
  log.info('Output length: ${out.length}(${out.length ~/ 1024}K)');
  new File(outPath).writeAsStringSync(out);
  log.info('done');
}
