enum BaseStatus {
  initial("Initial"),
  loading("Loading"),
  success("Success"),
  error("Error"),
  empty("Empty");

  final String name;

  const BaseStatus(this.name);
}
