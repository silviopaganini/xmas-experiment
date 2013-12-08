class Particle
    
    x      : 0
    y      : 0
    r      : 0
    dx     : 0
    dy     : 0
    canvas : null
    w      : 0
    h      : 0

    constructor : (args) ->
        @dx     = args._dx
        @dy     = args._dy
        @x      = args._x
        @y      = args._y
        @r      = args._r
        @canvas = args._canvas
        @w      = args._w
        @h      = args._h
    
    draw :=>
        @canvas.beginPath()
        @canvas.fillStyle = '#FFF'
        @canvas.arc(@x, @y, @r, 0, Math.PI * 2, true)
        @canvas.closePath()
        @canvas.fill()

    rand : (low = 0, high = 1) =>
        return (((Math.random() * (high - low)) + low) % high)

    move : =>
        @x += @dx
        @y += @dy

        #### RESET PARTICLE

        if !(@x < @w and @x > -10)
            @x = -5
            @dx = @rand(-0.8, .8)


        if @y > @h
            @y = 0
            @dy = @rand(0.1, .5)
