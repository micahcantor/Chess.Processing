class KingCollection
{
  King [] kings;
  PImage WhiteKing, BlackKing;
  
  public KingCollection(PImage _WhiteKing, PImage _BlackKing)
  {
    WhiteKing = _WhiteKing;
    BlackKing = _BlackKing;
  }

  void createKings()
  {
    kings = new King [2];
    kings[0] = new King(WhiteKing, false, 240, 420);
    kings[1] = new King(BlackKing, true, 240, 0);
  }
  
  void draw() 
  { 
    for(King k : kings) 
    { 
      k.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) 
  { 
  for(King k : kings) 
    { 
      k.mouseMoved(mousex,mousey); 
    }
  } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) 
    { 
     for(King k : kings) 
      { 
        k.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) 
    { 
     for(King k : kings) 
       { 
         k.mouseDragged(mousex,mousey); 
       }
     }
  void mouseReleased(SquareCollection SquareCollection, Square [][] squares, Pawn [] pawns) 
    { 
      for (King k : kings)
      {
        k.mouseReleased(SquareCollection, squares, pawns, kings, SquareCollection.AttackedSquaresWhite, SquareCollection.AttackedSquaresBlack);
      }
    }
}
