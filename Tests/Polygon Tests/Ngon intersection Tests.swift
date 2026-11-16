import Point
import Polygon
import Ray
import Testing
import Vector

enum `Ngon intersection Tests` {}

extension `Ngon intersection Tests` {
    @Suite
    struct `A ray crosses a triangle where its weights put the point` {
        static let triangle = Ngon<3, Point<3, Double>>(Point(x: 0, y: 0, z: 0), Point(x: 4, y: 0, z: 0), Point(x: 0, y: 4, z: 0))

        static func ray(_ origin: Point<3, Double>, _ direction: Vector<3, Double>) throws -> Ray<Point<3, Double>, Vector<3, Double>> {
            try Ray(origin: origin, direction: direction)
        }

        @Test
        func `The crossing is the origin plus the parameter times the direction, and the weighted vertices`() throws {
            let crossing = try #require(Self.triangle.intersection(with: Self.ray(Point(x: 1, y: 2, z: 5), Vector([0, 0, -2]))))
            #expect(crossing.parameter == 2.5)
            #expect(crossing.weights == Vector([0.25, 0.25, 0.5]))
            let corners = Self.triangle.vertices
            let weighted = (0..<3).map { corners[$0].coordinates.scaled(by: crossing.weights[$0]) }.reduce(.zero, +)
            #expect(weighted == Vector([1, 2, 0]))
        }

        @Test
        func `Three vertices make the triangle they name, in order`() {
            #expect(Self.triangle.vertices == [Point(x: 0, y: 0, z: 0), Point(x: 4, y: 0, z: 0), Point(x: 0, y: 4, z: 0)])
        }

        @Test
        func `Either side is crossed, and a ray parallel, outside or pointing away crosses nothing`() throws {
            #expect(Self.triangle.intersection(with: try Self.ray(Point(x: 1, y: 1, z: -3), Vector([0, 0, 1])))?.parameter == 3)
            #expect(Self.triangle.intersection(with: try Self.ray(Point(x: 1, y: 1, z: 1), Vector([1, 0, 0]))) == nil)
            #expect(Self.triangle.intersection(with: try Self.ray(Point(x: 3, y: 3, z: 1), Vector([0, 0, -1]))) == nil)
            #expect(Self.triangle.intersection(with: try Self.ray(Point(x: 1, y: 1, z: 1), Vector([0, 0, 1]))) == nil)
        }
    }
}
