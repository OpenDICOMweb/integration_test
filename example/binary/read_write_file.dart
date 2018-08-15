//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:io';

import 'package:converter/converter.dart';
import 'package:core/server.dart';

const String k6684x0 = 'C:/acr/odw/sdk/convert/bin/output/'
    '1.2.840.113745.101000.1061000.41090.4218.18582671-'
    '1.3.46.670589.11.21290.5.0.6524.2012072512045421001-'
    '1.3.46.670589.11.21290.5.0.6524.2012072512045712193.fjson';

void main() {
  Server.initialize(name: 'ReadFile', level: Level.debug, throwOnError: true);

  final inPath = cleanPath(k6684x0);
  log.info('path: $inPath');
  final len0 = new File(inPath).lengthSync();
  stdout.writeln('Reading($len0 bytes): $inPath');

  final rds = ByteReader.readPath(inPath, doLogging: true);
  if (rds == null) {
    log.warn('Invalid DICOM file: $inPath');
  } else {
    log.info('${rds.summary}');
  }

  final outPath = getVNAPath(rds, 'bin/output', 'dcm');
  final bytes = ByteWriter.writeBytes(rds);
  final out = File(outPath)..writeAsBytesSync(bytes);
  final len1 = out.lengthSync();

  log
    ..info('outPath: $outPath')
    ..info('Output length: $len1 (${len1 ~/ 1024}K)')
    ..info('done');
}
