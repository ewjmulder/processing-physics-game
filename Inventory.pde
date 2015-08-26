public class Inventory {
  
  private List<Item> itemsInInventory;
  private List<Item> itemsUsed;
  
  public Inventory() {
    this.itemsInInventory = new ArrayList<Item>();
    this.itemsUsed = new ArrayList<Item>();
  }

  public void add(Item item) {
    if (this.itemsInInventory.contains(item)) {
      console.error("Duplicate item in inventory");
    }
    this.itemsInInventory.add(item);
  }

  public Item use(ItemType type) {
    if (this.getAmountInInventory(type) < 1) {
      console.error("Requested item type not available in inventory");
    }
    Item item = null;
    for (Item anItem : this.itemsInInventory) {
      if (anItem.getType() == type) {
        item = anItem;
        break;
      }
    }
    this.itemsInInventory.remove(item);
    this.itemsUsed.add(item);
    return item;
  }
  
  public void stopUsing(Item item) {
    if (!this.itemsUsed.contains(item)) {
      console.error("Stop using an item that is not in the itemsUsed");
    }
    this.itemsUsed.remove(item);
    this.itemsInInventory.add(item);
  }
    

  // TODO: guarantee ordering  
  public List<ItemType> getAllTypes() {
    List<ItemType> allTypes = new ArrayList<ItemType>();
    for (Item item : this.itemsInInventory) {
      if (!allTypes.contains(item.getType())) {
        allTypes.add(item.getType());
      }
    }
    for (Item item : this.itemsUsed) {
      if (!allTypes.contains(item.getType())) {
        allTypes.add(item.getType());
      }
    }
  }
  
  public int getAmountInInventory(ItemType type) {
    int amount = 0;
    for (Item item : this.itemsInInventory) {
      if (item.getType() == type) {
        amount++;
      }
    }
    return amount;
  }
  
}


