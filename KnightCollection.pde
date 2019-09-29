class KnightCollection { 
  Knight [] knights;
  PImage WhiteKnight, BlackKnight;
  
  public KnightCollection(PImage _WhiteKnight, PImage _BlackKnight) {
    WhiteKnight = _WhiteKnight;
    BlackKnight = _BlackKnight;
  }

  void createKnights(ArrayList<Piece> pieces) {
    knights    = new Knight [4];
    knights[0] = new Knight(WhiteKnight, false, 60, 420);
    knights[1] = new Knight(WhiteKnight, false, 360, 420);
    knights[2] = new Knight(BlackKnight, true, 60, 0);
    knights[3] = new Knight(BlackKnight, true, 360, 0);
    
    for (Knight kn : knights) {
      pieces.add(kn);
    }                                               
  }
  
  void draw() { 
    for(Knight kn : knights) { 
      kn.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) { 
    for(Knight kn: knights) { 
        kn.mouseMoved(mousex,mousey); 
      }
    } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) { 
     for(Knight kn: knights) { 
        kn.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) { 
     for(Knight kn: knights) { 
         kn.mouseDragged(mousex,mousey); 
       }
     }
  void mouseReleased(SquareCollection sc, ArrayList<Piece> pieces, Pawn [] pawns, King [] kings, Rook [] rooks, Bishop [] bishops, ArrayList <Queen> queens, Knight [] knights) { 
      for (Knight kn : knights) {
        kn.mouseReleased(sc, pieces, pawns, kings, rooks, bishops, queens, knights);
      }
    }
}
