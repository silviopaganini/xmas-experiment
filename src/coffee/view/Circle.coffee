class Circle extends Backbone.View

    className : 'circle'

    constructor : (@colour = 'black') ->
        super()
        @reset()
        null

    reset : =>
        @$el.removeClass()
        s = Math.max($(window).innerWidth(), $(window).innerHeight()) * 1.5
        @$el.css
            width : s
            height : s
            backgroundColor : @colour
            left : ($(window).innerWidth() - s) / 2
            top : ($(window).innerHeight() - s) / 2

    animateIn : (delay) =>
        @reset()
        @$el.addClass('circle0')
        
        setTimeout => 
            @$el.addClass('animateCircle')
            @$el.css {transform : 'scale(1)'}
        , delay
        

    animateOut : (delay) =>
        @reset()
        @$el.addClass('circle1')

        setTimeout => 
            @$el.addClass('animateCircle')
            @$el.css {transform : 'scale(0)'}
        , delay