public class Item {
 
  public static final int NOT_IN_USE_X = -10;
  public static final int NOT_IN_USE_Y = -10;
  
  private ItemType type;
  private boolean placeable;
  private Body body;
  // The starting position of this item as defined by the level.
  private int startGridX;
  private int startGridY;
  // The placed position of this item by the user.
  private int placedGridX;
  private int placedGridY;

  // Use this constructor for placeable items, that have no position yet.
  public Item(ItemType type) {
    // Create these bodies outside the 'playing field', so they do not interact while not in use.
    this(type, NOT_IN_USE_X, NOT_IN_USE_Y);
    this.placeable = true;
  }

  // Use this constructor for non-placeable items, that have a fixed position.
  public Item(ItemType type, int startGridX, int startGridY) {
    //console.log("constructor Item(" + type + ", " + startGridX + ", " + startGridY + ")");
    this.type = type;
    this.placeable = false;
    this.startGridX = startGridX;
    this.startGridY = startGridY;
    this.placedGridX = startGridX;
    this.placedGridY = startGridY;
    int screenX = Util.GRID_SIZE * startGridX;
    int screenY = Util.GRID_SIZE * startGridY;
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
    this.body.setActive(false);
    if (this.type.isStatic()) {
      this.body.setType(Body.b2_staticBody);
    }
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
  
  public boolean isPlaceable() {
    return this.placeable;
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

  public int getPlacedGridX() {
    return this.placedGridX;
  }

  public int getPlacedGridY() {
    return this.placedGridY;
  }
  
  public int getStartGridX() {
    return this.startGridX;
  }

  public int getStartGridY() {
    return this.startGridY;
  }
  
  public boolean isPlaced() {
    return this.placedGridX != this.startGridX && this.placedGridY != this.startGridY;
  }
  
  public void setPlaceOnGrid(int gridX, int gridY) {
    this.placedGridX = gridX;
    this.placedGridY = gridY;
    setPositionOnGrid(this.placedGridX, this.placedGridY);    
  }
  
  public void resetGridPosition() {
    setPositionOnGrid(startGridX, startGridY);
    placedGridX = startGridX;
    placedGridY = startGridY;
  }

  public void stopSimulation() {
    if (this.placeable) {
      setPositionOnGrid(this.placedGridX, this.placedGridY);
    } else {
      setPositionOnGrid(this.startGridX, this.startGridY);
    }
    this.body.SetLinearVelocity(new Vec2(0, 0));
    this.body.SetAngularVelocity(0);
  }
  
  private void setPositionOnGrid(int gridX, int gridY) {
    //FIXME: Problem: we cannot set the position of a polygon this way, since it was created with absolute coordinates. Solve if we want to place or move polygons.
    if  (this.type.getShape() != Shape.POLYGON) {
      Vec2 position = new Vec2(Util.GRID_SIZE * gridX + this.getScreenWidth() / 2, Util.GRID_SIZE * gridY + this.getScreenHeight() / 2);
      this.body.setPosition(Util.physics.screenToWorld(position.x, position.y));
    } else {
      int screenX = Util.GRID_SIZE * gridX;
      int screenY = Util.GRID_SIZE * gridY;
      // Recalculate to absolute screen coordinates. This is needed, because using the screenX and screenY as position of the polygon body causes bugs in box2d.
      int[] screenCoordinates = new int[this.type.getVertices().length];
      for (int index; index < screenCoordinates.length; index += 2) {
        screenCoordinates[index] = screenX + this.type.getVertices()[index];
        screenCoordinates[index + 1] = screenY + this.type.getVertices()[index + 1];
      }
      Util.physics.removeBody(this.body);
      this.body = Util.physics.createPolygon(screenCoordinates);
      this.body.GetFixtureList().SetRestitution(this.type.getRestitution());
      if (this.type.isStatic()) {
        this.body.setType(Body.b2_staticBody);
      }
    }
  }    
  
}
