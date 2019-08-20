class Bishop extends Piece {
  PImage BishopImage;
  ArrayList <Square> BishopAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> BishopAttackedSquaresBlack = new ArrayList();  
  
  public Bishop(PImage _BishopImage, boolean _isBlack, float _x, float _y) {
    BishopImage = _BishopImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;   
  }
 
  void draw() {
    if (visible)
      image(BishopImage, x + offsetx, y + offsety, l, l);
  }
  
  void mouseReleased(SquareCollection board, Rook [] rooks, King [] kings, Pawn [] pawns, Bishop [] bishops) {
    if (active && visible) {      
      GetXYChange(board, mouseX, mouseY);
      LockPieceToSquare(board.squares);
      active = false;      
      
      if (Legal(StateChecker, board, kings)) 
      { 
        if (AttackingMove) 
          Capture(pieces);
          
        AttackingMove = false;
        
        StateChecker.FlipColor();
          
        UpdateXYIndices(board);
          
        UpdateAttackedSquares(board);
        
        UpdateAllPiecesAttackedSquares(board, kings, pawns, rooks, bishops);
          
        UpdateOccupiedSquares(board, pieces);
        
        KingPutInCheckAllPieces(board, kings, pawns, rooks, bishops); 
        
     } else {
        this.x = InitXCoord;
        this.y = InitYCoord;
      }
    }
  }
  
  /// TODO copy in ValidMove method from rooks
  void UpdateAttackedSquares(SquareCollection board) {
    Square [][] squares = board.squares;
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
         
    if (isBlack) {    // black bishop 
      boolean StopUpRight = false , StopUpLeft = false, StopDownRight = false, StopDownLeft = false;

      /* clear out old lists */
      ClearAttackedSquares(BishopAttackedSquaresWhite, BishopAttackedSquaresBlack, true);
      
      //Add all squares that bishop attacks
      if (visible) {
        for (int i = 1; i < 8; i++) { 
          
          if (!StopUpRight) {
            try {
              if (squares[CurrentX + i][CurrentY - i].OccupiedWhite || squares[CurrentX + i][CurrentY - i].OccupiedBlack) {
                BishopAttackedSquaresWhite.add(squares[CurrentX + i][CurrentY - i]);
                squares[CurrentX + i][CurrentY - i].AttackedByBlack = true;
                StopUpRight = true;
              }
              else {
                BishopAttackedSquaresWhite.add(squares[CurrentX + i][CurrentY - i]);
                squares[CurrentX + i][CurrentY - i].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopUpRight = true;}
          }
          
          if (!StopUpLeft) {
            try {
              if (squares[CurrentX - i][CurrentY - i].OccupiedWhite || squares[CurrentX - i][CurrentY - i].OccupiedBlack) {
                BishopAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY - i]);
                squares[CurrentX - i][CurrentY - i].AttackedByBlack = true;
                StopUpLeft = true;
              }
              else {
                BishopAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY - i]);
                squares[CurrentX - i][CurrentY - i].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopUpLeft = true;}
          }
          
          if (!StopDownRight) {
            try {
              if (squares[CurrentX + i][CurrentY + i].OccupiedWhite || squares[CurrentX + i][CurrentY + i].OccupiedBlack) {
                BishopAttackedSquaresWhite.add(squares[CurrentX + i][CurrentY + i]);
                squares[CurrentX + i][CurrentY + i].AttackedByBlack = true;
                StopDownRight = true;
              }
              else {
                BishopAttackedSquaresWhite.add(squares[CurrentX + i][CurrentY + i]);
                squares[CurrentX + i][CurrentY + i].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopDownRight = true;}
          }
          
          if (!StopDownLeft) {
            try {
              if (squares[CurrentX - i][CurrentY + i].OccupiedWhite || squares[CurrentX - i][CurrentY + i].OccupiedBlack) {
                BishopAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY + i]);
                squares[CurrentX - i][CurrentY + i].AttackedByBlack = true;
                StopDownLeft = true;
              }
              else {
                BishopAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY + i]);
                squares[CurrentX - 1][CurrentY + 1].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopDownLeft = true;}
          }          
        }
        
        for (Square s : BishopAttackedSquaresWhite) {
            board.AttackedSquaresWhite.add(s);
        }
      }
    }
    
    else //white bishop
    {  
      boolean StopUpRight = false , StopUpLeft = false, StopDownRight = false, StopDownLeft = false;

      /* clear out old lists */
      ClearAttackedSquares(BishopAttackedSquaresWhite, BishopAttackedSquaresBlack, false);
      
      //Add all squares that bishop attacks
      if (visible) {
        for (int i = 1; i < 8; i++) { 
          
          if (!StopUpRight) {
            try {
              if (squares[CurrentX + i][CurrentY - i].OccupiedWhite || squares[CurrentX + i][CurrentY - i].OccupiedBlack) {
                BishopAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY - i]);
                squares[CurrentX + i][CurrentY - i].AttackedByWhite = true;
                StopUpRight = true;
              }
              else {
                BishopAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY - i]);
                squares[CurrentX + i][CurrentY - i].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopUpRight = true;}
          }
          
          if (!StopUpLeft) {
            try {
              if (squares[CurrentX - i][CurrentY - i].OccupiedWhite || squares[CurrentX - i][CurrentY - i].OccupiedBlack) {
                BishopAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY - i]);
                squares[CurrentX - i][CurrentY - i].AttackedByWhite = true;
                StopUpLeft = true;
              }
              else {
                BishopAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY - i]);
                squares[CurrentX - i][CurrentY - i].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopUpLeft = true;}
          }
          
          if (!StopDownRight) {
            try {
              if (squares[CurrentX + i][CurrentY + i].OccupiedWhite || squares[CurrentX + i][CurrentY + i].OccupiedBlack) {
                BishopAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY + i]);
                squares[CurrentX + i][CurrentY + i].AttackedByWhite = true;
                StopDownRight = true;
              }
              else {
                BishopAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY + i]);
                squares[CurrentX + i][CurrentY + i].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopDownRight = true;}
          }
          
          if (!StopDownLeft) {
            try {
              if (squares[CurrentX - i][CurrentY + i].OccupiedWhite || squares[CurrentX - i][CurrentY + i].OccupiedBlack) {
                BishopAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY + i]);
                squares[CurrentX - i][CurrentY + i].AttackedByWhite = true;
                StopDownLeft = true;
              }
              else {
                BishopAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY + i]);
                squares[CurrentX - i][CurrentY + i].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopDownLeft = true;}
          }          
        }
        
        for (Square s : BishopAttackedSquaresBlack) {
            board.AttackedSquaresBlack.add(s);
        }
      }
    }
  }
  
  void KingPutInCheck(King [] kings) { 
   //kings[0] == white king, kings[1] == black king
    if (isBlack) {
      for (Square s : BishopAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          kings[0].InCheck = true;     
          kings[0].AttackedByThesePieces.add(this);
        }
      }
    } else {
      for (Square s : BishopAttackedSquaresBlack) {
        if (kings[1].x == s.x && kings[1].y == s.y) {
          kings[1].InCheck = true;
          kings[1].AttackedByThesePieces.add(this);
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
            
      ///////// bishop attacking from above right king  /////////////
      
      ///////// rook attacking from ABOVE king  /////////////
      
      ///////// rook attacking from LEFT of king  /////////////
      
      ///////// rook attacking from RIGHT of king  /////////////
      
        
  }
  
  boolean ValidMove(SquareCollection board, int SquareXInd, int SquareYInd) {
    int XDiff = SquareXInd - this.XInd;
    int YDiff = SquareYInd - this.YInd;
    
    if (XDiff < 0 && YDiff < 0) { //Bishop is below right of square
      for (int y = this.YInd - 1, x = this.XInd - 1; y > SquareYInd; y--, x--) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff > 0 && YDiff < 0) { //Bishop is below left of square
      for (int y = this.YInd - 1, x = this.XInd + 1; y > SquareYInd; y--, x++) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff > 0 && YDiff > 0) { //Bishop is above left of square
      for (int y = this.YInd + 1, x = this.XInd + 1; x < SquareXInd; y++, x++) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
    if (XDiff < 0 && YDiff > 0) { //Bishop is above right of square
      for (int y = this.YInd + 1, x = this.XInd - 1; x > SquareXInd; y++, x--) {
        if (board.squares[x][y].OccupiedWhite || board.squares[x][y].OccupiedBlack)
          return false;
      }
      return true;
    }
        
    return false;
  }
  
  boolean CheckBasicLegalMoves(SquareCollection board) {
    for (int row = 0; row < board.squares.length; row++) {
      for (int col = 0; col < board.squares[row].length; col++) {
        if (board.squares[row][col].active) { // this is the square the mouse is released on
        
          if ((XChange > 0 && YChange < 0)) { // If bishop is moving up right
            for (int i = 0; i < abs(YChange); i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row - i][col + i].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row - i][col + i].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row - i][col + i].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row - i][col + i].x;
                CapturedOnY = (int) board.squares[row - i][col + i].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row - i][col + i].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row - i][col + i].x;
                CapturedOnY = (int) board.squares[row - i][col + i].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
          if ((XChange < 0 && YChange < 0)) { // If rook is moving up left
            for (int i = 0; i < abs(YChange); i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row + i][col + i].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row + i][col + i].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row + i][col + i].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row + i][col + i].x;
                CapturedOnY = (int) board.squares[row + i][col + i].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row + i][col + i].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row + i][col + i].x;
                CapturedOnY = (int) board.squares[row + i][col + i].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
         if ((XChange > 0 && YChange > 0)) { // If rook is moving down right
            for (int i = 0; i < XChange; i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row - i][col - i].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row - i][col - i].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row - i][col - i].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row - i][col - i].x;
                CapturedOnY = (int) board.squares[row - i][col - i].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row - i][col - i].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row - i][col - i].x;
                CapturedOnY = (int) board.squares[row - i][col - i].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
          if ((XChange < 0 && YChange > 0)) { // If rook is moving down left
            for (int i = 0; i < abs(XChange); i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row + i][col - i].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row + i][col - i].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row + i][col - i].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row + i][col - i].x;
                CapturedOnY = (int) board.squares[row + i][col - i].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row + i][col - i].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row + i][col - i].x;
                CapturedOnY = (int) board.squares[row + i][col - i].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
        }
      }
    }
    return false;
  }
  
   boolean Legal(StateChecker StateChecker, SquareCollection board, King [] kings) { 
    if (CheckBasicLegalMoves(board) && CheckTurnColor(StateChecker)) {
      if (YourKingInCheck(kings)) {         
        if (AttackingTheAttacker(kings) || BlockingMove(kings)) {
          return true;      
        }
        else return false;
      }
      
      return true; // return true if king is not in check
    } else {

      println(CheckBasicLegalMoves(board) + " , " + CheckTurnColor(StateChecker));
      return false;
    }
  }
}
