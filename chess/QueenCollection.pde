class QueenCollection
{
  Queen [] queens;
  PImage WhiteQueen, BlackQueen;
  
  public QueenCollection(PImage _WhiteQueen, PImage _BlackQueen) {
    WhiteQueen = _WhiteQueen;
    BlackQueen = _BlackQueen;
  }

  void createQueens(ArrayList<Piece> pieces) {
    queens    = new Queen [2];
    queens[0] = new Queen(WhiteQueen, false, 180, 420);
    queens[1] = new Queen(BlackQueen, false, 180, 0);
    
    for (Queen q : queens) {
      pieces.add(q);
    }                                               
  }
  
  void draw() { 
    for(Queen q : queens) { 
      q.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) { 
    for(Queen q : queens) { 
      q.mouseMoved(mousex,mousey); 
      }
    } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) { 
     for(Queen q : queens) { 
        q.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) { 
     for(Queen q : queens) { 
         q.mouseDragged(mousex,mousey); 
       }
   }
  //void mouseReleased(SquareCollection board, ArrayList<Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops) { 
  //    for (Queen q : queens) {
  //      q.mouseReleased(board, pieces, kings, pawns, rooks, bishops);
  //    }
  //  }
}
