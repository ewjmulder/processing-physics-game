public class Level {

  private int number;
  private SoundType backgroundMusic;
  private String name;
  private String description;
  private PImage backgroundImage;
  private List<Item> fixedItems;
  private Inventory inventory;
  private Item[] goalCollision;

  public Level(int number, SoundType backgroundMusic, String name, String description, PImage backgroundImage, Inventory inventory) {
    this.number = number;
    this.backgroundMusic = backgroundMusic;
    this.name = name;
    this.description = description;
    this.backgroundImage = backgroundImage;
    this.fixedItems = new ArrayList<Item>();
    this.inventory = inventory;
    this.goalCollision = new Item[2];
  }
  
  public int getNumber() {
    return this.number;
  }
  
  public SoundType getBackgroundMusic() {
    return this.backgroundMusic;
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
  
  public void setGoalCollision(Item item1, Item item2) {
    this.goalCollision[0] = item1;
    this.goalCollision[1] = item2;
  }
  
  public boolean isGoalCollision(Item item1, Item item2) {
    return (this.goalCollision[0] == item1 && this.goalCollision[1] == item2) || (this.goalCollision[0] == item2 && this.goalCollision[1] == item1);
  }
  
  public List<Item> getFixedItems() {
    return this.fixedItems;
  }

  // Get all items that are relevant for the simulation (so excluding the unused items in the inventory).
  public List<Item> getItemsInSimulation() {
    List<Item> allItems = new ArrayList<Item>();
    allItems.addAll(this.fixedItems);
    allItems.addAll(this.inventory.getItemsInUse());
    return allItems;
  }

  // Get all items.
  public List<Item> getAllItems() {
    List<Item> allItems = new ArrayList<Item>();
    allItems.addAll(this.fixedItems);
    allItems.addAll(this.inventory.getItemsInUse());
    allItems.addAll(this.inventory.getItemsNotInUse());
    return allItems;
  }

  public Inventory getInventory() {
    return this.inventory;
  }
  
  public void addFixedItem(Item item) {
    this.fixedItems.add(item);
  }

}
