
class StateChecker
{
  boolean WhiteTurn = true;
  boolean WhiteInCheck = false;
  boolean BlackInCheck = false;
  
  boolean PinnedPieceMoved;
  
  public StateChecker() {}
  
  void FlipColor()
  {
    WhiteTurn = !WhiteTurn;
  }    
  

}
