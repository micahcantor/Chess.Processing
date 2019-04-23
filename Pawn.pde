class Pawn extends Piece //<>//
{
  PImage PawnImage;
  ArrayList <Square> PawnAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> PawnAttackedSquaresBlack = new ArrayList();

  public Pawn(PImage _PawnImage, boolean _isBlack, float _x, float _y, SquareCollection board)
  {
    PawnImage = _PawnImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;
    
    AddAttackedSquares(board);
  }

  void draw()
  {
    if (visible)
      image(PawnImage, x + offsetx, y + offsety, l, l);
  }

  void mouseReleased(SquareCollection SquareCollection, Square [][] squares, StateChecker StateChecker, Pawn [] pawns)
  {
    if (Active)
    {      
      GetXYChange(SquareCollection, mouseX, mouseY);
      LockPieceToSquare(squares);
      Active = false;      

      if (Legal(StateChecker, squares))
      {
        FirstMove = false;
        StateChecker.FlipColor();
        UpdateOccupiedSquares(SquareCollection);
        AddAttackedSquares(SquareCollection);
        
        if (AttackingMove(squares))
          Capture(pawns, SquareCollection);
      } else
      {
        this.x = InitXCoord;
        this.y = InitYCoord;
      }
    }
  }
  
  void AddAttackedSquares(SquareCollection board)
  {
    Square [][] squares = board.squares;
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
         
    if (isBlack)
    {
      for (Square s : PawnAttackedSquaresWhite) {
        board.AttackedSquaresWhite.remove(s);
      }
      PawnAttackedSquaresWhite.clear();
       
      try {
        PawnAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY + 1]);
      } catch(IndexOutOfBoundsException e){}
      try {
        PawnAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY + 1]);
      } catch(IndexOutOfBoundsException e){}    
      
      for (Square s : PawnAttackedSquaresWhite) {
        board.AttackedSquaresWhite.add(s);
      }
      
    }
    else
    {  
      for (Square s : PawnAttackedSquaresBlack) {
        board.AttackedSquaresBlack.remove(s);
      }
      PawnAttackedSquaresBlack.clear();

      try {
        PawnAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY - 1]);
      } catch(IndexOutOfBoundsException e){}
      try {
        PawnAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY - 1 ]);
      } catch(IndexOutOfBoundsException e){}
      
      for (Square s : PawnAttackedSquaresBlack) {
        board.AttackedSquaresBlack.add(s);
      }
    } 
    
   //Logging(board);
  }
  
  boolean CheckBasicLegalMoves(Square [][] Squares)
  {  
    for (Square [] rows : Squares)
    {
      for (int i = 0; i < rows.length; i++)
      {
        if (rows[i].active)
        {
          if (XChange == 0 && YChange == 1 && isBlack == true && !rows[i].OccupiedBlack && !rows[i].OccupiedWhite)
          {
            return true;
          }
          else if (XChange == 0 && YChange == -1 && isBlack == false && !rows[i].OccupiedWhite && !rows[i].OccupiedBlack)
          {
            return true;
          }
          else if (XChange == 0 && YChange == 2 && isBlack == true && FirstMove == true && !rows[i].OccupiedBlack && !rows[i].OccupiedWhite && !rows[i - 1].OccupiedWhite && !rows[i -  1].OccupiedBlack)
          {
            return true;
          }
          else if (XChange == 0 && YChange == -2 && isBlack == false && FirstMove == true && !rows[i].OccupiedWhite && !rows[i].OccupiedBlack && !rows[i - 1].OccupiedWhite && !rows[i - 1].OccupiedBlack)
          {
            return true;
          }
          else return false;
        }
      }
    }
    return false;
  }

  boolean Legal(StateChecker StateChecker, Square [][] Squares)
  { 
    if (CheckBasicLegalMoves(Squares) && CheckTurnColor(StateChecker) && SquareOccupiedSameColor(Squares) || AttackingMove(Squares))    
      return true;
    else return false;
  }
  
  void Logging(SquareCollection board)
  {
    ArrayList numbers = new ArrayList();
    ArrayList numbers2 = new ArrayList();
    for (Square s : board.AttackedSquaresBlack)
    {
      numbers.add(s.squarenumber);
    }
    for (Square s : board.AttackedSquaresWhite)
    {
      numbers2.add(s.squarenumber);
    }
    System.out.println("white : " + numbers);
    System.out.println("black : " + numbers2); 
  }
}
