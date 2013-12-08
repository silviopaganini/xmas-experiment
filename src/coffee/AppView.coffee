class AppView extends Backbone.View

    music   : null
    mou     : null
    grito   : null
    circles : null
    bye     : null

    initialize : =>
        @setElement $('body')
        window.addStats()

        @bye = new PlayAgain

        @music = new Music
        @music.on 'loaded', @onAudioLoaded

        @mou = new Mou

        @circles = new Circles
        @$el.append @circles.$el

        @viz = new Viz
        @$el.append @viz.$el

        null

    onAudioLoaded : =>
        @music.play()
        @animate()
        null

    animate : =>

        u = @music.update()

        @mou?.update u

        if(u.time > 11.5 and !@circles.animatedIn)
            @circles.animateIn()

        if(u.time > 13.6 and u.time < 62)
            @viz.$el.css 'display', 'block'
            @viz.update(u)

        if(u.time >= 47 and u.time <= 52)
            if(!@viz.isGrito)
                @viz.setupGrito()
            @viz.isGrito = true

        if (u.time >= 52)
            if(@viz.isGrito)
                @viz.setupViz()
            @viz.isGrito = false

        if(u.time > 57)
            if(!@circles.animatedOut)
                @circles.animateOut()
                $('svg').remove()
                @$el.append @bye.$el
                @viz.$el.remove()
            else 
                @bye.update()
       
        window.stats.update()
        requestAnimationFrame @animate 
        null