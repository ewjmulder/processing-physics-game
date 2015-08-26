public class GameController {

  // All levels defined in the game, mapped by number.
  private Map<Integer, Level> levels;
  // The current level;
  private Level currentLevel;
  // Whether or not the simulation is paused.
  private boolean simulationPaused;
  // Framerate of the game.
  private int gameFrameRate;
  // Speed of the simulation (multiplier).
  private int simulationSpeed;
  // Whether we are in the starting position or not
  private boolean inStartingPosition;

  public GameController() {
    this.levels = new HashMap<Integer, Level>();
    this.currentLevel = 0;
    this.simulationPaused = true;
    this.gameFrameRate = 60;
    this.simulationSpeed = 1;
    this.inStartingPosition = true;
  }
  
  // Get the physics engine step size in seconds (or a fraction of that).
  public float getStepSize() {
    // The normal step size is the based on the framerate.
    float stepSize = 1 / this.gameFrameRate;
    // If the simulation is set to paused, reduce step size to 0, so effectively pausing the simulation.
    if (this.simulationPaused) {
      stepSize = 0;
    }
    return stepSize;
  }
  
  public int getIterationsPerStep() {
    return this.simulationSpeed;
  }
  
  public int getFrameRate() {
    return this.gameFrameRate;
  }
  
  public void addLevel(Level level) {
    this.levels.put(level.getNumber(), level);
  }
  
  public Level getLevel(int number) {
    return this.levels.get(number);
  }

  public void playLevel(int number) {
    this.currentLevel = this.getLevel(number);
  }
  
  public boolean isPlaying() {
    return this.currentLevel != null;
  }
  
  public Level getCurrentLevel() {
    return this.currentLevel;
  }
  
  public Item getItem(Body body) {
    Item item = null;
    for (Item anItem : this.currentLevel.getAllItems()) {
      if (anItem.getBody() == body) {
        item = anItem;
        break;
      }
    }
    return item;
  }
  
  public void play() {
    if (this.canPlay()) {
      this.simulationPaused = false;
      this.inStartingPosition = false;
    }
  }

  public void pause() {
    if (this.canPause()) {
      this.simulationPaused = true;
    }
  }

  public void togglePlay() {
    if (this.canPlay()) {
      this.play();
    } else if (this.canPause()) {
      this.pause();
    }
  }

  public void stop() {
    if (this.canStop()) {
      for (Item item : this.currentLevel.getAllItems()) {
        item.stopSimulation();
      }
      this.inStartingPosition = true;
      this.simulationPaused = true;
      this.simulationSpeed = 1;
    }
  }

  // Run the simulation at half the speed (if not yet back to 1).
  public void rewind() {
    if (this.canRewind()) {
      this.simulationSpeed = this.simulationSpeed / 2;
    }
  }
  
  // Run the simulation at twice the speed (if not yet a max of 16).
  public void fastForward() {
    if (this.canFastForward()) {
      this.simulationSpeed = this.simulationSpeed * 2;
    }
  }
   
  public boolean isRunning() {
    return !this.inStartingPosition;
  }
  
  public boolean canPlay() {
    return this.simulationPaused;
  }

  public boolean canPause() {
    return this.isRunning() && !this.simulationPaused;
  }

  public boolean canStop() {
    return this.isRunning();
  }

  public boolean canFastForward() {
    return this.isRunning() && !this.simulationPaused && this.simulationSpeed < 16;
  }

  public boolean canRewind() {
    return this.isRunning() && !this.simulationPaused && this.simulationSpeed > 1;
  }

}
