import Polygon
import Testing

@Suite
struct `Polygon contracts` {
    @Test(arguments: [[], [1], [1, 2]])
    func `Fewer than three vertices are rejected with the owned error`(_ vertices: [Int]) {
        do {
            _ = try Polygon(vertices: vertices)
            Issue.record("Expected insufficient vertices to fail")
        } catch {
            let failure: Polygon<Int>.Error = error
            #expect(failure == .insufficientVertices)
        }
    }

    @Test
    func `Natural construction preserves vertices and implicit closure`() {
        let polygon = Polygon("a", "b", "c", "d")
        #expect(polygon.vertexCount == 4)
        #expect(polygon.edges == [
            Segment(from: "a", to: "b"), Segment(from: "b", to: "c"),
            Segment(from: "c", to: "d"), Segment(from: "d", to: "a"),
        ])
        #expect(polygon.edge(at: 3) == Segment(from: "d", to: "a"))
    }

    @Test
    func `Repeated vertices are not silently removed or declared nondegenerate`() throws {
        let collapsed = Polygon(1, 1, 1)
        #expect(collapsed.edges.count == 3)
        #expect(collapsed.edges.allSatisfy { $0.start == $0.end })
        let explicitClosure = try Polygon(vertices: [1, 2, 3, 1])
        #expect(explicitClosure.vertexCount == 4)
        #expect(explicitClosure.edge(at: 3) == Segment(from: 1, to: 1))
    }

    @Test
    func `Reversal preserves the first vertex and reverses every edge`() {
        let polygon = Polygon(1, 2, 3, 4)
        #expect(polygon.reversed.vertices == [1, 4, 3, 2])
        #expect(polygon.reversed.edges == polygon.edges.reversed().map(\.reversed))
        #expect(polygon.reversed.reversed == polygon)
    }

    @Test
    func `Equality does not identify cyclic shifts or reversal`() {
        let polygon = Polygon(1, 2, 3)
        let shifted = Polygon(2, 3, 1)
        #expect(polygon != shifted)
        #expect(polygon != polygon.reversed)
        #expect(Set([polygon, polygon, shifted, polygon.reversed]).count == 3)
    }

    @Test
    func `Input array mutation cannot break the vertex count invariant`() throws {
        var vertices = [1, 2, 3]
        let polygon = try Polygon(vertices: vertices)
        vertices.removeAll()
        #expect(polygon.vertices == [1, 2, 3])
        func requireSendable<T: Sendable>(_ value: T) {}
        requireSendable(polygon)
    }

    @Test
    func `Edges impose no equality ordering or arithmetic on points`() {
        struct Token { let id: Int }
        let polygon = Polygon(Token(id: 1), Token(id: 2), Token(id: 3))
        #expect(polygon.edges[2].start.id == 3)
        #expect(polygon.edges[2].end.id == 1)
    }

    @Test
    func `Mapping preserves count and traversal but may collapse vertices`() {
        let polygon = Polygon(1, 2, 3)
        #expect(polygon.map(String.init).vertices == ["1", "2", "3"])
        #expect(polygon.map { _ in 0 } == Polygon(0, 0, 0))
    }

    @Test
    func `Mapping stops in traversal order and propagates the typed failure`() {
        enum Failure: Error { case rejected }
        var visited: [Int] = []
        do {
            _ = try Polygon(1, 2, 3).map { (vertex: Int) throws(Failure) -> Int in
                visited.append(vertex)
                if vertex == 2 { throw .rejected }
                return vertex
            }
            Issue.record("Expected mapping to fail")
        } catch {
            let failure: Failure = error
            #expect(failure == .rejected)
        }
        #expect(visited == [1, 2])
    }
}
