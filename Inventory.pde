public class Inventory {

  private List<ItemType> allTypes;
  private List<Item> itemsInInventory;
  private List<Item> itemsUsed;
  
  public Inventory() {
    this.allTypes = new ArrayList<ItemType>();
    this.itemsInInventory = new ArrayList<Item>();
    this.itemsUsed = new ArrayList<Item>();
  }

  public void add(ItemType itemType) {
    this.add(itemType, 1);
  }

  public void add(ItemType itemType, int amount) {
    for (int i = 0; i < amount; i++) {
      this.itemsInInventory.add(new Item(itemType));
    }
    if (!this.allTypes.contains(itemType)) {
      this.allTypes.add(itemType);
    }
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
    item.resetGridPosition();
    this.itemsUsed.remove(item);
    this.itemsInInventory.add(item);
  }

  public void resetUsedItems() {
    for (Item item : new ArrayList<Item>(this.itemsUsed)) {
      item.resetGridPosition();
      this.itemsUsed.remove(item);
      this.itemsInInventory.add(item);
    }
  }
  
  public List<Item> getItemsInUse() {
    return this.itemsUsed;
  }

  public List<Item> getItemsNotInUse() {
    return this.itemsInInventory;
  }

  public List<ItemType> getAllTypes() {
    return this.allTypes;
  }
  
  public int countTypes() {
    return this.getAllTypes().size();
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


