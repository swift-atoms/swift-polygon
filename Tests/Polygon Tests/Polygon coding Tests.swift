import Foundation
import Polygon
import Testing

@Suite
struct `Polygon coding` {
    @Test
    func `Coding retains order repetitions and implicit closure`() throws {
        let polygon = Polygon(1, 2, 3, 1)
        let data = try JSONEncoder().encode(polygon)
        #expect(try JSONDecoder().decode([Int].self, from: data) == [1, 2, 3, 1])
        #expect(try JSONDecoder().decode(Polygon<Int>.self, from: data) == polygon)
    }

    @Test(arguments: ["[]", "[1]", "[1,2]", "null", "[1,2,null]"])
    func `Decoding cannot bypass minimum cardinality or point decoding`(_ json: String) {
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(Polygon<Int>.self, from: Data(json.utf8))
        }
    }

    @Test
    func `Encoding and decoding conformances are independent`() throws {
        struct Output: Encodable { let value: Int }
        struct Input: Decodable { let value: Int }
        let data = try JSONEncoder().encode(Polygon(Output(value: 1), Output(value: 2), Output(value: 3)))
        let polygon = try JSONDecoder().decode(Polygon<Input>.self, from: data)
        #expect(polygon.vertices.map(\.value) == [1, 2, 3])
    }
}
