class Piece
{
  boolean isBlack;
  boolean FirstMove = true;
  boolean visible = true;
  float x, y, l;
  boolean Active; //stores the over method as a variable
  int clickx, clicky; //Store the position of the mouse when it is clicked
  int offsetx=0, offsety=0; // Store the difference in location from where the mouse is clicked to where it moves to
  //offset = mouse - click
  
  int InitSquareX, InitSquareY, FinalSquareX, FinalSquareY, InitXCoord, InitYCoord, FinalXCoord, FinalYCoord;
  int XChange, YChange;
  
  public Piece () {}
  
  void mouseMoved(int mousex, int mousey) 
  {
    Active = over(mousex, mousey);
  }

  void mousePressed(int mousex, int mousey, SquareCollection squares)
  {
    if (Active == true)
    { 
      InitSquareX = squares.GetXIndexMouse(mousex);
      InitSquareY = squares.GetYIndexMouse(mousey);
      InitXCoord = (int) this.x;
      InitYCoord = (int) this.y;

      clickx = mousex;
      clicky = mousey;
      offsetx = 0;
      offsety = 0;
    }
  }

  void mouseDragged(int mousex, int mousey)
  {
    if (Active == true)
    {
      offsetx = mousex - clickx;
      offsety = mousey - clicky;
    }
  }
  
  void Capture (Pawn [] pawns, SquareCollection board)
  {
    for (Pawn p : pawns)
    {
      if (this.x == p.FinalXCoord && this.y == p.FinalYCoord)
      {
        p.visible = false;
        this.visible = true;
        
        if (p.isBlack)
        {
          for (Square s : p.PawnAttackedSquaresWhite)
          {
            board.AttackedSquaresWhite.remove(s);
          }
          p.PawnAttackedSquaresWhite.clear();
        } else
        {
          for (Square s : p.PawnAttackedSquaresBlack)
          {
            board.AttackedSquaresBlack.remove(s);
          }
          p.PawnAttackedSquaresBlack.clear();
        }
        
      }
    }
  }
  
 
  void LockPieceToSquare (Square [][] Squares)
  {
     for(Square [] rows : Squares)
      {
        for (Square s : rows)
        {
          if (s.active)
          {
            this.x = s.x;
            this.y = s.y;
          }
        }
        offsetx = 0;
        offsety = 0;
      }
  }
 
  void UpdateOccupiedSquares(SquareCollection board)
  {
    Square [] [] AllSquares = board.squares;
    FinalXCoord = (int) AllSquares[FinalSquareX][FinalSquareY].x;
    FinalYCoord = (int) AllSquares[FinalSquareX][FinalSquareY].y;
    
    for (Square [] row : AllSquares)
    {
      for (Square s : row)
      {
        if (s.x == InitXCoord && s.y == InitYCoord)
        { 
          s.OccupiedBlack = false;
          s.OccupiedWhite = false;
        }
        if (s.x == FinalXCoord && s.y == FinalYCoord && isBlack)
        {
          s.OccupiedBlack = true;
        }
        else if (s.x == FinalXCoord && s.y == FinalYCoord && isBlack == false)
        {
          s.OccupiedWhite = true;
        }
      }
    }
  }
  
  void GetXYChange(SquareCollection squares, float mousex, float mousey)
  {
    FinalSquareX = squares.GetXIndexMouse(mousex);
    FinalSquareY = squares.GetYIndexMouse(mousey);

    XChange = FinalSquareX - InitSquareX;
    YChange = FinalSquareY - InitSquareY;
  }
  
  boolean OnAttackedSquare(ArrayList<Square> AttackedSquaresWhite, ArrayList<Square> AttackedSquaresBlack)
  {
    if (isBlack)
    {
      for (Square s : AttackedSquaresBlack)
      {
        if (s.x == this.x && s.y == this.y)
          return true;
      }
    }
    else
    {
      for (Square s : AttackedSquaresWhite)
      {
        if (s.x == this.x && s.y == this.y)
          return true;
      }
    }
    return false;
  }
  boolean over(int mousex, int mousey)
  {
    return(mousex >= x && mousex <= x + 60 && mousey >= y && mousey <= y + 60);
  }

  boolean CheckTurnColor(StateChecker StateChecker)
  {
    if (isBlack == false && StateChecker.WhiteTurn == true)
      return true;
    else if (isBlack == true && StateChecker.WhiteTurn == false)
      return true;
    else return false;
  }
  
  boolean YourKinginCheck(King [] kings)
  {
    if (isBlack && kings[1].InCheck)
      return true;
    else if (!isBlack && kings[0].InCheck)
      return true;
    else return false;
  }
  
  boolean SquareOccupiedSameColor(Square [][] Squares)
  {
    for(Square [] rows : Squares)
      {
        for (Square s : rows)
        {
          if (s.active)
          {
            if ((s.OccupiedWhite && isBlack == false))
              return false;
            else if (s.OccupiedBlack && isBlack)
              return false;
                else return true;
          }
        }
      }
      return false;
  }
  
  boolean AttackingMove(Square [][] Squares)
  {
    for (Square [] rows : Squares)
    {
      for (int i = 0; i < rows.length; i++)
      {
        if (rows[i].active)
        {
          if (isBlack && rows[i].OccupiedWhite)
          {
            return true;
          }
          else if (!isBlack && rows[i].OccupiedBlack)
          {
            return true;
          }
          else return false;
        }
      }
    } return false;
  }
  
}
