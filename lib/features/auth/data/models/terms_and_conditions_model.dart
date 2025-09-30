class TermsAndConditionsModel {
  final int id;
  final String text;
  final String body;

  TermsAndConditionsModel({
    required this.id,
    required this.text,
    required this.body,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'body': body,
    };
  }
}

class TermsAndConditionsResponse {
  final int status;
  final String message;
  final List<TermsAndConditionsModel> data;

  TermsAndConditionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TermsAndConditionsResponse.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsResponse(
      status: json['status'] ?? 200,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => TermsAndConditionsModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
