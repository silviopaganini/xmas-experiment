class Mou extends Backbone.View

    mou : null
    hat : null
    g : null
    xx : 0
    yy : 0

    getXXYY : =>
        @xx = $(window).innerWidth()
        @yy = $(window).innerHeight()
        null

    initialize : =>
        @getXXYY()

        @g = Snap()

        Snap.load "static/images/mou.svg", (f) =>
            @mou = f.select("#mou").attr({fill: "#000"})

            @g.add(@mou)
            x = @xx / 2 - @mou.getBBox().width / 2
            y = @yy / 2- @mou.getBBox().height / 2
            @mou.attr transform : "t" + [x, y]
        
    update : (music) =>
        #console.log music.time
        
        switch(true)
            when music.time >= 2 and music.time < 6.5
                @shakeMou()

            when music.time >= 7.8 and music.time < 13.5
                @shakeMou()

            else 
                @stopMou()

    scaleMo : =>
        return if @mou.inAnim().length > 0
        @mou.stop()
        x = (@xx - @mou.getBBox().width) / 2
        y = (@yy - @mou.getBBox().height) / 2

        to = "s" + [100, 100]
        setTimeout =>
            $('body').css 'background-color', '#000'
        , 400
        @mou.animate {transform : to}, 700


    stopMou : =>
        @mou.stop()
        x = (@xx - @mou.getBBox().width) / 2
        y = (@yy - @mou.getBBox().height) / 2

        to = "r" + [0, x + @mou.getBBox().width, y] + ", t" + [x, y]
        @mou.animate {transform : to}, 75

    shakeMou : =>
        x = (@xx - @mou.getBBox().width) / 2
        y = (@yy - @mou.getBBox().height) / 2

        return if @mou.inAnim().length > 0
        to = "r" + [10, x + @mou.getBBox().width, y] + ", t" + [x, y]
        @mou.animate {transform : to}, 75, null, =>
            to = "r" + [-10, x,y] + ", t" + [x, y]
            @mou.animate {transform : to}, 100, null

        return
