import Polygon
import Point
import Tagged
import Testing

@Suite
struct `Polygon point call sites` {
    @Test
    func `Natural point construction is independent of dimension`() {
        let triangle = Polygon(Point(x: 0, y: 0), Point(x: 4, y: 0), Point(x: 0, y: 3))
        #expect(triangle.edges[0].end.coordinates == Vector(x: 4, y: 0))
        let spatial = Polygon(
            Point(x: 0, y: 0, z: 0), Point(x: 1, y: 0, z: 0),
            Point(x: 0, y: 1, z: 0), Point(x: 0, y: 0, z: 1)
        )
        #expect(spatial.vertexCount == 4) // No unearned planarity guarantee.
    }

    private enum World {}

    @Test
    func `Edges and reversal preserve the tagged point domain`() {
        typealias Position = Tagged<World, Point<2, Int>>
        let a = Position(_unchecked: Point(x: 0, y: 0))
        let b = Position(_unchecked: Point(x: 1, y: 0))
        let c = Position(_unchecked: Point(x: 0, y: 1))
        let polygon = Polygon(a, b, c)
        let edge: Segment<Position> = polygon.edge(at: 2)
        let reversed: Polygon<Position> = polygon.reversed
        #expect(edge.end == a)
        #expect(reversed.vertices == [a, c, b])
    }
}
