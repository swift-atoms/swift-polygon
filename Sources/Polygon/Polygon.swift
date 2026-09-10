@_exported public import Segment

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

    public func edge(at index: Int) -> Segment<Point> {
        precondition(vertices.indices.contains(index), "Polygon vertex index out of bounds")
        let next = index == vertices.count - 1 ? 0 : index + 1
        return Segment(from: vertices[index], to: vertices[next])
    }

    public var edges: [Segment<Point>] { vertices.indices.map { edge(at: $0) } }

    public var reversed: Self {
        Self(validated: [vertices[0]] + vertices.dropFirst().reversed())
    }

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

    public init(_ first: Point, _ second: Point, _ third: Point, _ remaining: Point...) {
        self.vertices = [first, second, third] + remaining
    }

    private init(validated vertices: [Point]) { self.vertices = vertices }
}
