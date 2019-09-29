
class PawnCollection
{
  Pawn [] pawns;
  PImage WhitePawn, BlackPawn;
  
  PawnCollection(PImage _WhitePawn, PImage _BlackPawn) {
    WhitePawn = _WhitePawn;
    BlackPawn = _BlackPawn;
  }

  void createPawns(ArrayList<Piece> pieces) {
    pawns = new Pawn[16];
    int x, y, FileCounterBlack = 0, FileCounterWhite = 0;
    for (int i = 0; i < pawns.length; i++) {
      if (i < 8) {
        x = 60 * (FileCounterBlack); //may change eventually to starting square x and starting square y
        y = 60;
        pawns[i] = new Pawn(BlackPawn, true, x, y);
        FileCounterBlack++;
      }
      else {
        x = 60 * (FileCounterWhite);
        y = 360;
        pawns[i] = new Pawn(WhitePawn, false, x, y);
        FileCounterWhite++;
      }
    }
    
    for (Pawn p : pawns) {
      pieces.add(p);
    }
  }
  void draw() { 
    for(Pawn p : pawns) { 
      p.draw(); 
    }
  }
  void mouseMoved(int mousex, int mousey) { 
    for(Pawn p: pawns) { 
        p.mouseMoved(mousex,mousey); 
      }
    } 
  void mousePressed(int mousex, int mousey, SquareCollection squares) { 
     for(Pawn p: pawns) { 
        p.mousePressed(mousex,mousey, squares); 
      }
    } 
  void mouseDragged(int mousex, int mousey) { 
     for(Pawn p: pawns) { 
         p.mouseDragged(mousex,mousey); 
       }
     }
  void mouseReleased(SquareCollection sc, ArrayList<Piece> pieces, Pawn [] pawns, King [] kings, Rook [] rooks, Bishop [] bishops, Queen [] queens, Knight [] knights) { 
      for (Pawn p : pawns) {
        p.mouseReleased(sc, pieces, pawns, kings, rooks, bishops, queens, knights);
      }
    }
}
