import java.util.*;

class Piece {
  boolean isBlack;
  boolean FirstMove = true;
  boolean visible = true;
  boolean BlackIsCaptured;
  boolean AttackingMove;
  
  float x, y, l;
  int XInd, YInd;
  boolean active; //stores the over method as a variable
  int clickx, clicky; //Store the position of the mouse when it is clicked
  int offsetx=0, offsety=0; // Store the difference in location from where the mouse is clicked to where it moves to
  //offset = mouse - click
  
  int InitSquareX, InitSquareY, FinalSquareX, FinalSquareY, InitXCoord, InitYCoord, FinalXCoord, FinalYCoord;
  int XChange, YChange;
  int CapturedOnX, CapturedOnY;

  
  public Piece () {}
  
  void mouseMoved(int mousex, int mousey) {
    active = over(mousex, mousey);
  }

  void mousePressed(int mousex, int mousey, SquareCollection squares) {
    if (active == true) { 
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

  void mouseDragged(int mousex, int mousey) {
    if (active) {
      offsetx = mousex - clickx;
      offsety = mousey - clicky;
    }
  }
  
  
  void Capture(ArrayList <Piece> pieces) {
    // Loop through all pieces
    // find the one on the square with captured coords
    
    //Make piece invisible
    for (Piece pi : pieces) {
      if (pi.x == CapturedOnX && pi.y == CapturedOnY && RightCaptureColor(pi.isBlack) && pi.visible) {
        println(BlackIsCaptured, pi.isBlack);
        pi.visible = false;
      }
    }
  }
  
  void LockPieceToSquare (Square [][] Squares) {
     for(Square [] rows : Squares) {
        for (Square s : rows) {
          if (s.active) {
            this.x = s.x;
            this.y = s.y;
          }
        }
        offsetx = 0;
        offsety = 0;
      }
  }
 
  void UpdateOccupiedSquares(SquareCollection board, ArrayList<Piece> pieces)
  {
   //turn off all occupied squares
   board.OccupiedBlack.clear();
   board.OccupiedWhite.clear();
   for (Square [] row : board.squares) {
     for (Square s : row) {
       s.OccupiedBlack = false;
       s.OccupiedWhite = false;
     }
   }
   
   for (Square [] row : board.squares) {
     for (Square s : row) { // for each square
       for (Piece pi : pieces) { // Loop over each piece
         if (s.x == pi.x && s.y == pi.y) { // if coords are the same
           if (pi.isBlack && pi.visible) { // check color and visibility and occupy square 
             s.OccupiedBlack = true;
             board.OccupiedBlack.add(s.squarenumber);
           }
           else if (!pi.isBlack && pi.visible) {
             s.OccupiedWhite = true;
             board.OccupiedWhite.add(s.squarenumber);
           }
         }
       }
     }
   }
    
  }

  void UpdateXYIndices(SquareCollection board) {
    XInd = board.GetXIndexMouse(this.x);
    YInd = board.GetXIndexMouse (this.y);
  }
  
  void GetXYChange(SquareCollection board, float mousex, float mousey)
  {
    FinalSquareX = board.GetXIndexMouse(mousex);
    FinalSquareY = board.GetYIndexMouse(mousey);

    XChange = FinalSquareX - InitSquareX;
    YChange = FinalSquareY - InitSquareY;
  }
  
  void ClearAttackedSquares (ArrayList<Square> PieceAttackedWhite, ArrayList<Square> PieceAttackedBlack, boolean isBlack) {
    if (isBlack){
      for (Square s : PieceAttackedWhite) {
          board.AttackedSquaresWhite.remove(s);
          s.AttackedByBlack = false;
        }
        PieceAttackedWhite.clear();
    }
    else {
      for (Square s : PieceAttackedBlack) {
          board.AttackedSquaresBlack.remove(s);
          s.AttackedByWhite = false;
        }
        PieceAttackedBlack.clear();
    }
  }
  
  void UpdateAllPiecesAttackedSquares(SquareCollection board, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops) {
    for (King k : kings) {
      k.UpdateAttackedSquares(board);
    }
    for (Pawn p : pawns) {
      p.UpdateAttackedSquares(board);
    }
    for (Rook r : rooks) {
      r.UpdateAttackedSquares(board);
    }
    for (Bishop b : bishops) {
      b.UpdateAttackedSquares(board);
    }
  }
  
  void UpdateForDiscoveredCheck(King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops) {
    for (Pawn p : pawns) {
      p.KingPutInCheck(kings);
    }
    for (Rook r : rooks) {
      r.KingPutInCheck(kings);
    }
    for (Bishop b : bishops) {
      b.KingPutInCheck(kings);
    }
  }
  
  boolean CheckForCheckmate(SquareCollection board, Rook [] rooks, King [] kings) {
    if (isBlack && kings[0].Checkmate(board, rooks))
      return true;
      
    else if (!isBlack && kings[1].Checkmate(board,rooks))
      return true;
    
    else return false;    
  }
  
  void AttackedSquaresLogging(SquareCollection board)
  {
    ArrayList<Integer> numbers = new ArrayList <Integer>();
    ArrayList<Integer> numbers2 = new ArrayList<Integer>();
    for (Square s : board.AttackedSquaresBlack)
    {
      numbers.add(s.squarenumber);
    }
    for (Square s : board.AttackedSquaresWhite)
    {
      numbers2.add(s.squarenumber);
    }
    
    Collections.sort(numbers);
    Collections.sort(numbers2);
    
    Set<Integer> NumbersNoDupes = new LinkedHashSet<Integer>(numbers);
    Set<Integer> Numbers2NoDupes = new LinkedHashSet<Integer>(numbers2);
    
    System.out.println("black : " + NumbersNoDupes);
    System.out.println("white : " + Numbers2NoDupes); 
  }
  
  boolean RightCaptureColor (boolean PieceIsBlack) {
    //println(BlackIsCaptured + " , " + PieceIsBlack);
    if (BlackIsCaptured && PieceIsBlack)
      return true;
    if (!BlackIsCaptured && !PieceIsBlack)
      return true;
    else return false;
  }
  
  boolean OnAttackedSquare(ArrayList<Square> AttackedSquaresWhite, ArrayList<Square> AttackedSquaresBlack) {
    if (isBlack) {
      for (Square s : AttackedSquaresBlack){
        if (s.x == this.x && s.y == this.y)
          return true;
      }
    }
    else {
      for (Square s : AttackedSquaresWhite) {
        if (s.x == this.x && s.y == this.y)
          return true;
      }
    }
    return false;
  }
  boolean over(int mousex, int mousey) {
    return(mousex >= x && mousex <= x + 60 && mousey >= y && mousey <= y + 60);
  }

  boolean CheckTurnColor(StateChecker StateChecker) {
    if (isBlack == false && StateChecker.WhiteTurn == true)
      return true;
    else if (isBlack == true && StateChecker.WhiteTurn == false)
      return true;
    else return false;
  }
  
  boolean YourKinginCheck(King [] kings) {
    if (isBlack && kings[1].InCheck)
      return true;
    else if (!isBlack && kings[0].InCheck)
      return true;
    else return false;
  }
  
  
  
  
}
