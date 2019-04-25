
class PawnCollection
{
  Pawn [] pawns;
  PImage WhitePawn, BlackPawn;
  
  PawnCollection(PImage _WhitePawn, PImage _BlackPawn)
  {
    WhitePawn = _WhitePawn;
    BlackPawn = _BlackPawn;
  }

  void createPawns(Square [] [] squares, SquareCollection board)
  {
    pawns = new Pawn[16];
    int x, y, FileCounterBlack = 0, FileCounterWhite = 0;
    for (int i = 0; i < pawns.length; i++)
    {
      if (i < 8)
      {
        x = 60 * (FileCounterBlack); //may change eventually to starting square x and starting square y
        y = 60;
        pawns[i] = new Pawn(BlackPawn, true, x, y, board);
        FileCounterBlack++;
        
        for (Square [] row : squares)
        {
          for (Square s : row)
          {
            if (x == s.x && y == s.y)
              s.OccupiedBlack = true;
          }
        }
      }
      else
      {
        x = 60 * (FileCounterWhite);
        y = 360;
        pawns[i] = new Pawn(WhitePawn, false, x, y, board);
        FileCounterWhite++;
        
        for (Square [] row : squares)
        {
          for (Square s : row)
          {
            if (x == s.x && y == s.y)
              s.OccupiedWhite = true;
          }
        }
      }
    }
  }
  void draw() 
  { 
    for(Pawn p : pawns) 
    { 
      p.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) 
  { 
  for(Pawn p: pawns) 
    { 
      p.mouseMoved(mousex,mousey); 
    }
  } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) 
    { 
     for(Pawn p: pawns) 
      { 
        p.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) 
    { 
     for(Pawn p: pawns) 
       { 
         p.mouseDragged(mousex,mousey); 
       }
     }
  void mouseReleased(SquareCollection SquareCollection, Square [][] squares, StateChecker StateChecker, Pawn [] pawns, King [] kings) 
    { 
      for (Pawn p : pawns)
      {
        p.mouseReleased(SquareCollection, squares, StateChecker, pawns, kings);
      }
    }
}
