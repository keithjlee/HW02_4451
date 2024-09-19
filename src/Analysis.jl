#=
This file uses Asap.jl to analyze a collection of points and bars
=#

"""
    analyze_cantilever_truss(points::Vector{Pt}, bars::Vector{Bar}; E = 29e3, A = 16.0, P = 1.0)

Analyzes a Michell truss. It assumes that the two nodes on the left are pin supported, and a load of P is applied to the node on the furthest right node.
"""
function analyze_cantilever_truss(points::Vector{Pt}, bars::Vector{Bar}; E = 29e3, A = 16.0, P = 1.0)

    #make a cross section
    section = TrussSection(A, E)

    # extract x and y positions
    x_positions = Float64.(getproperty.(points, :x))
    y_positions = Float64.(getproperty.(points, :y))

    #find the ordered indices of x_positions
    i_sorted_x = sortperm(x_positions)

    #two values with smallest x position are the supports
    i_supports = i_sorted_x[1:2]

    #value with largest x is the load point
    i_load = last(i_sorted_x)

    #=
    Make nodes. Truss nodes are created by TrussNode(position, degrees_of_freedom)

    Using [true, true, false] means that the x and y positions are able to move freely under load, but the z position is fixed (since we are only working in 2D)
    =#
    nodes = [TrussNode([x, y, 0], [true, true, false]) for (x,y) in zip(x_positions, y_positions)]

    #update the two support nodes
    for i in i_supports
        nodes[i].dof = [false, false, false]
    end

    #=
    Make elements. Truss elements are created by TrussElement(nodestart, nodeend, cross_section)
    =#

    #get the starting and ending indices for each bar
    istart, iend = find_topology(points, bars)

    #make elements
    elements = [TrussElement(nodes[i1], nodes[i2], section) for (i1, i2) in zip(istart, iend)]

    #=
    Define a load
    =#
    load = [NodeForce(nodes[i_load], [0.0, -P, 0.0])]

    #assemble model
    model = TrussModel(nodes, elements, load)

    #solve
    solve!(model)

    #get the axial forces
    axial_forces = axial_force.(model.elements)

    #get the element lengths
    element_lengths = getproperty.(model.elements, :length)

    #find ∑|FL|
    FL = dot(abs.(axial_forces), element_lengths)

    #return the model and our objective
    return model, FL
end