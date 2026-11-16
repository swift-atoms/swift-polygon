public import Point
public import Ray
public import Vector

extension Ngon where N == 3 {
    /// The triangle with these three vertices in order. Three vertices are always a triangle, so nothing is checked.
    public init(_ first: Point, _ second: Point, _ third: Point) {
        self.init(validated: Polygon(first, second, third))
    }

    /// Where a ray crosses this triangle in space, by Möller and Trumbore: the ray's parameter t, so the crossing
    /// lies at the origin plus t times the direction, and the crossing's barycentric weights of the three
    /// vertices in order, which are not negative and add up to one. A ray parallel to the triangle's plane
    /// (the test is exact, with no tolerance), one that passes outside it and one that would have to run
    /// backwards (t below zero) cross nothing. Either side of the triangle is crossed.
    @inlinable
    public func intersection<Scalar: BinaryFloatingPoint>(
        with ray: Ray<Point, Vector<3, Scalar>>
    ) -> (parameter: Scalar, weights: Vector<3, Scalar>)? where Point == Point::Point<3, Scalar> {
        let corners = vertices
        let origin = corners[0].coordinates
        let first = corners[1].coordinates - origin
        let second = corners[2].coordinates - origin
        let p = ray.direction.cross(second)
        let determinant = first.dot(p)
        guard determinant != 0 else { return nil }
        let inverse = 1 / determinant
        let offset = ray.origin.coordinates - origin
        let u = offset.dot(p) * inverse
        guard u >= 0, u <= 1 else { return nil }
        let q = offset.cross(first)
        let v = ray.direction.dot(q) * inverse
        guard v >= 0, u + v <= 1 else { return nil }
        let parameter = second.dot(q) * inverse
        guard parameter >= 0 else { return nil }
        return (parameter, Vector([1 - u - v, u, v]))
    }
}
