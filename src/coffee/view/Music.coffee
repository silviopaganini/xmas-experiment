class Music extends Backbone.View

    context      : null
    bufferLoader : null
    analyser     : null
    url          : '/static/sound/track.mp3'
    source : null

    initialize : =>
        @context = new AudioContext()
        @analyser = @context.createAnalyser()
        @analyser.fftSize = 1024
        @bufferLoader = new BufferLoader @context, [ @url ], @finishedLoading
        @bufferLoader.load()

    finishedLoading : (bufferList) =>
        @source = @context.createBufferSource()
        @source.buffer = bufferList[0]
        @source.connect(@analyser)
        @analyser.connect(@context.destination)
        @trigger 'loaded'
        null

    play : =>
        @source.start(0)

    update : =>
        return if !@analyser or !@analyser.context

        freqByteData = new Uint8Array(@analyser.frequencyBinCount)
        @analyser.getByteFrequencyData(freqByteData)
        return time: @context.currentTime, freq: freqByteData