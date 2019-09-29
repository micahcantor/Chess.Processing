class BishopCollection
{
  Bishop [] bishops;
  PImage WhiteBishop, BlackBishop;
  
  public BishopCollection(PImage _WhiteBishop, PImage _BlackBishop) {
    WhiteBishop = _WhiteBishop;
    BlackBishop = _BlackBishop;
  }

  void createBishops(ArrayList<Piece> pieces) {
    bishops    = new Bishop [4];
    bishops[0] = new Bishop(WhiteBishop, false, 120, 420);
    bishops[1] = new Bishop(WhiteBishop, false, 300, 420);
    bishops[2] = new Bishop(BlackBishop, true, 120, 0);
    bishops[3] = new Bishop(BlackBishop, true, 300, 0);
    
    for (Bishop b : bishops) {
      pieces.add(b);
    }                                               
  }
  
  void draw() { 
    for(Bishop b : bishops) { 
      b.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) { 
    for(Bishop b : bishops) { 
      b.mouseMoved(mousex,mousey); 
    }
  } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) { 
     for(Bishop b : bishops) { 
        b.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) { 
     for(Bishop b : bishops) { 
         b.mouseDragged(mousex,mousey); 
       }
     }
  void mouseReleased(SquareCollection board, ArrayList<Piece> pieces, Rook [] rooks, King [] kings, Pawn [] pawns, Bishop [] bishops, ArrayList <Queen> queens, Knight [] knights) { 
      for (Bishop b : bishops) {
        b.mouseReleased(board, pieces, rooks, kings, pawns, bishops, queens, knights);
      }
    }
}
