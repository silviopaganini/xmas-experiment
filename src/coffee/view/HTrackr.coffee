class HTrackr extends Backbone.View

    htracker : null
    first  : true

    initialize : => 
        videoInput = document.createElement('video')
        canvasInput = document.createElement('canvas')

        htracker = new headtrackr.Tracker
        htracker.init(videoInput, canvasInput) 
        htracker.start() 

        document.addEventListener 'headtrackingEvent', (event) =>
            @trigger 'headTracked' if @first
            @first = false
            x = $(window).innerWidth() / 2 + event.x * 20
            y = $(window).innerHeight() / 2 - event.y * 20
            z = Math.abs(1000 - event.z * 10)
            $('#mask').css
                background: "-webkit-gradient(radial, #{x} #{y}, 0, #{x} #{y}, #{z}, from(rgba(0,0,0,.5)), to(rgba(0,0,0,1)))"

