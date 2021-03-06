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
import 'dart:typed_data';

import 'package:converter/converter.dart';
import 'package:core/server.dart';
import 'package:integration_test/src/utilities/io_utils.dart';
import 'package:path/path.dart' as path;

const String k6684Dir = 'C:/acr/odw/test_data/6684';

const String k6684x0 =
    'C:/acr/odw/test_data/6684/2017/5/12/21/E5C692DB/A108D14E/A619BCE3';

const String k6684x1 =
    'c:/odw/test_data/6684/2017/5/13/1/8D423251/B0BDD842/E52A69C2';

Formatter z = new Formatter(maxDepth: -1);

Future main() async {
  Server.initialize(name: 'ReadFile', level: Level.debug, throwOnError: true);

  const fPath = k6684x0;
  final z = new Formatter.basic();

  print('path: $fPath');
  print(' out: ${getTempFile(fPath, 'dcmout')}');
  final url = new Uri.file(fPath);
  stdout.writeln('Reading(byte): $url');

  final bytes = readPath(fPath);
  if (bytes == null) {
    log.error('"$fPath" either does not exist or is not a valid DICOM file');
    return;
  } else {
    stdout.writeln('  Length in bytes: ${bytes.length}');
  }
  final reader = new ByteReader.fromBytes(bytes);
  final bdRDS = reader.readRootDataset();

  if (bdRDS == null) {
    log.warn('Invalid DICOM file: $fPath');
  } else {
    if (reader.pInfo != null) {
      final infoPath = '${path.withoutExtension(fPath)}.info';
      log.info('infoPath: $infoPath');
      final sb = new StringBuffer('${reader.pInfo.summary(bdRDS)}\n')
        ..write('Bytes Dataset: ${bdRDS.summary}');
      new File(infoPath)..writeAsStringSync(sb.toString());
      log.debug(sb.toString());

      final fmtPath = '${path.withoutExtension(fPath)}.fmt';
      log.info('fmtPath: $fmtPath');
      final fmtOut = bdRDS.format(z);
      new File(fmtPath)..writeAsStringSync(sb.toString());
      log.debug(fmtOut);
    } else {
      log.debug('${bdRDS.summary}');
      //  log.debug('bdRDS: ${bdRDS.format(z)}');
    }
  }

  const outPath = 'out.json';
  final writer0 = new FastJsonWriter(bdRDS, outPath, separateBulkdata: true);
  final out = writer0.write();

  log
    ..debug('Length Bytes: ${out.length}')
    ..debug('Length KB: ${out.length ~/ 1024}KB');
  await new File(outPath).writeAsString(out);

  final tagRds = TagRootDataset.convert(bdRDS);
  log.debug('${tagRds.summary}');

  final dates0 = tagRds.findDates();
  print(z.fmt('Original: ${dates0.length}', dates0));

  final enrollment = new Date(1980, 2, 1);
  final dates1 = normalizeDeIdDates(tagRds, enrollment);
  print(z.fmt('Normalized: ${dates1.length}', dates1));

  final dates2 = tagRds.findDates();
  print(z.fmt('Final: ${dates2.length}', dates2));

  const deIdPath = 'deid.json';
  final writer1 = new FastJsonWriter(tagRds, deIdPath, separateBulkdata: true);
  final deid = writer1.write();
  log
    ..debug('Length bytes: ${deid.length}')
    ..debug('   Length KB: ${deid.length ~/ 1024}K');
  await new File(deIdPath).writeAsString(deid);
  log.debug('done');
}

Future<Uint8List> readFileAsync(File file) async => await file.readAsBytes();

String getTempFile(String infile, String extension) {
  final name = path.basenameWithoutExtension(infile);
  final dir = Directory.systemTemp.path;
  return '$dir/$name.$extension';
}
