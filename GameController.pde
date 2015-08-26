public class GameController {

  // All levels defined in the game, mapped by number.
  private Map<Integer, Level> levels;
  // Whether or not the simulation is paused.
  private boolean simulationPaused;
  // Framerate of the game.
  private int gameFrameRate;

  public GameController() {
    this.levels = new HashMap<Integer, Level>();
    this.simulationPaused = true;
    this.gameFrameRate = 60;
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
  
  public int getFrameRate() {
    return this.gameFrameRate;
  }
  
  public void addLevel(Level level) {
    this.levels.put(level.getNumber(), level);
  }
  
  public Level getLevel(int number) {
    return this.levels.get(number);
  }
  
  public void play() {
    this.simulationPaused = false;
  }

  public void pause() {
    this.simulationPaused = true;
  }

  public void togglePlay() {
    this.simulationPaused = !this.simulationPaused;
  }

}
