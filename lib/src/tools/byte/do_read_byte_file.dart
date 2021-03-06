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

import 'package:core/core.dart';
import 'package:converter/converter.dart';

// ignore_for_file: avoid_catches_without_on_clauses

Future<Uint8List> readFileFast(File f, {bool fast = true}) async =>
    (fast) ? await f.readAsBytes() : f.readAsBytesSync();

Future<Uint8List> readFileAsync(File f) async {
  final bytes = await f.readAsBytes();
  print(bytes.length);
  return bytes;
}

Uint8List readFileSync(File f) => f.readAsBytesSync();

//Urgent make sure garbage is not being retained
//Urgent Test async
Future<bool> doReadByteFile(File f,
    {bool throwOnError = true,
    bool fast = true,
    bool isAsync = true,
    bool showStats = true}) async {
  final pad = ''.padRight(5);
  final cPath = cleanPath(f.path);
  RootDataset rds0;

  try {
    final bytes = File(cPath).readAsBytesSync();
    if (bytes == null) return false;
    final doLogging = global.level > Level.debug;
    final reader0 = new ByteReader.fromBytes(bytes, doLogging: doLogging);

    rds0 = reader0.readRootDataset();
    if (rds0 == null) {
      log.info0('Unreadable File: $cPath');
      return false;
    }
    if (reader0.pInfo != null)
      log.debug('$pad    ${reader0.pInfo.summary(rds0)}');

// TODO: move into dataset.warnings.
    final e = rds0[kPixelData];
    if (e == null) {
      log.info1('$pad ** Pixel Data Element not present');
    } else {
      log.debug1('$pad  e: ${e.info}');
    }
    if (rds0.hasDuplicates) log.warn('$pad  ** Duplicates Present in rds0');
  } on ShortFileError {
    log.warn('$pad ** Short File(${f.lengthSync()} bytes): $cPath');
    if (throwOnError) rethrow;
  } on InvalidTransferSyntax catch (e) {
    log.error(e);
    return false;
  } catch (e) {
    log.error('Caught $e\n  on File: $f');
  }
  if (rds0 != null) {
    log
      ..info1('$pad Success!')
      ..debug('summary: ${rds0.summary}');
  }
  return true;
}
