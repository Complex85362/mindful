class WellnessCategory{
  final String id;
  final String name;
  final String? iconUrl;

  const WellnessCategory({
    required this.id,
    required this.name,
    this.iconUrl,
});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WellnessCategory && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}