import Polygon
import Testing
import Foundation

@Suite struct `Fixed count polygon contracts` {
    @Test func `Declared count is preserved by mapping and reversal`() throws {
        let triangle = try Ngon<3, Int>(vertices: [1, 2, 3])
        let mapped: Ngon<3, String> = triangle.map(String.init)
        #expect(mapped.vertices == ["1", "2", "3"])
        #expect(triangle.reversed.vertices == [1, 3, 2])
        #expect(triangle.reversed.reversed == triangle)
        #expect(triangle.vertexCount == 3)
        #expect(triangle.polygon.edges.last == Segment(from: 3, to: 1))
    }

    @Test(arguments: [[], [1], [1, 2], [1, 2, 3, 4]])
    func `Construction rejects mismatched counts`(_ vertices: [Int]) {
        #expect(throws: Ngon<3, Int>.Error.invalidVertexCount) {
            try Ngon<3, Int>(vertices: vertices)
        }
    }

    @Test func `Counts below three cannot instantiate a polygon`() {
        #expect(throws: Ngon<0, Int>.Error.invalidVertexCount) { try Ngon<0, Int>(vertices: []) }
        #expect(throws: Ngon<2, Int>.Error.invalidVertexCount) { try Ngon<2, Int>(vertices: [1, 2]) }
    }

    @Test func `Conversion retains the original polygon representation`() throws {
        let polygon = Polygon(1, 1, 2, 3)
        let quadrilateral = try Ngon<4, Int>(polygon)
        #expect(quadrilateral.polygon == polygon)
        #expect(Set([quadrilateral, quadrilateral]).count == 1)
        #expect(throws: Ngon<3, Int>.Error.invalidVertexCount) { try Ngon<3, Int>(polygon) }
    }

    @Test func `Mapping preserves the supplied typed failure`() throws {
        enum Failure: Error { case rejected }
        let triangle = try Ngon<3, Int>(vertices: [1, 2, 3])
        func transform(_ value: Int) throws(Failure) -> String { throw .rejected }
        #expect(throws: Failure.rejected) { try triangle.map(transform) }
    }

    @Test func `Decoding rejects too few and too many vertices`() throws {
        let triangle = try Ngon<3, Int>(vertices: [1, 2, 3])
        #expect(try JSONDecoder().decode(Ngon<3, Int>.self, from: JSONEncoder().encode(triangle)) == triangle)
        for json in ["[]", "[1,2]", "[1,2,3,4]"] {
            #expect(throws: DecodingError.self) {
                try JSONDecoder().decode(Ngon<3, Int>.self, from: Data(json.utf8))
            }
        }
    }
}
