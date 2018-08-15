//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:io';
import 'dart:typed_data';

import 'package:converter/converter.dart';
import 'package:core/core.dart';
import 'package:io_extended/io_extended.dart';


/// Read a file then write it to a buffer.
bool doRWFileDebug(File f, {bool throwOnError = false, bool fast = true}) {
  log.level = Level.debug3;
  //TODO: improve output
  //  var n = getPaddedInt(fileNumber, width);
  final pad = ''.padRight(5);
  final Uint8List bList = f.readAsBytesSync();
  final reader0 = new ByteReader(bList);
  final rds0 = reader0.readRootDataset();
  showRDS(rds0, reader0);

  // TODO: move into dataset.warnings.
  final e = rds0[kPixelData];
  if (e == null) {
    log.info1('$pad ** Pixel Data Element not present');
  } else {
    log.debug1('$pad  e: ${e.info}');
  }

  // Write the Root Dataset
  log.info('Writing $rds0');
  final writer = new ByteWriter(rds0);
  final bytes1 = writer.writeRootDataset();
  if (!fast) {
    // write the file
    final outPath = getTempFile(f.path, 'dcmout');
    File(outPath).writeAsBytesSync(bytes1);
  }
  log.debug('$pad    Encoded ${bytes1.length} bytes');
  final reader1 = ByteReader.fromBytes(bytes1);
  final rds1 = reader1.readRootDataset();
  showRDS(rds1, reader1);


  // Urgent Jim if file has dups then no test is done. Fix it.
  var same = true;
  String msg;
  // If duplicates are present the [ElementOffsets]s will not be equal.
  if (!rds0.hasDuplicates) {
    //  Compare the data byte for byte
    same = Uint8.equal(reader0.rb.asUint8List(), reader1.rb.asUint8List());
    msg = (same != true) ? '**** Files were different!!!' : 'Files were identical.';
  } else {
    msg = '''
    	Files were not comparable!!!
    	''';
  }

  log.info('''\n
$f  
  Read ${reader0.rb.length} bytes
    DS0: ${rds0.info}'
    ${rds0.transferSyntax}
    $reader0
  Wrote ${bytes1.length} bytes
    $msg
    $writer
    
  ''');
  return same;
}

void showRDS(ByteRootDataset rds,  ByteReader reader) {
	final e = rds[kPixelData];
	final pdMsg =  (e == null)
	? ' ** Pixel Data Element not present'
			: e.info;

	final bytes0 = reader.rb.asUint8List();

  log.debug('''\n
Read ${bytes0.length} bytes
     RDS: ${rds.info}'
      TS: ${rds.transferSyntax}
  Pixels: $pdMsg
  $reader
  ${reader.pInfo.summary(rds)}
''');
}
