class Pair<F, S> {
  final F first;
  final S second;
  const Pair(this.first, this.second);
  static Pair<F, S> create<F, S>(F f, S s) {
    return Pair<F, S>(f, s);
  }
  Pair<F, S> fromType(F f, S s) {
    return Pair<F, S>(f, s);
  }
  Pair<F, S> clone() {
    return Pair<F, S>(this.first, this.second);
  }
}
