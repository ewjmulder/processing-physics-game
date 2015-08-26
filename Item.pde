public class Item {
 
  private ItemType type;
  private Body body;
  private int gridX;
  private int gridY;

  public Item(ItemType type) {
    this(type, 0, 0);
  }

  public Item(ItemType type, int gridX, int gridY) {
    console.log("constructor Item(" + type + ", " + gridX + ", " + gridY + ")");
    this.type = type;
    if (this.type.getShape() == Shape.RECTANGLE) {
      this.body = Util.physics.createRect(Util.GRID_SIZE * gridX, Util.GRID_SIZE * gridY, Util.GRID_SIZE * gridX + this.type.getScreenWidth(), Util.GRID_SIZE * gridY + this.type.getScreenHeight());
    } else if (this.type.getShape() == Shape.CIRCLE) {
      this.body = Util.physics.createCircle(Util.GRID_SIZE * gridX, Util.GRID_SIZE * gridY, this.type.getScreenWidth() / 2);
    }
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
  
}
