/// A polygon boundary with a statically named, validated vertex count.
/// This does not imply regularity, convexity, planarity or distinct vertices.
public struct Ngon<let N: Int, Point> {
    public let polygon: Polygon<Point>

    public enum Error: Swift.Error, Equatable, Sendable {
        case invalidVertexCount
    }

    public init(vertices: [Point]) throws(Error) {
        guard N >= 3, vertices.count == N else { throw .invalidVertexCount }
        do {
            self.polygon = try Polygon(vertices: vertices)
        } catch { throw .invalidVertexCount }
    }

    public var vertices: [Point] { polygon.vertices }
    public var vertexCount: Int { N }

    public var reversed: Self { Self(validated: polygon.reversed) }

    public func map<Result, Failure: Swift.Error>(
        _ transform: (Point) throws(Failure) -> Result
    ) throws(Failure) -> Ngon<N, Result> {
        Ngon<N, Result>(validated: try polygon.map(transform))
    }
}

extension Ngon: Equatable where Point: Equatable {}
extension Ngon: Hashable where Point: Hashable {}
extension Ngon: Sendable where Point: Sendable {}

#if !hasFeature(Embedded)
extension Ngon: Encodable where Point: Encodable {
    public func encode(to encoder: any Encoder) throws {
        try polygon.encode(to: encoder)
    }
}
extension Ngon: Decodable where Point: Decodable {
    public init(from decoder: any Decoder) throws {
        let polygon = try Polygon<Point>(from: decoder)
        do { try self.init(polygon) }
        catch {
            throw DecodingError.dataCorrupted(.init(
                codingPath: decoder.codingPath,
                debugDescription: "Expected exactly \(N) vertices and at least three"
            ))
        }
    }
}
#endif

extension Ngon {
    public init(_ polygon: Polygon<Point>) throws(Error) {
        guard N >= 3, polygon.vertexCount == N else { throw .invalidVertexCount }
        self.polygon = polygon
    }

    private init(validated polygon: Polygon<Point>) { self.polygon = polygon }
}
