class King extends Piece
{
  PImage KingImage;
  
  public King(PImage _KingImage, boolean _isBlack, float _x, float _y)
  {
    KingImage = _KingImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;
  }
  
  void draw()
  {
    image(KingImage, x + offsetx, y + offsety, l, l);
  }
  
  void mouseReleased(SquareCollection SquareCollection, Square [][] squares, Pawn [] pawns, King [] kings, ArrayList <Square> AttackedSquaresWhite, ArrayList <Square> AttackedSquaresBlack)
  {
    if (Active)
    {      
      GetXYChange(SquareCollection, mouseX, mouseY);
      LockPieceToSquare(squares);
      Active = false;      

      if (Legal(StateChecker, squares, AttackedSquaresWhite, AttackedSquaresBlack))
      {
        FirstMove = false;
        StateChecker.FlipColor();
        UpdateOccupiedSquares(SquareCollection);
        if (AttackingMove(squares))
          Capture(pawns, SquareCollection);   
      } else
      {
        this.x = InitXCoord;
        this.y = InitYCoord;
      }
      
    }
  }
  
  boolean IsSquareAttacked(ArrayList <Square> AttackedSquaresWhite, ArrayList <Square> AttackedSquaresBlack)
  {
    if (isBlack)
    {
      for (Square s : AttackedSquaresBlack)
      {
        if (s.x == this.x && s.y == this.y)
          return true;
      } 
      return false;
    }
    else 
    {
      for (Square s : AttackedSquaresWhite)
      {
        if (s.x == this.x && s.y == this.y)
          return true;
      }
      return false;
    }
  }
  boolean CheckBasicLegalMoves(Square [][] Squares)
  {  
    for (Square [] rows : Squares)
    {
      for (int i = 0; i < rows.length; i++)
      {
        if (rows[i].active)
        {
          if ((XChange == 1 || XChange == 0 || XChange == -1) && (YChange == 0 || YChange == 1 || YChange == -1) && isBlack == false && !rows[i].OccupiedWhite)
            return true;
          else if ((XChange == 1 || XChange == 0 || XChange == -1) && (YChange == 0 || YChange == 1 || YChange == -1) && isBlack && !rows[i].OccupiedBlack)
            return true;
          else return false;
        }
      }
    }
    return false;
  } 
  
  boolean Legal(StateChecker StateChecker, Square [][] Squares, ArrayList <Square> AttackedSquaresWhite, ArrayList <Square> AttackedSquaresBlack)
  {
    if (CheckBasicLegalMoves(Squares) && CheckTurnColor(StateChecker) && SquareOccupiedSameColor(Squares) && !IsSquareAttacked(AttackedSquaresWhite, AttackedSquaresBlack))    
      return true;
    else return false;
  }
  
}
