#make points
p1 = Pt(0, 5)
p2 = Pt(0, -5)
p3 = Pt(4., 2.25)

#make bars
b1 = Bar(p1, p3)
b2 = Bar(p2, p3)

#make a structural model and analyze it
model, fl = analyze_cantilever_truss([p1, p2, p3], [b1, b2])

#visualize
plot_truss(model)