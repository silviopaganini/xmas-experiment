class ParticlesCanvas extends Backbone.View
    
    ctx       : null
    canvas    : null
    particles : null
    tagName : 'div'
    className : 'particles'
    
    initialize : =>
        @canvas = document.createElement 'canvas'
        @$el.append @canvas
        @canvas.width = window.innerWidth
        @canvas.height = window.innerHeight

        @ctx = @canvas.getContext('2d')

        @start()

        
    start : =>
        @particles = []
        @batchParticles()
        ###for i in [0...3]
            setTimeout @batchParticles, 10000 * i###
        
    
    batchParticles : =>
        for i in [0..1000]
            p = new Particle 
                _x      : @rand(0, @canvas.width)
                _y      : @rand(0, -250)
                _r      : @rand(0.2, 2)
                _canvas : @ctx
                _w      : @canvas.width
                _h      : @canvas.height
                _dx     : @rand(-.3, .3)
                _dy     : @rand(0.1, .5)

            @particles.push(p)

    rand : (low = 0, high = 1) ->
        return (((Math.random() * (high - low)) + low) % high)

    update :=>
        @clear()
        for p in @particles
            p.move()
            p.draw()

    clear :=>
        @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
        null