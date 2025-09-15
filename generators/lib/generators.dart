/* Copyright (c) 2021 Razeware LLC

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom
the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

Notwithstanding the foregoing, you may not use, copy, modify,
merge, publish, distribute, sublicense, create a derivative work,
and/or sell copies of the Software in any work that is designed,
intended, or marketed for pedagogical or instructional purposes
related to programming, coding, application development, or
information technology. Permission for such use, copying,
modification, merger, publication, distribution, sublicensing,
creation of derivative works, or sale is expressly withheld.

This project and source code may use libraries or frameworks
that are released under various Open-Source licenses. Use of
those libraries and frameworks are governed by their own
individual licenses.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE. */

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/json_generator.dart';
import 'src/model_generator.dart';
// import 'src/bloc_builder.dart';
// import 'src/blocs_builder.dart';
// import 'src/subclass_generator.dart';
import 'src/database_generator.dart';
import 'src/repository_generator.dart';

Builder generateModelMethods(BuilderOptions options) =>    
    PartBuilder([ModelGenerator()], '.kg_model.dart');

Builder generateRepositoryClass(BuilderOptions options) {
  // Step 1
  return PartBuilder(
    [RepositoryGenerator()], // Step 2
    '.kg_repository.dart', // Step 3
  );
}

Builder generateDatabaseClass(BuilderOptions options) {
  // Step 1
  return PartBuilder(
    [DatabaseGenerator() ], // Step 2
    '.kg_database.dart', // Step 3
  );
}

// Builder firebaseBuilder(BuilderOptions options) =>
// LibraryBuilder(FirebaseGenerator(), generatedExtension: '.firebase.dart');

// Builder blocBuilder(BuilderOptions options) => BlocBuilder();
// Builder blocsBuilder(BuilderOptions options) => BlocsBuilder();

// Builder subclassBuilder(BuilderOptions options) =>    
//     PartBuilder([SubclassGenerator()], '.g.dart');

