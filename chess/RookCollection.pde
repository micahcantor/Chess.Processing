class RookCollection
{
  Rook [] rooks;
  PImage WhiteRook, BlackRook;
  
  public RookCollection(PImage _WhiteRook, PImage _BlackRook) {
    WhiteRook = _WhiteRook;
    BlackRook = _BlackRook;
  }

  void createRooks(ArrayList<Piece> pieces) {
    rooks    = new Rook [4];
    rooks[0] = new Rook(WhiteRook, false, 0, 420);
    rooks[1] = new Rook(WhiteRook, false, 420, 420);
    rooks[2] = new Rook(BlackRook, true, 0, 0);
    rooks[3] = new Rook(BlackRook, true, 420, 0);
    
    for (Rook r : rooks) {
      pieces.add(r);
    }                                               
  }
  
  void draw() { 
    for(Rook r : rooks) { 
      r.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) { 
    for(Rook r : rooks) { 
      r.mouseMoved(mousex,mousey); 
      }
    } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) { 
     for(Rook r : rooks) { 
        r.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) { 
     for(Rook r : rooks) { 
         r.mouseDragged(mousex,mousey); 
       }
     }
  void mouseReleased(SquareCollection board, ArrayList<Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, Queen [] queens, Knight [] knights) { 
      for (Rook r : rooks) {
        r.mouseReleased(board, pieces, kings, pawns, rooks, bishops, queens, knights);
      }
    }
}
