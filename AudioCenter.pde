public class AudioCenter {

  private Maxim maxim;
  private Map<SoundType, AudioPlayer> playerMap;

  public AudioCenter(Maxim maxim) {
    this.maxim = maxim;
    this.playerMap = new HashMap<SoundType, AudioPlayer>();
  }
  
  public void addSound(SoundType soundType, String path) {
    this.playerMap.put(soundType, maxim.loadFile(path));
  }
  
}
