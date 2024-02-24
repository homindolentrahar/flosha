class ErrorStateWrapper {
  final String? title;
  final String? message;

  ErrorStateWrapper(
    this.title,
    this.message,
  );

  factory ErrorStateWrapper.fromJson(Map<String, dynamic> json) =>
      ErrorStateWrapper(json['title'], json['message']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
      };
}
