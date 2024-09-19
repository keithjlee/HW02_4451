function plot_structure(points::Vector{Pt})

    nodes = Point2.(getproperty.(points, :x), getproperty.(points, :y))

    fig = Figure()
    ax = Axis(
        fig[1,1],
        aspect = DataAspect(),
        xgridvisible = false,
        ygridvisible = false
    )

    hidespines!(ax)

    scatter!(
        nodes,
        color = :black
    )

    return fig

end

function plot_structure(points::Vector{Pt}, bars::Vector{Bar})

    nodes = Point2.(getproperty.(points, :x), getproperty.(points, :y))

    elements = vcat([[Point2(bar.pstart.x, bar.pstart.y), Point2(bar.pend.x, bar.pend.y)] for bar in bars]...)

    fig = Figure()
    ax = Axis(
        fig[1,1],
        aspect = DataAspect(),
        xgridvisible = false,
        ygridvisible = false
    )

    hidespines!(ax)

    linesegments!(
        elements,
        color = :black
    )

    scatter!(
        nodes,
        color = :black
    )

    return fig

end

function plot_structure(points::Vector{Pt}, bars::Vector{Bar}, rays::Vector{Ray})

    nodes = Point2.(getproperty.(points, :x), getproperty.(points, :y))

    elements = vcat([[Point2(bar.pstart.x, bar.pstart.y), Point2(bar.pend.x, bar.pend.y)] for bar in bars]...)

    ray_starts = [Point2(ray.start.x, ray.start.y) for ray in rays]
    ray_vectors = [Vec2(ray.direction) for ray in rays]

    fig = Figure()
    ax = Axis(
        fig[1,1],
        aspect = DataAspect(),
        xgridvisible = false,
        ygridvisible = false
    )

    hidespines!(ax)

    linesegments!(
        elements,
        color = :black
    )

    arrows!(
        ray_starts, ray_vectors,
        color = :gray
    )

    scatter!(
        nodes,
        color = :black
    )

    return fig

end

function plot_truss(model::TrussModel)

    nodes = Point2.(getproperty.(model.nodes, :position))
    indices = vcat(Asap.nodeids.(model.elements)...)
    elements = nodes[indices]
    element_forces = axial_force.(model.elements)

    maximum_force = maximum(abs.(element_forces))

    fig = Figure()
    ax = Axis(
        fig[1,1],
        aspect = DataAspect(),
        xgridvisible = false,
        ygridvisible = false
    )

    hidespines!(ax)

    linesegments!(
        elements,
        color = element_forces,
        colormap = [:red, :white, :blue],
        colorrange = (-1, 1) .* maximum_force
    )

    scatter!(
        nodes, 
        color = :black
    )

    fig

end