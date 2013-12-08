class Viz extends Backbone.View

    className   : 'canvasContainer'
    
    scene       : null
    camera      : null
    
    particles   : 1000
    mouseX      : 0
    mouseY      : 0
    p           : null
    
    shaderTime  : 0
    
    object      : null
    
    secs        : null
    drums       : null
    drama       : null
    picked      : null
    pickedDrums : null
    pickedDrama : null
    colours     : null

    composer      : null
    shaderTime    : 0
    badTVParams   : null
    badTVPass     : null
    staticParams  : null
    staticPass    : null

    rgbParams     : null
    rgbPass       : null
    
    filmParams    : null
    filmPass      : null
    
    renderPass    : null
    copyPass      : null
    
    pnoise        : null
    globalParams  : null

    videoTexture  : null
    videoMaterial : null

    isGrito : false

    initialize : =>

        @picked = @pickedDrama = @pickedDrums = []
        #@secs = [12.985, 13.503, 14.515, 15.012, 15.995, 16.535, 17.608, 18.149, 19.134, 19.823, 20.659, 21.235, 22.231, 22.819, 23.747, 24.363, 25.303, 25.900, 26.850, 27.386, 28.422, 29.019, 29.938, 30.516, 31.510, 32.083, 33.056, 33.602, 34.605, 35.214, 36.189, 36.706, 37.731, 38.379, 39.256, 39.902, 40.865, 41.464, 42.437, 43.029, 43.979, 44.609, 45.553, 46.090, 52.515, 53.074, 53.948, 54.496, 55.473]
        #@secs = [13.096, 13.679, 14.582, 15.095, 16.152, 16.679, 17.687, 18.242, 19.240, 19.848, 20.828, 21.344, 22.403, 22.888, 23.889, 24.490, 25.472, 26.039, 27.000, 27.548, 28.481, 29.095, 30.119, 30.632, 31.626, 32.175, 33.175, 33.699, 34.743, 35.318, 36.283, 36.829, 37.863, 38.449, 39.351, 39.945, 40.918, 41.501, 42.488, 43.136, 44.097, 44.624, 45.629, 46.200, 47.264, 47.928, 48.887, 49.496, 50.455, 51.149, 52.024, 52.935, 54.007, 54.643, 55.684]

        @drums = [12.998, 13.537, 14.479, 14.990, 15.984, 16.560, 17.591, 18.106, 19.060, 19.655, 20.682, 21.208, 22.209, 22.799, 23.846, 24.392, 25.355, 25.920, 26.807, 27.383, 28.360, 28.941, 30.025, 30.550, 31.595, 32.131, 33.118, 33.608, 34.606, 35.182, 36.234, 36.735, 37.750, 38.375, 39.294, 39.873, 40.799, 41.366, 42.366, 42.887, 43.968, 44.540, 45.578, 46.123, 52.068, 52.906, 53.960, 54.506, 55.567]
        @secs = [13.008, 15.812, 18.780, 21.977, 24.875, 28.319, 31.437, 34.430, 37.717, 40.506, 43.453, 46.436]
        @drama = [37.869, 38.203, 38.593, 38.960, 39.318, 39.740, 40.114, 40.876, 41.270, 41.663, 42.083, 42.471, 42.854, 43.235, 43.983, 44.394, 44.802, 45.176, 45.575, 45.966, 46.390]

        @secs[i] = @secs[i].toFixed(1) for i in [0...@secs.length] by 1
        @drums[i] = @drums[i].toFixed(1) for i in [0...@drums.length] by 1
        @drama[i] = @drama[i].toFixed(1) for i in [0...@drama.length] by 1

        @colours = [0x27E7FF, 0x33B32A, 0xFF1100, 0xFCFFFF, 0x27E7FF]

        ###
        RENDER
        ###
        @renderer = new THREE.WebGLRenderer
        @renderer.setClearColor 0x000000, 1
        @renderer.setSize window.innerWidth, window.innerHeight
        @el.appendChild @renderer.domElement

        @composer   = new THREE.EffectComposer @renderer
        @copyPass   = new THREE.ShaderPass THREE.CopyShader
        
        ###
        SCENE
        ###
        @camera = new THREE.PerspectiveCamera( 75,window.innerWidth / window.innerHeight , 1, 2000 )
        @scene = new THREE.Scene()

        @object = new THREE.Object3D()
        @object.name = 'cubes'

        geometry = new THREE.SphereGeometry( 1, 4, 4 )
        

        for i in [0...300]
            material = new THREE.MeshPhongMaterial( { map: THREE.ImageUtils.loadTexture(@getGif()), shading: THREE.FlatShading } )
            mesh = new THREE.Mesh( geometry, material )
            mesh.position.set( Math.random() - 0.7, Math.random() - 0.5, Math.random() - 0.1 ).normalize()
            mesh.position.multiplyScalar( Math.random() * 800 )
            mesh.rotation.set( Math.random() * 2, Math.random() * 2, Math.random() * 2 )
            a = Math.random() * 50
            mesh.scale.x = mesh.scale.y = mesh.scale.z = a
            mesh.originalScale = a
            @object.add( mesh )

        @scene.add( new THREE.AmbientLight( 0x444445 ) )

        ###
        GRITO
        ###

        @videoMaterial = new THREE.MeshBasicMaterial
            map: THREE.ImageUtils.loadTexture 'static/images/grito.jpg'

        planeGeometry = new THREE.PlaneGeometry window.innerWidth, window.innerHeight, 1, 1 

        @plane = new THREE.Mesh planeGeometry, @videoMaterial 
        @plane.name = 'plane'
        @plane.z = 0
        @plane.scale.x = @plane.scale.y = 1.45

        ###
        ###

        @renderPass = new THREE.RenderPass @scene, @camera
        @badTVPass  = new THREE.ShaderPass THREE.BadTVShader 
        @rgbPass    = new THREE.ShaderPass THREE.RGBShiftShader
        @filmPass   = new THREE.ShaderPass THREE.FilmShader 
        @staticPass = new THREE.ShaderPass THREE.StaticShader

        @setupViz()
        
        @onResize()
        window.addEventListener('resize', @onResize, false)

        null

    getGif : () =>
        return 'static/images/gifs/gif_' + @pad(Math.round(Math.random() * 49)) + ".gif"

    pad : (n, pad = 3) =>
        s = "000000000" + n
        return s.substr(s.length-pad)

    changeCamera : (secs) =>
        secs = secs.toFixed(1)
        if _.where(@secs, secs).length > 0 and _.where(@picked, secs).length is 0
            @picked.push secs
            @mouseX = (window.innerWidth / 2 - (Math.random() * window.innerWidth / 2)) / 1.5
            @mouseY = (window.innerHeight / 2 - (Math.random() * window.innerHeight / 2))/ 1.5

        null

    changeScale : (secs) =>
        d = .25
        secs = secs.toFixed(1)
        if _.where(@drums, secs).length > 0 and _.where(@pickedDrums, secs).length is 0
            @pickedDrums.push secs
            for i in @object.children
                i.target = i.originalScale + 15
                i.animating = true

        for i in @object.children
            if(!i.animating)
                s = i.scale.x
                s += (i.originalScale - s) * d
                i.scale.x = i.scale.y = i.scale.z = s
            else 
                if(Math.floor(i.scale.x) < Math.floor(i.target))
                    s = i.scale.x
                    s += (i.target - i.scale.x) * d
                    i.scale.x = i.scale.y = i.scale.z = s
                else 
                    i.animating = false
            

        null

    updateLightDrama : (secs) =>
        secs = secs.toFixed(1)
        if _.where(@drama, secs).length > 0 and _.where(@pickedDrama, secs).length is 0
            @pickedDrama.push secs
            r = Math.floor(Math.random() * (@colours.length - 1))
            @light2.color.setHex( @colours[r] )
            
    update :(a)=>

        @changeCamera a.time
        @changeScale a.time

        if a.time > 37.5 and a.time < 47

            if(!@light2)
                @light2 = new THREE.AmbientLight( 0xFF0000 )
                @light2.position.set( 1, 1, 1 )
                @scene.add( @light2 )
            
            @updateLightDrama a.time

        else 
            if(@light2)
                @scene.remove( @light2 )
                @light2 = null

        @render()

        null

    render : =>
        #@camera.lookAt( @scene.position )
        if @isGrito
            @camera.position.x = 0
            @camera.position.y = 0
            @shaderTime += 0.1
            @badTVPass.uniforms[ 'time' ].value  =  @shaderTime
            @filmPass.uniforms[ 'time' ].value   =  @shaderTime
            @staticPass.uniforms[ 'time' ].value =  @shaderTime
            @composer.render 0.1
        else 
            @camera.position.x += ( @mouseX - @camera.position.x ) * 0.05
            @camera.position.y += ( - @mouseY - @camera.position.y ) * 0.05
            @renderer.render(@scene, @camera)

        null

    setupViz : =>
        @scene.fog = new THREE.FogExp2 0x000000, 0.0005

        @camera.fov = 75
        @camera.far = 2000
        @camera.near = 1
        @camera.position.z = 700
        @camera.aspect = window.innerWidth / window.innerHeight

        @scene.remove @plane
        @scene.remove @object
        @scene.add @object

        @startParams(false)
        @onToggleShaders()
        @onParamsChange()

        null


    setupGrito : =>
        @scene.fog = null

        @camera.fov = 55
        @camera.far = 3000
        @camera.near = 20
        @camera.aspect = window.innerWidth / window.innerHeight

        @camera.position.x = 0
        @camera.position.y = 0
        @camera.position.z = 1000

        @scene.remove @plane
        @scene.remove @object
        @scene.add @plane

        @startParams(true)
        @onToggleShaders()
        @onParamsChange()

        null

    onParamsChange : =>
        #copy gui params into shader uniforms
        @badTVPass.uniforms[ "distortion" ].value  = @badTVParams.distortion
        @badTVPass.uniforms[ "distortion2" ].value = @badTVParams.distortion2
        @badTVPass.uniforms[ "speed" ].value       = @badTVParams.speed
        @badTVPass.uniforms[ "rollSpeed" ].value   = @badTVParams.rollSpeed
        
        @staticPass.uniforms[ "amount" ].value     = @staticParams.amount
        @staticPass.uniforms[ "size" ].value       = @staticParams.size2
        
        @rgbPass.uniforms[ "angle" ].value         = @rgbParams.angle*Math.PI
        @rgbPass.uniforms[ "amount" ].value        = @rgbParams.amount
        
        @filmPass.uniforms[ "sCount" ].value       = @filmParams.count
        @filmPass.uniforms[ "sIntensity" ].value   = @filmParams.sIntensity
        @filmPass.uniforms[ "nIntensity" ].value   = @filmParams.nIntensity

        null

    startParams : (val = true) =>
        if val
            @filmPass.uniforms[ "grayscale" ].value = 0
            @badTVParams={"show":true,"distortion":3.060059035103768,"distortion2":8.147361182980239,"speed":0.06159879360347986,"rollSpeed":0}
            @rgbParams={"show":true,"amount":0.014869250056799501,"angle":1.114169194828719}
            @staticParams={"show":true,"amount":0.006870601838454605,"size2":4}
            @filmParams={"show":true,"count":800,"sIntensity":0.9,"nIntensity":0.4}
        else 
            @filmPass.uniforms[ "grayscale" ].value = 0
            @badTVParams={"show":true,"distortion":0.060059035103768,"distortion2":1.147361182980239,"speed":0.00159879360347986,"rollSpeed":0}
            @rgbParams={"show":true,"amount":0.000000250056799501,"angle":0.000069194828719}
            @staticParams={"show":true,"amount":0.006870601838454605,"size2":4}
            @filmParams={"show":true,"count":800,"sIntensity":0.2,"nIntensity":0.1}
        null

    onToggleShaders : (val = true) =>
        @composer = new THREE.EffectComposer @renderer
        @composer.addPass @renderPass 

        if val
            @composer.addPass @filmPass  if @filmParams.show
            @composer.addPass @badTVPass if @badTVParams.show
            @composer.addPass @rgbPass   if @rgbParams.show
            @composer.addPass @staticPass if @staticParams.show

        @composer.addPass @copyPass 
        @copyPass.renderToScreen = true
        null

    onResize : =>
        @renderer.setSize window.innerWidth, window.innerHeight
        @camera.aspect = window.innerWidth / window.innerHeight
        @camera.updateProjectionMatrix()
        null
        

