
class Rook extends Piece {
  PImage RookImage;
  ArrayList <Square> RookAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> RookAttackedSquaresBlack = new ArrayList();
  boolean StopUpPin = false, StopDownPin = false, StopRightPin = false, StopLeftPin = false;
  boolean StopUp = false , StopDown = false, StopRight = false, StopLeft = false;   
  
  public Rook(PImage _RookImage, boolean _isBlack, float _x, float _y) {
    RookImage = _RookImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;   
  }
 
  void draw() {
    if (visible)
      image(RookImage, x + offsetx, y + offsety, l, l);
  }
  
  void mouseReleased(SquareCollection board, ArrayList<Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, ArrayList <Queen> queens, Knight [] knights) {
    if (active && visible) {      
      GetXYChange(board, mouseX, mouseY);
      LockPieceToSquare(board.squares);
      active = false;
      
      if (!kings[0].InCheck && !kings[1].InCheck)
        CheckIfPinned(board, pieces, rooks, bishops, queens);
      
      if (Legal(board, pieces, kings, pawns, rooks, bishops)) 
      {  
        if (AttackingMove) 
          Capture(pieces);
          
        AttackingMove = false;
        
        StateChecker.FlipColor();
          
        UpdateXYIndices(board);
        
        UpdateOccupiedSquares(board, pieces);
        UpdateOccupiedSquaresPin(board,pieces);
        
        UpdateAllPiecesAttackedSquares(board, kings, pawns, rooks, bishops, queens, knights);
        
        KingPutInCheckAllPieces(board, kings, pawns, rooks, bishops, queens, knights);
        
        if (!kings[0].InCheck && !kings[1].InCheck)
          UpdatePinnedSquares(board);
                                     
     } else {
        this.x = InitXCoord;
        this.y = InitYCoord;
      }
    }
  }
  
  String toString(SquareCollection board) {
    int snumber = 0;
    for (Square [] row : board.squares) {
      for (Square s : row) {
        if (s.x == this.x && s.y == this.y) 
          snumber = s.squarenumber;
      }
    }
    return ("Rook " + String.valueOf(snumber));
  }
  
  void UpdateAttackedSquares(SquareCollection board) {
        
    /* clear out old lists */
    ClearAttackedSquares(RookAttackedSquaresWhite, RookAttackedSquaresBlack, isBlack);
    StopUp = false ; StopDown = false; StopRight = false; StopLeft = false;   
    
    //Add all squares that rook attacks
    if (visible) {
      for (int i = 1; i < 8; i++) { 
        if (!StopRight) {
          AttackedSqAlg(board.squares, 1, 0, i);
        }
        if (!StopLeft) {
          AttackedSqAlg(board.squares, -1, 0, i);
        }
        if (!StopDown) {
          AttackedSqAlg(board.squares, 0, 1, i);
        }
        if (!StopUp) {
          AttackedSqAlg(board.squares, 0, -1, i);
        }          
      }
      
      if (isBlack) {
        for (Square s : RookAttackedSquaresWhite) {
          board.AttackedSquaresWhite.add(s);
        }
      }
      else {
        for (Square s : RookAttackedSquaresBlack) {
          board.AttackedSquaresBlack.add(s);
        }
      } 
        
    }    
  }
  
  void AttackedSqAlg(Square [][] squares, int XPlus, int YPlus, int i) {
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
    
    if (!isBlack) {
      try {
        if (squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedWhite || squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedBlack) {
          RookAttackedSquaresBlack.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByWhite = true;
          
          AssignStopDirection(XPlus,YPlus);
        }
        else {
          RookAttackedSquaresBlack.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByWhite = true;
        }
      } catch (IndexOutOfBoundsException e) {
          AssignStopDirection(XPlus,YPlus);
        }
    }
    else {
      try {
        if (squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedWhite || squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedBlack) {
          RookAttackedSquaresWhite.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByBlack = true;
          AssignStopDirection(XPlus,YPlus);
        }
        else {
          RookAttackedSquaresWhite.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByBlack = true;
        }
      } catch (IndexOutOfBoundsException e) {
          AssignStopDirection(XPlus,YPlus);
        }
    }
  }
  
  void AssignStopDirection(int XPlus, int YPlus) {
    if (XPlus == 1 & YPlus == 0)
      StopRight = true;
    else if (XPlus == -1 & YPlus == 0)
      StopLeft = true;
    else if (XPlus == 0 & YPlus == 1)
      StopDown = true;
    else if (XPlus == 0 & YPlus == -1)
      StopUp = true;
  }
  
  void UpdatePinnedSquares(SquareCollection board) {    
    
    StopUpPin = false; StopDownPin = false; StopRightPin = false; StopLeftPin = false;
    
    if (visible) {
        for (int i = 1; i < 8; i++) {
          if (!StopRightPin)
            PinnedSqAlg(board, i, 1, 0);
          if (!StopLeftPin)
            PinnedSqAlg(board, i, -1, 0);
          if (!StopDownPin)
            PinnedSqAlg(board, i, 0, 1);
          if (!StopUpPin)
            PinnedSqAlg(board, i, 0, -1);
        }          
     }                   
  }
  
   void PinnedSqAlg(SquareCollection board, int i, int XPlus, int YPlus) {
    
    // Method that runs before a piece's move is declared legal
    // Loops through all squares it attacks:
      // if it sees a king, a piece in pinned
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
    
    if (isBlack) {
      try {
        if (board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedWhitePin || 
            board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedBlackPin) { 
          
          if (XPlus == 1 & YPlus == 0)
            StopRightPin = true;
          if (XPlus == -1 & YPlus == 0)
            StopLeftPin = true;
          if (XPlus == 0 & YPlus == 1)
            StopDownPin = true;
          if (XPlus == 0 & YPlus == -1)
            StopUpPin = true;
            
          return;
        }
        
        if (board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedWhiteKing) {
          board.PinnedWhitePiece = true;
          println("pinned pc");
          return;
        }
        
                                                          
      }
      catch (IndexOutOfBoundsException e) {return;}
    }
    else {
      try { 
        if ((board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedWhitePin || 
            board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedBlackPin)) {

          if (XPlus == 1 & YPlus == 0)
            StopRightPin = true;
          if (XPlus == -1 & YPlus == 0)
            StopLeftPin = true;
          if (XPlus == 0 & YPlus == 1)
            StopDownPin = true;
          if (XPlus == 0 & YPlus == -1)
            StopUpPin = true;
            
          return;
        }
        
        else if (board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedBlackKing) {
          board.PinnedBlackPiece = true;
          println("pinned pc"  );
          return;
        }
                                                          
      }
      catch (IndexOutOfBoundsException e) {return;}
    }
    
  }
    
  void KingPutInCheck(King [] kings, SquareCollection board) { 
   //kings[0] == white king, kings[1] == black king
    if (isBlack) {
      for (Square s : RookAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          kings[0].InCheck = true;     
          kings[0].AttackedByThesePieces.add(this);
          
          CalcSquaresBetweenThisAndKing(kings, board);
        }
      }
    } else {
      for (Square s : RookAttackedSquaresBlack) {
        if (kings[1].x == s.x && kings[1].y == s.y) {
          kings[1].InCheck = true;
          kings[1].AttackedByThesePieces.add(this);
          
          CalcSquaresBetweenThisAndKing(kings, board);
        }
      }
    }
        
  }
  
  void CalcSquaresBetweenThisAndKing(King [] kings, SquareCollection board) {
    int XDiff, YDiff;                        // holds diff in x between attacker and king
    King EnemyKing = new King();             // holds diff in y between attacker and king
    
    kings[0].BetweenAttackerAndKing.clear(); // clear out old list for white king
    kings[1].BetweenAttackerAndKing.clear(); // clear out old list for black king
    
    if (isBlack) 
     EnemyKing = kings[0];
    else
     EnemyKing = kings[1];
     
     XDiff = this.XInd - EnemyKing.XInd;
     YDiff = this.YInd - EnemyKing.YInd; 
            
      ///////// rook attacking from BELOW king  /////////////
      if (YDiff > 0) {                   
        for (int y = EnemyKing.YInd + 1; y < this.YInd; y++) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[this.XInd][y]); // add this square to white king's squares
        }
      }
      ///////// rook attacking from ABOVE king  /////////////
      if (YDiff < 0) {                   
        for (int y = EnemyKing.YInd - 1 ; y > this.YInd; y--) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[this.XInd][y]); // add this square to white king's squares
        }
      }
      ///////// rook attacking from LEFT of king  /////////////
      if (XDiff < 0) {                   
        for (int x = EnemyKing.XInd - 1; x > this.XInd; x--) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][this.YInd]); // add this square to white king's squares
        }
      }
      ///////// rook attacking from RIGHT of king  /////////////
      if (XDiff > 0) {                   
        for (int x = EnemyKing.XInd + 1; x < this.XInd; x++) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][this.YInd]); // add this square to white king's squares
        }
      }
        
  }
  
  void CastleMove(King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, ArrayList <Queen> queens) {
    
    // Move Rook
    if (x == 0)
      x += 180;
      
    else if (x == 420)
      x -= 120;
    
    // Follow through with normal move happenings for the rook
    UpdateXYIndices(board);
        
    for (Rook r : rooks) {
      r.UpdateAttackedSquares(board);
    }
    for (Pawn p : pawns) {
      p.UpdateAttackedSquares(board);
    }
    for (Bishop b : bishops) {
      b.UpdateAttackedSquares(board);
    }
    for (Queen q : queens) {
      q.UpdateAttackedSquares(board);
    }
    
    FirstMove = false;
    
    UpdateOccupiedSquares(board, pieces);
    //OnAttackedSquare(board.AttackedSquaresWhite, board.AttackedSquaresBlack);
    
    KingPutInCheck(kings, board);
      
    if (CheckForCheckmate(board, rooks, kings, bishops, queens))
      println("mate");
  }
  

  boolean CheckBasicLegalMoves(SquareCollection board) {
    for (int row = 0; row < board.squares.length; row++) {
      for (int col = 0; col < board.squares[row].length; col++) {
        if (board.squares[row][col].active) { // this is the square the mouse is released on
        
          if ((XChange == 0 && YChange < 0))  // If rook is moving up
            return BasicLegalMovesAlg(row, col, 0, 1, YChange);
          
          if ((XChange == 0 && YChange > 0))  // If rook is moving down
            return BasicLegalMovesAlg(row, col, 0, -1, YChange);
                    
         if ((XChange > 0 && YChange == 0))  // If rook is moving right
            return BasicLegalMovesAlg(row, col, -1, 0, XChange);
                     
          if ((XChange < 0 && YChange == 0))  // If rook is moving left
            return BasicLegalMovesAlg(row, col, 1, 0, XChange);                   
        }
      }
    }
    return false;
  }
  
  boolean BasicLegalMovesAlg (int row, int col, int XPlus, int YPlus, int delta) {
    for (int i = 0; i < abs(delta); i++) { // for each square that it moved
      // check if that square was occupied
      if (board.squares[row + (i*XPlus)][col + (i*YPlus)].OccupiedBlack && isBlack) //occupied black and black piece
        return false;
      if (board.squares[row + (i*XPlus)][col + (i*YPlus)].OccupiedWhite && !isBlack) //occupied white and white piece
        return false;
      if (board.squares[row + (i*XPlus)][col + (i*YPlus)].OccupiedWhite && isBlack) { // capture of white
        AttackingMove = true;
        CapturedOnX = (int) board.squares[row + (i*XPlus)][col + (i*YPlus)].x;
        CapturedOnY = (int) board.squares[row + (i*XPlus)][col + (i*YPlus)].y;
        BlackIsCaptured = false;
        UpdateAttackedSquares(board);
        return true;
      }
      if (board.squares[row + (i*XPlus)][col + (i*YPlus)].OccupiedBlack && !isBlack) { // capture of black
        AttackingMove = true;
        CapturedOnX = (int) board.squares[row + (i*XPlus)][col + (i*YPlus)].x;
        CapturedOnY = (int) board.squares[row + (i*XPlus)][col + (i*YPlus)].y;
        BlackIsCaptured = true;
        UpdateAttackedSquares(board);
        return true;
      }              
    }
    
    return true;
  }
  
  boolean ValidMove(SquareCollection board, int SquareXInd, int SquareYInd) {
    int XDiff = SquareXInd - this.XInd;
    int YDiff = SquareYInd - this.YInd;
    
    if (XDiff == 0 && YDiff > 0) { //Rook is above square
      for (int i = this.YInd + 1; i < SquareYInd; i++) {
        if (board.squares[SquareXInd][i].OccupiedWhite || board.squares[SquareXInd][i].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff == 0 && YDiff < 0) { //Rook is below square
      for (int i = this.YInd - 1; i > SquareYInd; i--) {
        if (board.squares[SquareXInd][i].OccupiedWhite || board.squares[SquareXInd][i].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff > 0 && YDiff == 0) { //Rook is left of square
      for (int i = this.XInd + 1; i < SquareXInd; i++) {
        if (board.squares[i][SquareYInd].OccupiedWhite || board.squares[i][SquareYInd].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff < 0 && YDiff == 0) { //Rook is right of square
      for (int i = this.XInd - 1; i > SquareXInd; i--) {
        if (board.squares[i][SquareYInd].OccupiedWhite || board.squares[i][SquareYInd].OccupiedBlack)
          return false;
      }
      return true;
    }
        
    return false;
  }
   
   boolean Legal(SquareCollection board, ArrayList<Piece> Pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops) { 

    if (CheckBasicLegalMoves(board) && CheckTurnColor(StateChecker)) {
      if (YourKingInCheck(kings)) { 
        if (AttackingTheAttacker(kings) || BlockingMove(kings))
          return true;       
        else return false;
      }
      
      else if (!board.PinnedPieceMoved(isBlack))
        return true;           // return true if king is not in check and not pinned piece moved
      else return false;
      
    } else {
      println(CheckBasicLegalMoves(board) + " , " + CheckTurnColor(StateChecker));
      return false;
    }
  }
}
