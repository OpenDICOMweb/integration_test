//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';
import 'package:batch_job/batch_job.dart';

//TODO: modify so that it takes the following arguments
// 1. dirname
// 2. reportIncrement
void main() {
  /// The processed arguments for this program.
  JobArgs jobArgs;

  Server.initialize(name: 'read_file_list.dart', level: Level.debug);

  print(jobArgs.info);

//  if (jobArgs.showHelp) showHelp();

//  system.log.level = jobArgs.logLevel;

//  final FileMapReaser reader = new FileMapReader();

//  JobRunner.fileList(reader, doReadByteFile, level: Level.info);
}
