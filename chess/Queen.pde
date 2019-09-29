class Queen extends Piece {
  PImage QueenImage;
  ArrayList <Square> QueenAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> QueenAttackedSquaresBlack = new ArrayList();
  
  boolean StopUpPin = false, StopDownPin = false, StopRightPin = false, StopLeftPin = false;
  boolean StopUpRightPin = false, StopDownRightPin = false, StopDownLeftPin = false, StopUpLeftPin = false;
  
  boolean StopUp = false , StopDown = false, StopRight = false, StopLeft = false;
  boolean StopDownRight = false, StopDownLeft = false, StopUpRight = false, StopUpLeft = false;
  
  public Queen(PImage _QueenImage, boolean _isBlack, float _x, float _y) {
    QueenImage = _QueenImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;   
  }
 
  void draw() {
    if (visible)
      image(QueenImage, x + offsetx, y + offsety, l, l);
  }
  
  void mouseReleased(SquareCollection board, StateChecker sc, ArrayList<Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, ArrayList <Queen> queens, Knight [] knights) {
    if (active && visible) {      
      GetXYChange(board, mouseX, mouseY);
      LockPieceToSquare(board.squares);
      active = false;
      
      if (!kings[0].InCheck && !kings[1].InCheck)
        CheckIfPinned(board, pieces, rooks, bishops, queens);
      
      if (Legal(board, kings)) 
      {  
       if (AttackingMove) 
          Capture(pieces);
          
        AttackingMove = false;
        
        sc.FlipColor();
          
        UpdateXYIndices(board);
        
        UpdateOccupiedSquares(board, pieces);
        UpdateOccupiedSquaresPin(board,pieces);
        
        UpdateAllPiecesAttackedSquares(board, kings, pawns, rooks, bishops, queens, knights);
        
        KingPutInCheckAllPieces(board, kings, pawns, rooks, bishops, queens, knights);
        
        if (!kings[0].InCheck && !kings[1].InCheck)
          UpdatePinnedSquares(board);
        
        if (CheckForCheckmate(board, rooks, kings, bishops, queens))
          println("mate");
       else println("!mate");
        
     } else {
        this.x = InitXCoord;
        this.y = InitYCoord;
      }
    }
  }
  
  void UpdateAttackedSquares(SquareCollection board) {
    
    /* clear out old lists */
    ClearAttackedSquares(QueenAttackedSquaresWhite, QueenAttackedSquaresBlack, isBlack);
    StopUp = false ; StopDown = false; StopRight = false; StopLeft = false;
    StopDownRight = false; StopDownLeft = false; StopUpRight = false; StopUpLeft = false;
 
    //Add all squares that rook attacks
    if (visible) {
      for (int i = 1; i < 8; i++) { 
        if (!StopUpRight) {
          AttackedSqAlg(board.squares, 1, -1, i);
        }
        if (!StopDownRight) {
          AttackedSqAlg(board.squares, 1, 1, i);
        }
        if (!StopDownLeft) {
          AttackedSqAlg(board.squares, -1, 1, i);
        }
        if (!StopUpLeft) {
          AttackedSqAlg(board.squares, -1, -1, i);
        }  
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
        for (Square s : QueenAttackedSquaresWhite) {
          board.AttackedSquaresWhite.add(s);
        }
      }
      else {
        for (Square s : QueenAttackedSquaresBlack) {
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
          QueenAttackedSquaresBlack.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByWhite = true;
          
          AssignStopDirection(XPlus, YPlus);
        }
        else {
          QueenAttackedSquaresBlack.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByWhite = true;
        }
      } catch (IndexOutOfBoundsException e) {
          AssignStopDirection(XPlus, YPlus);
        }
    }
    else {
      try {
        if (squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedWhite || squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedBlack) {
          QueenAttackedSquaresWhite.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByBlack = true;
          AssignStopDirection(XPlus, YPlus);
        }
        else {
          QueenAttackedSquaresWhite.add(squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)]);
          squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].AttackedByBlack = true;
        }
      } catch (IndexOutOfBoundsException e) {
          AssignStopDirection(XPlus, YPlus);
        }
    }
  }
  
  void AssignStopDirection (int XPlus, int YPlus) { 
    if (XPlus == 1 & YPlus == 1)
      StopDownRight = true;
    else if (XPlus == -1 & YPlus == 1)
      StopDownLeft = true;
    else if (XPlus == 1 & YPlus == -1)
      StopUpRight = true;
    else if (XPlus == -1 & YPlus == -1)
      StopUpLeft = true;
    else if (XPlus == 1 & YPlus == 0)
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
    StopUpRightPin = false; StopDownRightPin = false; StopDownLeftPin = false; StopUpLeftPin = false;
    
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
          if (!StopDownRightPin)
            PinnedSqAlg(board, i, 1, 1);
          if (!StopDownLeftPin)
            PinnedSqAlg(board, i, -1, 1);
          if (!StopUpRightPin)
            PinnedSqAlg(board, i, 1, -1);
          if (!StopUpLeftPin)
            PinnedSqAlg(board, i, -1, -1);          
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
          else if (XPlus == -1 & YPlus == 0)
            StopLeftPin = true;
          else if (XPlus == 0 & YPlus == 1)
            StopDownPin = true;
          else if (XPlus == 0 & YPlus == -1)
            StopUpPin = true;
          else if (XPlus == 1 & YPlus == 1)
            StopDownRightPin = true;
          else if (XPlus == -1 & YPlus == 1)
            StopDownLeftPin = true;
          else if (XPlus == 1 & YPlus == -1)
            StopUpRightPin = true;
          else if (XPlus == -1 & YPlus == -1)
            StopUpLeftPin = true;
            
          return;
        }
        
        else if (board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedWhiteKing) {
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
          else if (XPlus == -1 & YPlus == 0)
            StopLeftPin = true;
          else if (XPlus == 0 & YPlus == 1)
            StopDownPin = true;
          else if (XPlus == 0 & YPlus == -1)
            StopUpPin = true;
          else if (XPlus == 1 & YPlus == 1)
            StopDownRightPin = true;
          else if (XPlus == -1 & YPlus == 1)
            StopDownLeftPin = true;
          else if (XPlus == 1 & YPlus == -1)
            StopUpRightPin = true;
          else if (XPlus == -1 & YPlus == -1)
            StopUpLeftPin = true;
          return;
        }
        
        else if (board.squares[CurrentX + (i * XPlus)][CurrentY + (i * YPlus)].OccupiedBlackKing) {
          board.PinnedBlackPiece = true;
          println("pinned pc q "  );
          return;
        }
                                                          
      }
      catch (IndexOutOfBoundsException e) {return;}
    }
    
  }
  
  void KingPutInCheck(King [] kings, SquareCollection board) { 
   //kings[0] == white king, kings[1] == black king
    if (isBlack) {
      for (Square s : QueenAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          kings[0].InCheck = true;     
          kings[0].AttackedByThesePieces.add(this);
          
          CalcSquaresBetweenThisAndKing(kings, board);
        }
      }
    } else {
      for (Square s : QueenAttackedSquaresBlack) {
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
            
      ///////// queen attacking from BELOW king  /////////////
      if (YDiff > 0 && XDiff == 0) {                   
        for (int y = EnemyKing.YInd + 1; y < this.YInd; y++) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[this.XInd][y]); // add this square to white king's squares
        }
      }
      ///////// queen attacking from ABOVE king  /////////////
      if (YDiff < 0 && XDiff == 0) {                   
        for (int y = EnemyKing.YInd - 1 ; y > this.YInd; y--) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[this.XInd][y]); // add this square to white king's squares
        }
      }
      ///////// queen attacking from LEFT of king  /////////////
      if (XDiff < 0 && YDiff == 0) {                   
        for (int x = EnemyKing.XInd - 1; x > this.XInd; x--) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][this.YInd]); // add this square to white king's squares
        }
      }
      ///////// queen attacking from RIGHT of king  /////////////
      if (XDiff > 0 && YDiff == 0) {                   
        for (int x = EnemyKing.XInd + 1; x < this.XInd; x++) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][this.YInd]); // add this square to white king's squares
        }
      }
      
      ///////// queen attacking from above left of king  /////////////
      if (YDiff < 0 && XDiff < 0) {                   
        for (int y = EnemyKing.YInd - 1, x = EnemyKing.XInd - 1; y > this.YInd; y--, x--) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][y]); // add this square to white king's squares
        }
      }
      ///////// queen attacking from above right of king  /////////////
      if (YDiff < 0 && XDiff > 0) {                   
        for (int y = EnemyKing.YInd - 1, x = EnemyKing.XInd + 1; y > this.YInd; y--, x++) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][y]); // add this square to white king's squares
        }
      }
      ///////// queen attacking from below left of king of king  /////////////
      if (YDiff > 0 && XDiff < 0) {                   
        for (int y = EnemyKing.YInd + 1, x = EnemyKing.XInd - 1; y < this.YInd; y++, x--) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][y]); // add this square to white king's squares
        }
      }
      ///////// queen attacking from below right of king  /////////////
       if (YDiff > 0 && XDiff > 0) {                   
        for (int y = EnemyKing.YInd + 1, x = EnemyKing.XInd + 1; y < this.YInd; y++, x++) {
            EnemyKing.BetweenAttackerAndKing.add(board.squares[x][y]); // add this square to white king's squares
        }
      }
        
  }
  
   boolean CheckBasicLegalMoves(SquareCollection board) {
    for (int row = 0; row < board.squares.length; row++) {
      for (int col = 0; col < board.squares[row].length; col++) {
        if (board.squares[row][col].active) { // this is the square the mouse is released on
        
          if ((XChange == 0 && YChange < 0))  // If queen is moving up
            return BasicLegalMovesAlg(row, col, 0, 1, YChange); 
            
          if ((XChange == 0 && YChange > 0))  // If queen is moving down
            return BasicLegalMovesAlg(row, col, 0, -1, YChange); 
            
         if ((XChange > 0 && YChange == 0))  // If queen is moving right
            return BasicLegalMovesAlg(row, col, -1, 0, XChange); 
            
          if ((XChange < 0 && YChange == 0))  // If queen is moving left
            return BasicLegalMovesAlg(row, col, 1, 0, XChange); 
            
          if ((XChange > 0 && YChange < 0))  // If queen is moving up right
            return BasicLegalMovesAlg(row, col, -1, 1, YChange); 
            
          if ((XChange < 0 && YChange < 0))  // If queen is moving up left
            return BasicLegalMovesAlg(row, col, 1, 1, YChange);  
            
         if ((XChange > 0 && YChange > 0))  // If queen is moving down right
            return BasicLegalMovesAlg(row, col, -1, -1, XChange); 
            
          if ((XChange < 0 && YChange > 0))  // If queen is moving down left
            return BasicLegalMovesAlg(row, col, 1, -1, XChange);
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
    
    if (XDiff == 0 && YDiff > 0) { //Queen is above square
      for (int i = this.YInd + 1; i < SquareYInd; i++) {
        if (board.squares[SquareXInd][i].OccupiedWhite || board.squares[SquareXInd][i].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff == 0 && YDiff < 0) { //Queen is below square
      for (int i = this.YInd - 1; i > SquareYInd; i--) {
        if (board.squares[SquareXInd][i].OccupiedWhite || board.squares[SquareXInd][i].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff > 0 && YDiff == 0) { //Queen is left of square
      for (int i = this.XInd + 1; i < SquareXInd; i++) {
        if (board.squares[i][SquareYInd].OccupiedWhite || board.squares[i][SquareYInd].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff < 0 && YDiff == 0) { //Queen is right of square
      for (int i = this.XInd - 1; i > SquareXInd; i--) {
        if (board.squares[i][SquareYInd].OccupiedWhite || board.squares[i][SquareYInd].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff < 0 && YDiff < 0) { //Queen is below right of square
      for (int y = this.YInd - 1, x = this.XInd - 1; y > SquareYInd; y--, x--) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff > 0 && YDiff < 0) { //Queen is below left of square
      for (int y = this.YInd - 1, x = this.XInd + 1; y > SquareYInd; y--, x++) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff > 0 && YDiff > 0) { //Queen is above left of square
      for (int y = this.YInd + 1, x = this.XInd + 1; x < SquareXInd; y++, x++) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff < 0 && YDiff > 0) { //Queen is above right of square
      for (int y = this.YInd + 1, x = this.XInd - 1; x > SquareXInd; y++, x--) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
        
    return false;
  }
  
  boolean Legal(SquareCollection board, King [] kings) { 
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
      
      return false;
    }
  }
}
