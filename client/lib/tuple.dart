library tuple;

import 'package:quiver/core.dart';

class Tuple<F, S> {
  F first;
  S second;

  Tuple(this.first, this.second);

  bool operator ==(Tuple<F, S> o) => o is Tuple<F, S> && first == o.first && second == o.second;
  int get hashCode => hash2(first.hashCode, second.hashCode);
}
