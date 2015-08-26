public class SoundType {

  public static final SoundType PING = new SoundType("Ping");
  public static final SoundType PONG = new SoundType("Pong");
 
  private String name;
  
  private SoundType(String name) {
    this.name = name;
  }
  
  public String toString() {
    return this.name;
  }
  
}
