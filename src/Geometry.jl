"""
    Pt

Contains a 2-dimension point, pt::Pt, with fields pt.x and pt.y.
"""
mutable struct Pt
    x
    y

    function Pt(position::Vector)
        @assert length(position) == 2 "position should be a length 2 ray, e.g. [3, 2.3]"
        return new(position...)
    end

    function Pt(x, y)
        return new(x, y)
    end
end

import Base: -
-(point1::Pt, point2::Pt) = [point1.x - point2.x, point1.y - point2.y]

"""
    Bar

A bar::Bar that starts at `bar.pstart` and ends and `bar.pend`.
"""
mutable struct Bar
    pstart
    pend

    function Bar(pstart::Pt, pend::Pt)
        return new(pstart, pend)
    end
end

"""
    Ray

Contains a ray::Ray that starts from ray.start along direction ray.direction.
"""
mutable struct Ray
    start::Pt
    direction
    length

    function Ray(p::Pt, direction::Vector)
        @assert length(direction) == 2 "direction should be a length 2 ray, e.g. [1.2, 5]"

        return new(p, normalize(direction), norm(direction))
    end
end

"""
    ray_intersect(vec1::Ray, vec2::Ray)

Find the intersection point between two rays. If there is no intersection, this function will return `nothing`.
"""
function ray_intersect(vec1::Ray, vec2::Ray)
    left = [vec1.direction vec2.direction]
    right = vec2.start - vec1.start

    if det(left) == 0
        return nothing
    end

    t = left \ right
    intersect = [vec1.start.x, vec1.start.y] + t[1] .* vec1.direction

    return Pt(intersect)
end

"""
    rotate_ray(vec::Ray, angle)

Rotate a ray counterclockwise by `angle` (RADIANS) and return a new ray
"""
function rotate_ray(vec::Ray, angle)
    x = cos(angle)
    y = sin(angle)

    return Ray(vec.start, [x -y; y x] * vec.direction)
end

function rotate_ray_degrees(vec::Ray, angle)
    return rotate_ray(vec, deg2rad(angle))
end

"""
    rotate_ray!(vec::Ray, angle)

Rotate a ray counterclockwise by `angle` (RADIANS) and update the existing ray
"""
function rotate_ray!(vec::Ray, angle)
    x = cos(angle)
    y = sin(angle)

    vec.direction = [x -y; y x] * vec.direction
end

function rotate_ray_degrees!(vec::Ray, angle)
    rotate_ray!(vec, deg2rad(angle))
end

function find_topology(points::Vector{Pt}, bars::Vector{Bar})

    #extract the positions of all points in a [n_points × 2] matrix
    xy_points = [getproperty.(points, :x) getproperty.(points, :y)]

    #extract the positions of all bar starting positions in a [n_bars × 2] matrix
    xy_bar_starts = [[bar.pstart.x for bar in bars] [bar.pstart.y for bar in bars]]

    #extract the position of all bar ending positions in a [n_bars × 2] matrix
    xy_bar_ends = [[bar.pend.x for bar in bars] [bar.pend.y for bar in bars]]


    #find the distance matrix between each point and each bar starting point
    distance_matrix_start = [norm(xy1 - xy2) for xy1 in eachrow(xy_points), xy2 in eachrow(xy_bar_starts)]

    #the starting index is the smallest value in each column
    i_start = argmin.(eachcol(distance_matrix_start))

    #do the same for the ending point
    distance_matrix_end = [norm(xy1 - xy2) for xy1 in eachrow(xy_points), xy2 in eachrow(xy_bar_ends)]
    i_end = argmin.(eachcol(distance_matrix_end))
    
    return i_start, i_end

end