//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';
import 'package:integration_test/src/tools/byte/file_list_reader.dart';
import 'package:integration_test/src/utilities/io_utils.dart';

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';
String outRoot4 = 'test/output/root4';

const String k6684 = 'C:/acr/odw/test_data/6684';
const String k6688 = 'C:/acr/odw/test_data/6688';
const String dir6684_2017_5 = 'C:/acr/odw/test_data/6684/2017/5';

void main() {
  Server.initialize(
      name: 'read_write_file', level: Level.info, throwOnError: true);

/*
  /// *** Change directory path name here
  const path = dir6684_2017_5;
  final dir = new Directory(path);
  final fList = dir.listSync(recursive: true);
  final fsEntityCount = fList.length;
  print('List length: $fsEntityCount');
  log.debug('FSEntity count: $fsEntityCount');

  final files = fileListFromDirectory(dir6684_2017_5);
  for (var fse in fList) {
    if (fse is! File) continue;
    final path = fse.path;
    final ext = p.extension(path);
    if (ext == '.dcm' || ext == '') {
      log.debug1('$fse');
      files.add(fse.path);
    }
  }
*/
  const dir = dir6684_2017_5;
  final files = fileListFromDirectory(dir);
  final timer = new Timer();
  log.config('Reading ${files.length} files from $dir:');
  new FileListReader(files,
      fmiOnly: false, throwOnError: throwOnError, printEvery: 100)
    ..read;
  log.config('Elapsed time: ${timer.elapsed}');
}
