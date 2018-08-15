import 'dart:async';
import 'dart:io';

import 'package:converter/converter.dart';
import 'package:core/server.dart';
import 'package:integration_test/data/test_files.dart';

Future main() async {
  Server.initialize(name: 'ReadFile', level: Level.info, throwOnError: true);

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
      getOutputPath(inPath, dir: 'bin/output', base: base, ext: 'json');
  log.info('outPath: $outPath');
  final out =
      new JsonWriter(rds, outPath, separateBulkdata: true, tabSize: 2).write();
  log.info('Output length: ${out.length}(${out.length ~/ 1024}K)');
  new File(outPath).writeAsStringSync(out);
  log.info('done');
}
