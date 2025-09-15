import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/model/model_generator.dart';

Builder generateModelMethods(BuilderOptions options) =>
    SharedPartBuilder([ModelGenerator()], 'flutter_code_generator');

// Builder generateRepositoryClass(BuilderOptions options) {
//   // Step 1
//   return PartBuilder(
//     [RepositoryGenerator()], // Step 2
//     '.kg_repository.dart', // Step 3
//   );
// }

// Builder generateDatabaseClass(BuilderOptions options) {
//   // Step 1
//   return PartBuilder(
//     [DatabaseGenerator() ], // Step 2
//     '.kg_database.dart', // Step 3
//   );
// }

// Builder firebaseBuilder(BuilderOptions options) =>
// LibraryBuilder(FirebaseGenerator(), generatedExtension: '.firebase.dart');

// Builder blocBuilder(BuilderOptions options) => BlocBuilder();
// Builder blocsBuilder(BuilderOptions options) => BlocsBuilder();

// Builder subclassBuilder(BuilderOptions options) =>    
//     PartBuilder([SubclassGenerator()], '.g.dart');

