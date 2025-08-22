class Country {
  final String id;
  final String name;
  final String? alias;
  final String areaCode;
  final String countryCode;
  final String iconUrl;
  final bool isDefault;

  Country({
    required this.id,
    required this.name,
    this.alias,
    required this.areaCode,
    required this.countryCode,
    required this.iconUrl,
    required this.isDefault,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'] ?? json['名称'] ?? '',
      alias: json['别名'],
      areaCode: json['areaCode'] ?? json['区号'] ?? '',
      countryCode: json['countryCode'] ?? json['国家代码'] ?? '',
      iconUrl: json['iconUrl'],
      isDefault: (json['isDefault'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'areaCode': areaCode,
      'countryCode': countryCode,
      'iconUrl': iconUrl,
      'isDefault': isDefault ? 1 : 0,
    };
  }
}
