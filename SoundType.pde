public class SoundType {
 
  private int id;
  
  private SoundType(int id) {
    this.id = id;
  }
  
  public static final SoundType PING = new SoundType(1);
  public static final SoundType PONG = new SoundType(2);
  
}
