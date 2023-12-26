class LoanQuestionnaire {
  String title;
  String name;
  String slug;
  String description;
  List<Question>? fields;

  LoanQuestionnaire(
      {required this.title,
      required this.name,
      required this.slug,
      required this.description,
      this.fields});

  factory LoanQuestionnaire.fromJson(Map<String, dynamic> json) {
    return LoanQuestionnaire(
      title: json['title'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      fields: json['schema'] != null && json['schema']['fields'] != null
          ? (json['schema']!['fields']! as List)
              .map((field) => Question.fromJson(field))
              .toList()
          : [],
    );
  }
}

class Question {
  String? type;
  int? version;
  QuestionSchema? schema;

  Question({
    this.type,
    this.version,
    this.schema,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'],
      version: json['version'],
      schema: QuestionSchema.fromJson(json['schema']),
    );
  }
}

class QuestionSchema {
  String? name;
  String? label;
  dynamic hidden;
  bool? readonly;
  List<Option>? options;
  List<Question>? fields;

  QuestionSchema(
      {this.name,
      this.label,
      this.hidden,
      this.readonly,
      this.options,
      this.fields});

  factory QuestionSchema.fromJson(Map<String, dynamic> json) {
    return QuestionSchema(
        name: json['name'],
        label: json['label'],
        hidden: json['hidden'],
        readonly: json['readonly'],
        options: json['options'] != null
            ? (json['options'] as List)
                .map((option) => Option.fromJson(option))
                .toList()
            : [],
        fields: json['fields'] != null
            ? (json['fields'] as List)
                .map((field) => Question.fromJson(field))
                .toList()
            : []);
  }
}

class Option {
  String? key;
  String? value;

  Option({this.key, this.value});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(key: json['key'], value: json['value']);
  }
}

class Detail {
  String? label;
  dynamic value;

  Detail({required this.label, required this.value});
}
