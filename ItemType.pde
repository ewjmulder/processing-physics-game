// Put this class above the ItemType, otherwise it's not known yet when it's needed.
public class Shape {
  
  public static final Shape POLYGON = new Shape("Polygon");
  public static final Shape CIRCLE = new Shape("Circle");
  public static final Shape RECTANGLE = new Shape("Rectangle");

  private String name;
  
  private Shape(String name) {
    this.name = name;
  }
  
  public String toString() {
    return this.name;
  }
  
}

public class ItemType {
 
  // TODO: Find a way to use the image.width/height fields in such a way that they are always initialized, so we don't have to provide them here explicitly.
  //Alternatively: get them from the filename
  public static final ItemType GOAL = new ItemType("Goal", Shape.CIRCLE, null, 0, true, loadImage("items/target.png"), 60, 60);
  public static final ItemType SOCCER_BALL = new ItemType("Soccer ball", Shape.CIRCLE, null, 0.7, false, loadImage("items/soccer_ball.png"), 60, 60);
  public static final ItemType BOWLING_BALL = new ItemType("Bowling ball", Shape.CIRCLE, null, 0.1, false, loadImage("items/bowling_ball.png"), 60, 60);
  public static final ItemType WOODEN_BEAM = new ItemType("Wooden beam", Shape.RECTANGLE, null, 0.5, true, loadImage("items/wooden_beam.png"), 200, 20);
  public static final ItemType DIAGONAL_BEAM = new ItemType("Diagonal beam", Shape.POLYGON, new int[] {0, 14, 14, 0, 100, 86, 86, 100}, 0.5, true, loadImage("items/diagonal_beam.png"), 100, 100);
  public static final ItemType DIAGONAL_BEAM_REVERSED = new ItemType("Diagonal beam reversed", Shape.POLYGON, new int[] {86, 0, 100, 14, 14, 100, 0, 86}, 0.5, true, loadImage("items/diagonal_beam_reversed.png"), 100, 100);
  public static final ItemType TRAMPOLINE = new ItemType("Trampoline", Shape.RECTANGLE, null, 0.5, true, loadImage("items/trampoline.png"), 120, 60);
  
  private String name;
  private Shape shape;
  private int[] vertices;
  private float restitution;
  private boolean staticItem;
  private PImage image;
  private int screenWidth;
  private int screenHeight;
  private int gridWidth;
  private int gridHeight;

  public ItemType(String name, Shape shape, int[] vertices, float restitution, boolean staticItem, PImage image, int screenWidth, int screenHeight) {
    this.name = name;
    this.shape = shape;
    this.vertices = vertices;
    this.restitution = restitution;
    this.staticItem = staticItem;
    this.image = image;
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    this.gridWidth = (int)(this.screenWidth / Util.GRID_SIZE);
    this.gridHeight = (int)(this.screenHeight / Util.GRID_SIZE);

    if (this.shape == Shape.POLYGON && this.vertices == null) {
      console.error("A polygon shape must always have vertices");
    }
    if (this.shape != Shape.POLYGON && this.vertices != null) {
      console.error("A non polygon shape cannot have vertices");
    }
    if (this.shape == Shape.CIRCLE && this.width != this.height) {
      console.error("Circles must have equal width and height");
    }
    if (this.screenWidth / Util.GRID_SIZE != (int)(this.screenWidth / Util.GRID_SIZE)) {
      console.error("Width must be a multiple of the grid size: " + Util.GRID_SIZE);
    }
    if (this.screenHeight / Util.GRID_SIZE != (int)(this.screenHeight / Util.GRID_SIZE)) {
      console.error("Height must be a multiple of the grid size: " + Util.GRID_SIZE);
    }
  }

  public String getName() {
    return this.name;
  }

  public Shape getShape() {
    return this.shape;
  }

  // Only applicable for Shape.POLYGON
  public int[] getVertices() {
    return this.vertices;
  }
  
  public float getRestitution() {
    return this.restitution;
  }

  public boolean isStatic() {
    return this.staticItem;
  }
  
  public PImage getImage() {
    return this.image;
  }
  
  public int getScreenWidth() {
    return this.screenWidth;
  }

  public int getScreenHeight() {
    return this.screenHeight;
  }

  public int getGridWidth() {
    return this.gridWidth;
  }

  public int getGridHeight() {
    return this.gridHeight;
  }
  
  public String toString() {
    return "ItemType(" + this.name + ", " + this.shape + ", " + this.image + ")";
  }
  
}
