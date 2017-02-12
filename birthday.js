(function() {
  var FireworkClosure, Particle;

  window.Particle = Particle = (function() {
    Particle.pallete = ["255,49,85", "255,175,66", "255,237,94", "73,247,112", "45,174,253"];

    function Particle(pos1, vel1, color1, isChild1) {
      this.pos = pos1;
      this.vel = vel1;
      this.color = color1;
      this.isChild = isChild1;
      this.Gravity = 0.05;
      this.alpha = 1;
    }

    Particle.prototype.update = function() {
      if (this.isChild) {
        this.alpha -= .04;
      }
      this.vel.y += this.Gravity;
      this.pos.y += this.vel.y;
      return this.pos.x += this.vel.x;
    };

    Particle.prototype.render = function(context) {
      context.save();
      context.beginPath();
      context.arc(this.pos.x, this.pos.y, 10, 0, Math.PI * 2, false);
      context.closePath();
      context.fillStyle = "rgba(" + this.color + "," + this.alpha + ")";
      return context.fill();
    };

    return Particle;

  })();

  FireworkClosure = function() {
    var bufferCanvas, bufferContext, clearContext, createFirework, createParticle, fireworkClosure, mainCanvas, mainContext, onWindowResize, particles, setMainCanvasDimensions, update, viewportHeight, viewportWidth;
    mainCanvas = null;
    mainContext = null;
    bufferCanvas = null;
    bufferContext = null;
    viewportWidth = 0;
    viewportHeight = 0;
    particles = [];
    fireworkClosure = function() {
      onWindowResize();
      mainCanvas = document.createElement('canvas');
      mainContext = mainCanvas.getContext('2d');
      bufferCanvas = document.createElement('canvas');
      bufferContext = bufferCanvas.getContext('2d');
      setMainCanvasDimensions();
      document.body.appendChild(mainCanvas);
      document.addEventListener('mouseup', createFirework, true);
      document.addEventListener('touchend', createFirework, true);
      return update();
    };
    update = function() {
      var ejectionAngle, i, index, j, numParticles, particle, ref, results, vel;
      clearContext();
      window.requestAnimationFrame(update);
      index = particles.length;
      results = [];
      while (index--) {
        particle = particles[index];
        particle.update();
        particle.render(mainContext);
        if (particle.vel.y > 1 && !particle.isChild) {
          particles.splice(particles.indexOf(particle), 1);
          numParticles = 10;
          ejectionAngle = 0;
          for (i = j = 1, ref = numParticles; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
            vel = {
              x: Math.cos(ejectionAngle) * 10,
              y: Math.sin(ejectionAngle) * 10
            };
            createParticle({
              x: particle.pos.x,
              y: particle.pos.y
            }, vel, particle.color, true);
            ejectionAngle = 2 * Math.PI * i / numParticles;
          }
        }
        if (particle.alpha < 0) {
          results.push(particles.splice(particles.indexOf(particle), 1));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    onWindowResize = function() {
      viewportWidth = window.innerWidth;
      return viewportHeight = window.innerHeight;
    };
    setMainCanvasDimensions = function() {
      mainCanvas.width = viewportWidth;
      return mainCanvas.height = viewportHeight;
    };
    clearContext = function() {
      mainContext.fillStyle = "rgba(17,17,17,1)";
      return mainContext.fillRect(0, 0, viewportWidth, viewportHeight);
    };
    createFirework = function() {
      var color, pos, vel;
      pos = {
        x: viewportWidth * 0.5,
        y: viewportHeight + 10
      };
      vel = {
        x: Math.random() * 3 - 1.5,
        y: -(Math.random() * 5 + 5)
      };
      color = Particle.pallete[Math.floor(Math.random() * Particle.pallete.length)];
      return createParticle(pos, vel, color, false);
    };
    createParticle = function(pos, vel, color, isChild) {
      return particles.push(new Particle(pos, vel, color, isChild));
    };
    return fireworkClosure;
  };

  window.onload = function() {
    var myFireworkClosure;
    myFireworkClosure = FireworkClosure();
    return myFireworkClosure();
  };

}).call(this);
