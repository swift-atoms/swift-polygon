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
