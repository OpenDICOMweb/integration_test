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

/// The Basic De-Identification Profile algorithm performed by this program.
///
/// 1. Read the first SOP Instance for a study as a ByteRootDataset.
/// 2. Delete all elements on the Basic Profile delete list
/// 3. Find all private elements and then delete them
/// 4. Find any private elements in public sequences and delete them.
/// 5. Convert the BDRootDataset to a TagRootDataset
/// 6. Update all non-well-known Uids to 2.25 Uids (recursively)
/// 7. Normalize all Dates.
/// 8. write the TagRootDataset without Bulkdata
///    a. write dicom-md (studyUid/seriesUid/instanceUid.dcmmd)
///    b. write .dicom-md+json (studyUid/seriesUid/instanceUid.dcmjson)
/// 9. write stats to .stats including idUid->deIdUid Map.

const String k6684Dir = 'C:/acr/odw/test_data/6684';

const String k6684x0 =
    'C:/acr/odw/test_data/6684/2017/5/12/21/E5C692DB/A108D14E/A619BCE3';

const String k6684x1 =
    'c:/acr/odw/test_data/6684/2017/5/13/1/8D423251/B0BDD842/E52A69C2';

Formatter z = new Formatter(maxDepth: -1);

/// Implements basic profile with Retain Logitudinal Date option and
/// Retain Safe Private option

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

  /// Read the Study as BD
  final bList = new File(fPath).readAsBytesSync();
  final reader = new ByteReader(bList);
  final bdRds = ByteReader.readPath(fPath, doLogging: false);
  if (bdRds == null) {
    log.warn('Invalid DICOM file: $fPath');
  } else {
    if (reader.pInfo != null) {
      final infoPath = '${path.withoutExtension(fPath)}.info';
      log.info('infoPath: $infoPath');
      final sb = new StringBuffer('${reader.pInfo.summary(bdRds)}\n')
        ..write('Bytes Dataset: ${bdRds.summary}');
      new File(infoPath)..writeAsStringSync(sb.toString());
      log.debug(sb.toString());

      final fmtPath = '${path.withoutExtension(fPath)}.fmt';
      log.info('fmtPath: $fmtPath');
      final fmtOut = bdRds.format(z);
      new File(fmtPath)..writeAsStringSync(sb.toString());
      log.debug(fmtOut);
    } else {
      print('${bdRds.summary}');
      print('bdRDS: ${bdRds.format(z)}');
    }
  }

  print(z.fmt('FMI: ${bdRds.fmi.length}', bdRds.fmi.elements));
  const outPath = 'out.json';
  final writer0 = new FastJsonWriter(bdRds, outPath, separateBulkdata: true);
  final out = writer0.write();
  await new File(outPath).writeAsString(out);
  log
    ..debug('Wrote JSON: $outPath')
    ..debug('  Length: ${out.length} bytes ${out.length ~/ 1024}K');

  // Delete all X Elements (excluding DA and UI) in Basic DeId Profile
  final deleted = bdRds.deleteCodes(deIdRemoveCodes);
  print('deIdXCodes deleted: ${deleted.length} of ${deIdRemoveCodes.length}');

/*
  // Delete all Private Elements
  final privatesDeleted = bdRds.deleteAllPrivate();
  print('Privates deleted: ${privatesDeleted.length}');

  final privatesInPublicSQs =
      bdRds.deleteAllPrivateInPublicSQs(recursive: false);
  print('Privates in Public SQs: ${privatesInPublicSQs.length}');
  print('bdRds Summary: ${bdRds.summary}');
*/

  // Convert BDRootDataset to TagRootDataset
  final tagRds = new DatasetConverter(bdRds).convert();
  print('tagRDS Summary: ${tagRds.summary}');
//  print('tagRDS: ${tagRds.format(z)}');

  // Normalize Dates
  final enrollment = new Date(1980, 2, 1);
  final dList = normalizeDates(tagRds, enrollment);
  print(z.fmt('Dates normalized: ${dList.length}', dList));

  // Anonimize UIDs
  final uids0 = tagRds.findUids();
  print(z.fmt('Old Uids Present: ${uids0.length}', uids0));

  final oldUIs = replaceUids(tagRds);
  print(z.fmt('Replaced Uids: ${oldUIs.length}', oldUIs));

  final newUids = tagRds.findUids();
  print(z.fmt('Replaced old Uids: ${newUids.length}', newUids));
//  final uids1 = tagRds.findUids();
  print(z.fmt('    with new Uids: ${newUids.length}', newUids));
  print('tagRDS Summary after Uid replacement: ${tagRds.summary}');

  print(z.fmt('tagRds: ${tagRds.elements.length}', tagRds.elements));
  const deIdPath = 'deid.json';
  final writer1 = new FastJsonWriter(tagRds, deIdPath, separateBulkdata: true);
  final deid = writer1.write();
  print('  Length: ${deid.length} bytes ${deid.length ~/ 1024}K');
  await new File(deIdPath).writeAsString(deid);
  print('done');
}

Future<Uint8List> readFileAsync(File file) async => await file.readAsBytes();

String getTempFile(String infile, String extension) {
  final name = path.basenameWithoutExtension(infile);
  final dir = Directory.systemTemp.path;
  return '$dir/$name.$extension';
}
