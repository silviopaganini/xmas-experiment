class Circles extends Backbone.View
    className : 'circles'
    circles : null
    animatedIn : false
    animatedOut : false

    initialize : =>
        colours = ['#27E7FF', '#33B32A', '#FF1100', '#FCFFFF', '#27E7FF', '#000']
        @circles = []
        
        for i in [0...colours.length] by 1
            circle = new Circle colours[i]
            @circles.push circle
            @$el.append circle.$el

    animateIn : =>
        @$el.css 'display', 'block'
        @animatedIn = true
        for i in [0...@circles.length]
            @circles[i].animateIn(500 + (i * 350))

        null

    animateOut : =>
        @$el.css 'z-index', '999'
        @animatedOut = true
        @circles = @circles.reverse()
        for i in [0...@circles.length]
            @circles[i].animateOut(500 + (i * 350))

        null