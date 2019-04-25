//Todo method CheckChekmate
//Todo Add to AttackedSquares

class King extends Piece
{
  PImage KingImage;
  boolean InCheck;
  boolean NoLegalMovesBlack, NoLegalMovesWhite;
  boolean AttackingPieceUncaptureableBlack, AttackingPieceUncaptureableWhite;
  ArrayList <Piece> AttackedByThesePieces = new ArrayList<Piece>();
  
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
        OutOfCheck(AttackedSquaresWhite, AttackedSquaresBlack);
        if (AttackingMove(squares))
          Capture(pawns, SquareCollection);   
      } else
      {
        this.x = InitXCoord;
        this.y = InitYCoord;
      }
      
    }
  }
  
  void OutOfCheck(ArrayList AttackedSquaresWhite, ArrayList AttackedSquaresBlack)
  {
    if (this.InCheck == true && IsSquareAttacked(AttackedSquaresWhite, AttackedSquaresBlack) == false)
    {
      this.InCheck = false;
      AttackedByThesePieces.clear();
    }
  }
  
  void Checkmate(SquareCollection board)
  {
    //If you cannot move to any unattacked squares
    CheckLegalKingMoves(board);
    //If the attacking piece is not on an attacked square for their color
    IsPieceCaptureable(board);            
    //If the move cannot be blocked
  }
  
  void CheckLegalKingMoves(SquareCollection board)
  {
    int X = board.GetXIndexMouse(this.x);
    int Y = board.GetYIndexMouse(this.y);
    int IllegalSquareCounterBlack = 0, IllegalSquareCounterWhite = 0;
    Square [][] squares = board.squares;
    
    if (isBlack)
    {
      try {
        if (board.AttackedSquaresBlack.contains(squares[X][Y+1]) || squares[X][Y+1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X][Y-1]) || squares[X][Y-1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X-1][Y+1]) || squares[X-1][Y+1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X-1][Y]) || squares[X-1][Y].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X+1][Y]) || squares[X+1][Y].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      try {
        if (board.AttackedSquaresBlack.contains(squares[X+1][Y+1]) || squares[X+1][Y+1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      if (IllegalSquareCounterBlack == 6)
        NoLegalMovesBlack = true;
    }
    else 
    {
      try {
        if (board.AttackedSquaresWhite.contains(squares[X][Y+1]) || squares[X][Y+1].OccupiedBlack)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X][Y-1]) || squares[X][Y-1].OccupiedBlack)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X-1][Y+1]) || squares[X-1][Y+1].OccupiedBlack)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X-1][Y]) || squares[X-1][Y].OccupiedBlack)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X+1][Y]) || squares[X+1][Y].OccupiedBlack)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      try {
        if (board.AttackedSquaresWhite.contains(squares[X+1][Y+1]) || squares[X+1][Y+1].OccupiedBlack)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      if (IllegalSquareCounterWhite == 6)
        NoLegalMovesWhite = true;
    }
  }
  
  void IsPieceCaptureable(SquareCollection board)
  {
    for (Piece p : AttackedByThesePieces)
      {
        if (p.isBlack)
        {
          for (Square s : board.AttackedSquaresBlack)
          {
            if (p.x == s.x && p.y == s.y)
              AttackingPieceUncaptureableBlack = true;
          }
        }
        else
        {
          for (Square s : board.AttackedSquaresWhite)
          {
            if (p.x == s.x && p.y == s.y)
              AttackingPieceUncaptureableWhite = true;
          }
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
