module HW02_4451

using Reexport, Revise

@reexport using Asap, LinearAlgebra, GLMakie

include("Geometry.jl")
export Pt
export Bar
export Ray
export ray_intersect
export rotate_ray
export rotate_ray!
export rotate_ray_degrees
export rotate_ray_degrees!

include("Analysis.jl")
export analyze_cantilever_truss

include("Visualization.jl")
export plot_structure
export plot_truss

include("make_michell_truss.jl")
export make_michell_truss

end # module HW02_4451