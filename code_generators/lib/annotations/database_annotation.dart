class DatabaseAnnotation {
  const DatabaseAnnotation({required this.forClassName});

  final String forClassName;
}

const databaseAnnotation = DatabaseAnnotation(forClassName: '');

class DatabaseMethodAnnotation {
  const DatabaseMethodAnnotation({required this.type});

  final String type;  
}