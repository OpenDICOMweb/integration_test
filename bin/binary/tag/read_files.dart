//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/core.dart';
import 'package:io_extended/io_extended.dart';

const String dir6684_2017_5 = 'C:/acr/odw/test_data/6684/2017/5';

void main() {
  // readFile(path0);

  const dir = dir6684_2017_5;
  final files = fileListFromDirectory(dir);
  _readFiles(files);
}

void _readFiles(List<String> paths) {
  log.info0('Reading $paths Files:');
  new FileListReader(paths)..read;
}

final Formatter z = new Formatter(maxDepth: 146);



