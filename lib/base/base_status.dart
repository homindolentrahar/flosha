enum BaseStatus {
  initial("Initial"),
  loading("Loading"),
  loadMore("Load More"),
  success("Success"),
  error("Error"),
  empty("Empty");

  final String name;

  const BaseStatus(this.name);
}
