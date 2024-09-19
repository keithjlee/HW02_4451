using HW02_4451

#=
This file acts as an example on how to use the pre-defined functions in this module.

If you are in VS Code, press shift+enter to run line of code and move to the next one
=#

#=
Points (Pt)
=#

#make a point by specifying an x and y value
point1 = Pt(2, 5.75)
point2 = Pt(0, 1.)

#you can pull out the x and y components of a point by accessing the `x` and `y` fields
x1 = point1.x #x position of point 1
y2 = point2.y #y position of point 2

#=
Bars (Bar)
=#

#make a bar that connects two points together
bar1 = Bar(point1, point2)

#extract the end points by accessing the `pstart` and `pend` fields
starting_point1 = bar1.pstart

#you can nest the access of information
y1 = bar1.pstart.y #y position of point 1

#=
Rays (Ray)
=#

#make a ray, which is a vector that starts at a point and shoots out in a certain direction
ray_direction = [-3, 10]
ray1 = Ray(point1, ray_direction)

#you can directly input the direction vector
ray2 = Ray(point2, [2, -5])

#=
Find the point that defines the intersection between two rays using ray_intersect. 
This assumes that the ray shoots out infinitely from their respective starting points.

If an intersection doesn't exist (i.e., your rays are parallel), it will return nothing
=#
p_intersection = ray_intersect(ray1, ray2)

#=
You might want to change the ray direction.
Simply redefine the `.direction` field of your ray object
=#
ray1.direction = [0.5, 0.5]

#=
You can rotate the direction of a ray as well using `rotate_ray(ray, angle_in_radians)` or `rotate_ray_degrees(ray, angle_in_degrees)`.

This outputs a new ray with the rotated angle
=#
ray2_rotated = rotate_ray(ray2, pi/2)

#=
or simply update the direction of an existing ray using rotate_ray!(ray, angle_in_radians) or rotate_ray_degrees!(ray, angle_in_degrees)
=#

#let's update ray1 directly
rotate_ray_degrees!(ray1, 60.)

#=
Visualization
=#

#we've defined a convenient visualization function, `plot_structure()` to visualize a collection of points, bars, and rays

#=
plot_structure(points::Vector{Pt}) plots a vector of points
=#

points = [Pt(rand(2)) for _ = 1:10]
plot_structure(points)

#=
plot_structure(points::Vector{Pt}, bars::Vector{Bar}) plots a collection of points and bars
=#

bars = [Bar(rand(points), rand(points)) for _ = 1:5]
plot_structure(points, bars)

#=
plot_structure(points::Vector{Pt}, bars::Vector{Bar}, rays::Vector{Ray}) plots a collection of points, bars, and rays
=#

rays = [Ray(rand(points), rand(2)) for _ = 1:3]
plot_structure(points, bars, rays)