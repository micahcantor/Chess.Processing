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
  
  int InitSquareNum, PostSquareNum;

  
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
 
  void UpdateOccupiedSquares(SquareCollection board, ArrayList<Piece> pieces) {
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
     for (Square s : row) {                 // for each square
       for (Piece pi : pieces) {            // Loop over each piece
         if (s.x == pi.x && s.y == pi.y) {  // if coords are the same
           if (pi.isBlack && pi.visible) {              
               s.OccupiedBlack = true;
               board.OccupiedBlack.add(s.squarenumber);
           }
           else if (!pi.isBlack && pi.visible) {    // cant be a king          
               s.OccupiedWhite = true;
               board.OccupiedWhite.add(s.squarenumber);
             
           }
         }
       }
     }
   }    
  }
  
  void UpdateOccupiedSquaresPin(SquareCollection board, ArrayList<Piece> pieces) {
   //turn off all occupied squares

   for (Square [] row : board.squares) {
     for (Square s : row) {
       s.OccupiedBlackPin = false;
       s.OccupiedWhitePin = false;
     }
   }
   board.OccupiedBlackPin.clear();
   board.OccupiedWhitePin.clear();
   
   for (Square [] row : board.squares) {
     for (Square s : row) {                 // for each square
       for (Piece pi : pieces) {            // Loop over each piece
         if (s.x == pi.x && s.y == pi.y) {  // if coords are the same
           if (pi.isBlack && pi.visible && !pi.getClass().getSimpleName().equals("King")) {  // check color and visibility and occupy square            
               s.OccupiedBlackPin = true;
               board.OccupiedBlackPin.add(s.squarenumber);
           }
           else if (!pi.isBlack && pi.visible && !pi.getClass().getSimpleName().equals("King")) {             
               s.OccupiedWhitePin = true;
               board.OccupiedWhitePin.add(s.squarenumber);
             
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
  
  void UpdateAllPiecesAttackedSquares(SquareCollection board, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, Queen [] queens, Knight [] knights) {
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
    for (Queen q : queens) {
      q.UpdateAttackedSquares(board);
    }
    for (Knight kn : knights) {
      kn.UpdateAttackedSquares(board);
    }
  }
  
  void KingPutInCheckAllPieces(SquareCollection board, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, Queen [] queens, Knight [] knights) {
    kings[0].InCheck = false; kings[1].InCheck = false;                             // turn off checks
    kings[0].AttackedByThesePieces.clear(); kings[1].AttackedByThesePieces.clear(); // clear out lists
    
    for (Pawn p : pawns) {
      p.KingPutInCheck(kings);
    }
    for (Rook r : rooks) {
      r.KingPutInCheck(kings, board);
    }
    for (Bishop b : bishops) {
      b.KingPutInCheck(kings, board);
    }
    for (Queen q : queens) {
      q.KingPutInCheck(kings, board);
    }
    for (Knight kn : knights) {
      kn.KingPutInCheck(kings);
    }
  }
  
  void ValidMoveAllPieces(Rook [] rooks, Bishop [] bishops, Queen [] queens, King AttackedKing, int x, int y) {
    for (Rook r : rooks) {
      if (isBlack) {
        if (r.isBlack) {
          if (r.ValidMove(board, x, y))
            AttackedKing.UnblockableAttackBlack = false;
        }
        else {
          if (r.ValidMove(board, x, y))
            AttackedKing.UnblockableAttackWhite = false;
        }
      }
    }
    for (Bishop b : bishops) {
      if (isBlack) {
        if (b.isBlack) {
          if (b.ValidMove(board, x, y))
            AttackedKing.UnblockableAttackBlack = false;
        }
      }
      else {
        if (b.ValidMove(board, x, y))
            AttackedKing.UnblockableAttackWhite = false;
      }
    }
    for (Queen q : queens) {
      if (isBlack) {
        if (q.isBlack) {
          if (q.ValidMove(board, x, y))
            AttackedKing.UnblockableAttackBlack = false;
        }
        else {
          if (q.ValidMove(board, x, y))
            AttackedKing.UnblockableAttackWhite = false;
        }
      }
    }
  }
  
  boolean CheckForCheckmate(SquareCollection board, Rook [] rooks, King [] kings, Bishop [] bishops, Queen [] queens) {
    if (isBlack && kings[0].Checkmate(board, rooks, bishops, queens)) {
      println("white checkmate");
      return true;
    }
      
    else if (!isBlack && kings[1].Checkmate(board,rooks, bishops, queens)) {
      println("black checkmate");
      return true;
    }
    
    else return false;    
  }
  
  void CheckIfPinned(SquareCollection board, ArrayList <Piece> pieces, Rook [] rooks, Bishop [] bishops, Queen [] queens) {
    board.PinnedBlackPiece = false;
    board.PinnedWhitePiece = false;
      
    UpdateXYIndices(board);        
    UpdateOccupiedSquaresPin(board, pieces);
        
    for (Rook r : rooks) {
      r.UpdatePinnedSquares(board);
    }
    for (Bishop b : bishops) {
      b.UpdatePinnedSquares(board);
    }   
    for (Queen q : queens) {
      q.UpdatePinnedSquares(board);
    }
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
    
    //System.out.println("Attacked for black : " + NumbersNoDupes);
    System.out.println("Attacked for white : " + Numbers2NoDupes); 
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
  
  boolean YourKingInCheck(King [] kings) {
    if (isBlack && kings[1].InCheck)
      return true;
    else if (!isBlack && kings[0].InCheck)
      return true;
    else return false;
  }
  
  boolean AttackingTheAttacker(King [] kings) {
    // if a king is attacked by more than one piece the only legal move is by a king
    if (kings[1].AttackedByThesePieces.size() > 1
     || kings[0].AttackedByThesePieces.size() > 1) {
         return false;
     }
    
    // attacking the attacker for black
    if (isBlack) {
      if (this.x == kings[1].AttackedByThesePieces.get(0).x 
       && this.y == kings[1].AttackedByThesePieces.get(0).y)  // if coords are equal to coords of attacker
         return true;       
    }
    
    // attacking the attacker for white
    else if (!isBlack) {
      if (this.x == kings[0].AttackedByThesePieces.get(0).x 
       && this.y == kings[0].AttackedByThesePieces.get(0).y)  // if coords are equal to coords of attacker
         return true;
    }     
     
     return false;
  }
  
  boolean BlockingMove(King [] kings) {
    if (isBlack) {
      for (Square s : kings[1].BetweenAttackerAndKing) {
        if (this.x == s.x && this.y == s.y) 
          return true;
      }
    }
    else {
      for (Square s : kings[0].BetweenAttackerAndKing) {
        if (this.x == s.x && this.y == s.y) 
          return true;
      }
    }
    
    return false;
  }
  
  
}
