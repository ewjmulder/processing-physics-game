public class Item {
 
  public static final int NOT_IN_USE_X = -10;
  public static final int NOT_IN_USE_Y = -10;
  
  private ItemType type;
  private Body body;
  private int gridX;
  private int gridY;

  public Item(ItemType type) {
    // Create these bodies outside the 'playing field', so they do not interact while not in use.
    this(type, NOT_IN_USE_X, NOT_IN_USE_Y);
  }

  public Item(ItemType type, int gridX, int gridY) {
    console.log("constructor Item(" + type + ", " + gridX + ", " + gridY + ")");
    this.type = type;
    int screenX = Util.GRID_SIZE * gridX;
    int screenY = Util.GRID_SIZE * gridY;
    if (this.type.getShape() == Shape.POLYGON) {
      // Recalculate to absolute screen coordinates. This is needed, because using the screenX and screenY as position of the polygon body causes bugs in box2d.
      int[] screenCoordinates = new int[this.type.getVertices().length];
      for (int index; index < screenCoordinates.length; index += 2) {
        screenCoordinates[index] = screenX + this.type.getVertices()[index];
        screenCoordinates[index + 1] = screenY + this.type.getVertices()[index + 1];
      }
      this.body = Util.physics.createPolygon(screenCoordinates);      
    } else if (this.type.getShape() == Shape.RECTANGLE) {
      this.body = Util.physics.createRect(screenX, screenY, screenX + this.type.getScreenWidth(), screenY + this.type.getScreenHeight());
    } else if (this.type.getShape() == Shape.CIRCLE) {
      this.body = Util.physics.createCircle(screenX, screenY, this.type.getScreenWidth() / 2);
    }
    this.body.GetFixtureList().SetRestitution(this.type.getRestitution());
    if (this.type.isStatic()) {
      this.body.setType(Body.b2_staticBody);
    }
    this.gridX = gridX;
    this.gridY = gridY;
  }
  
  public ItemType getType() {
    return this.type;
  }
  
  public String getName() {
    return this.type.getName();
  }
  
  public PImage getImage() {
    return this.type.getImage();
  }
  
  public Body getBody() {
    return this.body;
  }
  
  public int getScreenWidth() {
    return this.type.getScreenWidth();
  }

  public int getScreenHeight() {
    return this.type.getScreenHeight();
  }

  public int getGridWidth() {
    return this.type.getGridWidth();
  }

  public int getGridHeight() {
    return this.type.getGridHeight();
  }
  
  public int getGridX() {
    return this.gridX;
  }

  public int getGridY() {
    return this.gridY;
  }
  
  public void resetPosition() {
    Vec2 position = new Vec2(Util.GRID_SIZE * gridX, Util.GRID_SIZE * gridY);
    this.body.setPosition(position);
  }
  
}
