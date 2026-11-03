# swift-polygon

Use this package when you need a closed polygon as an ordered cycle of at least three vertices of any point type, with no arithmetic, equality or ordering required of the points. Start from `Polygon<Point>`. Use `Ngon<N, Point>` when the vertex count is part of the type, such as a triangle or quadrilateral. For a single edge, use `Segment<Point>` from swift-segment.

## Laws

- Closure is implicit: the edge at index `i` runs from vertex `i` to vertex `i + 1`, and the last edge runs from the last vertex back to the first. Repeating the first vertex at the end adds a vertex and a zero-length closing edge.
- The only validity rule is three or more vertices. Repeated or collinear vertices, zero-length edges, self-intersection and orientation are neither checked nor normalised.
- Equality and hashing compare the vertex sequence exactly. A cyclic shift or a reversal of the same polygon is a different value.
- `reversed` keeps the first vertex and reverses the order of the rest. Its edges are the original edges in reverse order, each reversed, and reversing twice returns the original.
- `map` keeps the vertex count and order. It calls the transform on vertices in traversal order and stops at the first failure. It does not merge vertices that map to the same value.
- `edge(at:)` traps unless the index is a valid vertex index.
- Encoding produces a bare array of the vertices in order, repetitions included. Decoding fails on fewer than three vertices or a vertex that fails to decode. Encoding and decoding need only `Encodable` or `Decodable` points respectively.
- `Ngon<N, Point>` requires `N >= 3` and exactly `N` vertices. An `Ngon` with `N` below three can never be constructed. It keeps the `Polygon<Point>` it was built from unchanged. `map` and `reversed` keep `N`. It encodes the same way as `Polygon<Point>`, and decoding fails unless exactly `N` vertices are present.
