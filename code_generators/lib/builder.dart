import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/model/model_generator.dart';
import 'src/repository/repository_generator.dart';

Builder modelGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([ModelGenerator()], 'model_generator');

Builder repositoryGeneratorBuilder(BuilderOptions options) =>
    SharedPartBuilder([RepositoryGenerator()], 'repository_generator');

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

