class PlayAgain extends Backbone.View

    particles : null
    tagName : 'section'

    initialize : =>
        tags = '<div class="container">'
        tags += '<div class="content">'
        tags += '<h1>Merry Christmas</h1>'
        tags += '<button onclick="window.location.reload();">Watch Again?</button>'
        tags += '<h3>by <a href="http://twitter.com/silviopaganini" target="_blank">@silviopaganini</a></h3>'
        tags += '</div>'
        tags += '</div>'

        @$el.html tags
        @$el.attr 'id', 'bye'

        @particles = new ParticlesCanvas
        @$el.prepend @particles.$el

    refresh: =>


    update: =>
        @particles.update()
        null