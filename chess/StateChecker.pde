
class StateChecker
{
  boolean WhiteTurn = true;
  boolean WhiteInCheck = false;
  boolean BlackInCheck = false;
  
  public StateChecker() {}
  
  void FlipColor()
  {
    WhiteTurn = !WhiteTurn;
  }    
  

}
