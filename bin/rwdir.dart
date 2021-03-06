//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:io';

import 'package:batch_job/batch_job.dart';
import 'package:core/server.dart';
import 'package:integration_test/src/tools/do_rw_file.dart';

//import 'package:convert/data/test_directories.dart';

/// rwdir is a fast correctness checker for the convert package.
///
/// It first reads and parses a DICOM file into a buffer, then writes it
/// to a second buffer, and finally does a byte by byte comparison of the two buffers.

const String k6684 = 'C:/acr/odw/test_data/6684';
const String k6688 = 'C:/acr/odw/test_data/6688';
const String defaultDirectory =
    'C:/acr/odw/test_data/6684/2017/5/12/16/0EE11F7A';

/// A program for doing read/write/read testing on DICOM files.
void main(List<String> args) {
  Server.initialize(name: 'rwdir', level: Level.debug, throwOnError: true);

  /// The processed arguments for this program.
  final jobArgs = new JobArgs(args ?? [defaultDirectory]);

  if (jobArgs.showHelp) showHelp(jobArgs);

  JobRunner.job(jobArgs, doRWFile,
      interval: jobArgs.shortMsgInterval,
      level: log.level,
      throwOnError: true);
}

/// The help message
void showHelp(JobArgs jobArgs) {
  final msg = '''
Usage: rwrdir <input-directory> [<options>]

For each application/dicom file in the <directory> tree:
  1. Decodes (reads) the data in a byte array (file) into a Root Dataset [0]
  2. Encodes (writes) the Root Dataset into a new byte array
  3. Decodes (reads) the new bytes array (file) into a new Root Dataset [1]
  4. It than compares the ElementOffsets, Datasets, and bytes arrays to 
    determine whether the writter and re-read Dataset and bytes are equivalent
    to the original byte array that was read in step 1.
    
Options:
${jobArgs.parser.usage}
''';
  stdout.write(msg);
  exit(0);
}
