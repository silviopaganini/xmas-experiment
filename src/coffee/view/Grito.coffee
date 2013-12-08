class Grito extends Backbone.View

    camera        : null
    scene         : null
    renderer      : null
    
    videoTexture  : null
    videoMaterial : null
    
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

    initialize : =>

        @$el.attr 'id', 'grito'
        
        @camera = new THREE.PerspectiveCamera 55, 1080/ 720, 20, 3000
        @camera.position.z = 1000
        @scene = new THREE.Scene()

        #init video texture
        @videoMaterial = new THREE.MeshBasicMaterial
            map: THREE.ImageUtils.loadTexture '/static/images/grito.jpg'

        #Add video plane
        planeGeometry = new THREE.PlaneGeometry 1080, 720, 1, 1 
        plane = new THREE.Mesh planeGeometry, @videoMaterial 
        @scene.add plane
        plane.z = 0
        plane.scale.x = plane.scale.y = 1.45

        #init renderer
        @renderer = new THREE.WebGLRenderer
        @renderer.setSize $(window).innerWidth(), $(window).innerHeight()
        @$el.append @renderer.domElement 

        #POST PROCESSING
        #Create Shader Passes
        @renderPass = new THREE.RenderPass @scene, @camera
        @badTVPass  = new THREE.ShaderPass THREE.BadTVShader 
        @rgbPass    = new THREE.ShaderPass THREE.RGBShiftShader
        @filmPass   = new THREE.ShaderPass THREE.FilmShader 
        @staticPass = new THREE.ShaderPass THREE.StaticShader
        @copyPass   = new THREE.ShaderPass THREE.CopyShader
        
        @startParams()
        @onToggleShaders()
        @onParamsChange()
        @onResize()
        window.addEventListener('resize', @onResize, false)
        #window.addEventListener('click', @randomizeParams, false)
        @animate()

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

    startParams : =>
        ### @badTVParams.distortion = Math.random()*10+0.1
        @badTVParams.distortion2 =Math.random()*10+0.1
        @badTVParams.speed =Math.random()*.4
        @badTVParams.rollSpeed =Math.random()*.2
        @badTVParams.rollSpeed = 0
        @rgbParams.angle = Math.random()*2
        @rgbParams.amount = Math.random()*0.03
        @staticParams.amount = Math.random()*0.2###

        @filmPass.uniforms[ "grayscale" ].value = 0
        @badTVParams={"mute":false,"show":true,"distortion":3.060059035103768,"distortion2":8.147361182980239,"speed":0.06159879360347986,"rollSpeed":0}
        @rgbParams={"show":true,"amount":0.014869250056799501,"angle":1.114169194828719}
        @staticParams={"show":true,"amount":0.006870601838454605,"size2":4}
        @filmParams={"show":true,"count":800,"sIntensity":0.9,"nIntensity":0.4}
        null

    randomizeParams : =>
        @badTVParams={"mute":false,"show":true,"distortion":3.060059035103768,"distortion2":8.147361182980239,"speed":0.06159879360347986,"rollSpeed":0}
        @rgbParams={"show":true,"amount":0.014869250056799501,"angle":1.114169194828719}
        @staticParams={"show":true,"amount":0.006870601838454605,"size2":4}
        @filmParams={"show":true,"count":800,"sIntensity":0.9,"nIntensity":0.4}

        @onParamsChange()

        return

        @badTVParams.distortion  = Math.random()*10+0.1
        @badTVParams.distortion2 = Math.random()*10+0.1
        @badTVParams.speed       = Math.random()*.4
        @badTVParams.rollSpeed   = 0
        @rgbParams.angle         = Math.random()*2
        @rgbParams.amount        = Math.random()*0.03
        @staticParams.amount     = Math.random()*0.2

        a = 
            "@badTVParams" : @badTVParams,
            "@rgbParams": @rgbParams, 
            "@staticParams": @staticParams, 
            "@filmParams": @filmParams

        console.log JSON.stringify a

        @onParamsChange()
        null

    onToggleShaders : =>
        @composer = new THREE.EffectComposer @renderer
        @composer.addPass @renderPass 
        
        if @filmParams.show
            @composer.addPass @filmPass 
        

        if @badTVParams.show
            @composer.addPass @badTVPass 
        

        if @rgbParams.show
            @composer.addPass @rgbPass 
        

        if @staticParams.show
            @composer.addPass @staticPass 
        

        @composer.addPass @copyPass 
        @copyPass.renderToScreen = true
        null

    onResize : =>
        @renderer.setSize window.innerWidth, window.innerHeight
        @camera.aspect = window.innerWidth / window.innerHeight
        @camera.updateProjectionMatrix()
        null

    animate : =>

        @shaderTime += 0.1
        @badTVPass.uniforms[ 'time' ].value  =  @shaderTime
        @filmPass.uniforms[ 'time' ].value   =  @shaderTime
        @staticPass.uniforms[ 'time' ].value =  @shaderTime

        @composer.render 0.1
        requestAnimationFrame @animate 
            
        null