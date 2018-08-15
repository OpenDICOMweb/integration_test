//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';
import 'package:integration_test/src/tools/tag/tag_read_utils.dart';

import 'package:integration_test/data/test_files.dart';


void main() {
  Server.initialize(name: 'read_write_file', level: Level.debug);

  // *** Modify the [path0] value to read/write a different file
  const fPath = x11ivr;

  readWriteFileChecked(fPath, fileNumber: 1, width: 5, doLogging: true, fast: true);
}
