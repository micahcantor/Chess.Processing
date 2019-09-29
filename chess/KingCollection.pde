class KingCollection
{
  King [] kings;
  PImage WhiteKing, BlackKing;
  
  public KingCollection(PImage _WhiteKing, PImage _BlackKing) {
    WhiteKing = _WhiteKing;
    BlackKing = _BlackKing;
  }

  void createKings(ArrayList<Piece> pieces) {
    kings = new King [2];
    kings[0] = new King(WhiteKing, false, 240, 420, 4, 7);
    kings[1] = new King(BlackKing, true, 240, 0, 4, 0); 
    
    for (King k : kings) {
      pieces.add(k);
    }
  }
  
  void draw() { 
    for(King k : kings) { 
      k.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) { 
  for(King k : kings) { 
      k.mouseMoved(mousex,mousey); 
    }
  } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) { 
     for(King k : kings){ 
        k.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) { 
     for(King k : kings) { 
         k.mouseDragged(mousex,mousey); 
       }
     }
  void mouseReleased(SquareCollection board, ArrayList <Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, Queen [] queens, Knight [] knights) { 
      for (King k : kings){
        k.mouseReleased(board, pieces, kings, pawns, rooks, bishops, queens, knights);
      }
    }
}
