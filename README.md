# Polygon

An ordered polygonal boundary with at least three vertices and implicit closure.
Segment owns its edges. Point owns any coordinates; point tags retain frame and
unit identity. Polygon does not invent another coordinate or displacement type.

```swift
import Polygon
import Point

let triangle = Polygon(Point(x: 0, y: 0), Point(x: 4, y: 0), Point(x: 0, y: 3))
let closingEdge = triangle.edge(at: 2) // last vertex to first
let backwards = triangle.reversed
let quadrilateral = Polygon("a", "b", "c", "d")
```

`init(vertices:)` throws `Polygon<Point>.Error.insufficientVertices` for fewer
than three entries. The first-three-plus-remaining constructor cannot fail.
The array cannot be mutated through Polygon to violate its cardinality. The
first vertex need not be repeated at the end: closure is intrinsic. If callers
do repeat it, that entry is preserved and adds a degenerate closing edge.

The atom establishes a boundary representation only. It does not imply distinct
vertices, nonzero area, simplicity, planarity, winding sign, convexity, or an
interior/fill rule. Those need an explicit geometric interpretation and further
validation. Degenerate or self-intersecting boundaries remain representable.

Equality/hashing compare the ordered vertex list, including its chosen start;
cyclic shifts or reversed traversal are not canonicalized. Reversal preserves
the first vertex. Mapping preserves count/order/closure, not geometric properties.
No arbitrary ordering or arithmetic is imposed on Point. Edges are available
even when Point supports neither equality nor numeric operations.

Conditional coding uses an array and routes decoding through the same count
validation. Encoding and decoding conformances are independent. Production
depends only on Segment; Point and Tagged are explicit test dependencies.
Resolve URL dependencies locally with `atoms.xcworkspace`.

## Fixed vertex counts

`Ngon<N, Point>` retains the vertex count in its public type while reusing Polygon
as its immutable backing representation. Construction rejects N below three and
arrays/polygons whose count differs from N. The representation uses Polygon's
array storage; a static count does not imply inline allocation or regularity.

```swift
import Polygon
let triangle = try Ngon<3, String>(vertices: ["a", "b", "c"])
let reversed: Ngon<3, String> = triangle.reversed
let boundary: Polygon<String> = triangle.polygon
```

Mapping and reversal preserve N. Decoding checks both Polygon validity and the
exact declared count, rejecting extra vertices as well as missing vertices.
Named quadrilateral/pentagon/hexagon domains need no additional packages: use
Ngon<4, Point>, Ngon<5, Point>, and Ngon<6, Point> respectively. Frame and dimension
identity remain in Point. Compiler-negative count/frame checks remain pending.
