@_exported public import Segment

/// An ordered, implicitly closed polygonal boundary with at least three vertices.
///
/// This is a combinatorial representation, not a proof of simplicity, planarity,
/// nondegeneracy, convexity, or a filled region. Repeated vertices are permitted.
/// The point type carries dimensionality and any frame/unit identity.
public struct Polygon<Point> {
    public let vertices: [Point]

    public enum Error: Swift.Error, Equatable, Sendable {
        case insufficientVertices
    }

    public init(vertices: [Point]) throws(Error) {
        guard vertices.count >= 3 else { throw .insufficientVertices }
        self.vertices = vertices
    }

    public var vertexCount: Int { vertices.count }

    /// The edge beginning at the given vertex index, including the closing edge.
    public func edge(at index: Int) -> Segment<Point> {
        precondition(vertices.indices.contains(index), "Polygon vertex index out of bounds")
        let next = index == vertices.count - 1 ? 0 : index + 1
        return Segment(from: vertices[index], to: vertices[next])
    }

    public var edges: [Segment<Point>] { vertices.indices.map { edge(at: $0) } }

    /// Reverse traversal while preserving the chosen first vertex.
    public var reversed: Self {
        Self(validated: [vertices[0]] + vertices.dropFirst().reversed())
    }

    /// Transform vertices in traversal order, retaining closure and vertex count.
    public func map<Result, Failure: Swift.Error>(
        _ transform: (Point) throws(Failure) -> Result
    ) throws(Failure) -> Polygon<Result> {
        var result: [Result] = []
        result.reserveCapacity(vertices.count)
        for vertex in vertices { result.append(try transform(vertex)) }
        return Polygon<Result>(validated: result)
    }
}

extension Polygon: Equatable where Point: Equatable {}
extension Polygon: Hashable where Point: Hashable {}
extension Polygon: Sendable where Point: Sendable {}

extension Polygon {
    /// The required first three arguments establish the vertex-count invariant.
    public init(_ first: Point, _ second: Point, _ third: Point, _ remaining: Point...) {
        self.vertices = [first, second, third] + remaining
    }

    // Only operations preserving at least three vertices may use this initializer.
    private init(validated vertices: [Point]) { self.vertices = vertices }
}
