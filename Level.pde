public class Level {

  private int number;
  private String name;
  private String description;
  private PImage backgroundImage;
  private List<Item> fixedItems;
  private Inventory inventory;

  public Level(int number, String name, String description, PImage backgroundImage, Inventory inventory) {
    this.number = number;
    this.name = name;
    this.description = description;
    this.backgroundImage = backgroundImage;
    this.fixedItems = new ArrayList<Item>();
    console.log("inventory: " + inventory);
    this.inventory = inventory;
  }
  
  public int getNumber() {
    return this.number;
  }
  
  public String getName() {
    return this.name;
  }
  
  public String getDescription() {
    return this.description;
  }
  
  public PImage getBackgroundImage() {
    return this.backgroundImage;
  }
  
  public List<Item> getFixedItems() {
    return this.fixedItems;
  }
  
  public Inventory getInventory() {
    return this.inventory;
  }
  
  public void addFixedItem(Item item) {
    this.fixedItems.add(item);
  }

}
