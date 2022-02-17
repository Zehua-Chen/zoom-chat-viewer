class Participant {
  final String name;
  const Participant({required this.name});

  static const everyone = Participant(name: "Everyone");

  @override
  bool operator ==(Object other) {
    if (other is Participant) {
      return name == other.name;
    }

    return false;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return "Participant(name=$name)";
  }
}
