#if !hasFeature(Embedded)
extension Polygon: Encodable where Point: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(vertices)
    }
}

extension Polygon: Decodable where Point: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let vertices = try container.decode([Point].self)
        do {
            try self.init(vertices: vertices)
        } catch {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "A polygon requires at least three vertices"
            )
        }
    }
}
#endif
