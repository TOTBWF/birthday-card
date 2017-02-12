window.Particle = class Particle
  # Note that the origin is in the top left
  @pallete = ["255,49,85", "255,175,66", "255,237,94", "73,247,112", "45,174,253"]
  constructor: (@pos, @vel, @color, @isChild) ->
    @Gravity= 0.05
    @alpha = 1
    # Do nothing but set above variables

  update: () ->
    # Decelerate due to gravity
    if(@isChild)
      @alpha -= .04
    @vel.y += @Gravity
    # Update the position based on the velocity
    @pos.y += @vel.y
    @pos.x += @vel.x

  render: (context) ->
    context.save();
    context.beginPath();
    context.arc(@pos.x, @pos.y, 10, 0, Math.PI*2, false);
    context.closePath();
    context.fillStyle = "rgba(" + @color + "," + @alpha + ")"
    context.fill();


FireworkClosure = () ->
  mainCanvas = null
  mainContext = null
  bufferCanvas = null
  bufferContext = null
  viewportWidth = 0
  viewportHeight = 0

  particles = []
  
  fireworkClosure = () ->
    # First measure the viewport
    onWindowResize()
    # Create the canvas and get the context
    mainCanvas = document.createElement('canvas')
    mainContext =  mainCanvas.getContext('2d')
    # Set up a buffer canvas and context as well
    bufferCanvas = document.createElement('canvas')
    bufferContext = bufferCanvas.getContext('2d')
    # Set up the canvas and append it to the document
    setMainCanvasDimensions()
    document.body.appendChild(mainCanvas)
    document.addEventListener('mouseup', createFirework, true)
    document.addEventListener('touchend', createFirework, true)
    update()

  update = () ->
    clearContext()
    window.requestAnimationFrame(update)
    index = particles.length
    while(index--)
      particle = particles[index]
      particle.update()
      particle.render(mainContext)
      if(particle.vel.y > 1 && !particle.isChild)
        particles.splice(particles.indexOf(particle), 1)
        numParticles = 10
        ejectionAngle = 0
        for i in [1..numParticles]
          vel = {
            x: (Math.cos(ejectionAngle)*10)
            y: (Math.sin(ejectionAngle)*10)
          }
          createParticle({x :particle.pos.x, y:particle.pos.y}, vel, particle.color, true)
          ejectionAngle = (2*Math.PI*i/numParticles)
      if(particle.alpha < 0)
        particles.splice(particles.indexOf(particle), 1)

  onWindowResize = () -> 
    viewportWidth = window.innerWidth
    viewportHeight = window.innerHeight

  setMainCanvasDimensions = () ->
    mainCanvas.width = viewportWidth
    mainCanvas.height = viewportHeight

  clearContext = () ->
    mainContext.fillStyle = "rgba(17,17,17,1)"
    mainContext.fillRect(0, 0, viewportWidth, viewportHeight)


  createFirework = () ->
    pos = {
      x: viewportWidth * 0.5,
      y: viewportHeight + 10
    }
    vel = {
      x: Math.random() * 3 - 1.5,
      y: -(Math.random() * 5 + 5)
    }
    color = Particle.pallete[Math.floor(Math.random()*Particle.pallete.length)]
    createParticle(pos, vel, color, false)
    
  createParticle = (pos, vel, color, isChild) ->
    # Make sure we can call this function with empty vars
    particles.push(new Particle(pos, vel, color, isChild))

    


  return fireworkClosure

window.onload = () ->
  myFireworkClosure = FireworkClosure()
  myFireworkClosure()