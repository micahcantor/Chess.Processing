
class Rook extends Piece {
  PImage RookImage;
  ArrayList <Square> RookAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> RookAttackedSquaresBlack = new ArrayList();  
  
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
  
  void mouseReleased(SquareCollection board, Rook [] rooks, King [] kings, Pawn [] pawns, Bishop [] bishops) {
    if (active && visible) {      
      GetXYChange(board, mouseX, mouseY);
      LockPieceToSquare(board.squares);
      active = false;      
      
      if (Legal(StateChecker, board, kings)) 
      {  
        UpdateXYIndices(board);
        
        if (AttackingMove) 
          Capture(pieces);
               
        UpdateAllPiecesAttackedSquares(board, kings, pawns, rooks, bishops);
        
        FirstMove = false;
        StateChecker.FlipColor();
        
        UpdateOccupiedSquares(board, pieces);
        
        AttackedSquaresLogging(board);
        KingPutInCheck(kings);
        
        AttackingMove = false;
      
       if (CheckForCheckmate(board, rooks, kings))
          println("mate");
      
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
    Square [][] squares = board.squares;
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
         
    if (isBlack) {    // black rook 
      boolean StopUp = false , StopDown = false, StopRight = false, StopLeft = false;

      /* clear out old lists */
      ClearAttackedSquares(RookAttackedSquaresWhite, RookAttackedSquaresBlack, true);
      
      //Add all squares that rook attacks
      if (visible) {
        for (int i = 1; i < 8; i++) { 
          if (!StopRight) {
            try {
              if (squares[CurrentX + i][CurrentY].OccupiedWhite || squares[CurrentX + i][CurrentY].OccupiedBlack) {
                RookAttackedSquaresWhite.add(squares[CurrentX + i][CurrentY]);
                squares[CurrentX + i][CurrentY].AttackedByBlack = true;
                StopRight = true;
              }
              else {
                RookAttackedSquaresWhite.add(squares[CurrentX + i][CurrentY]);
                squares[CurrentX + i][CurrentY].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopRight = true;}
          }
          if (!StopLeft) {
            try {
              if (squares[CurrentX - i][CurrentY].OccupiedWhite || squares[CurrentX - i][CurrentY].OccupiedBlack) {
                RookAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY]);
                squares[CurrentX - i][CurrentY].AttackedByBlack = true;
                StopLeft = true;
              }
              else {
                RookAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY]);
                squares[CurrentX - i][CurrentY].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopLeft = true;}
          }
          if (!StopDown) {
            try {
              if (squares[CurrentX][CurrentY + i].OccupiedWhite || squares[CurrentX][CurrentY + i].OccupiedBlack) {
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY + i]);
                squares[CurrentX][CurrentY + i].AttackedByBlack = true;
                StopDown = true;
              }
              else {
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY + i]);
                squares[CurrentX][CurrentY + i].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopDown = true;}
          }
          if (!StopUp) {
            try {
              if (squares[CurrentX][CurrentY - i].OccupiedWhite || squares[CurrentX][CurrentY - i].OccupiedBlack) {
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY - i]);
                squares[CurrentX][CurrentY- i].AttackedByBlack = true;
                StopUp = true;
              }
              else {
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY - i]);
                squares[CurrentX][CurrentY - i].AttackedByBlack = true;
              }
            } catch (IndexOutOfBoundsException e) {StopUp = true;}
          }          
        }
        
        for (Square s : RookAttackedSquaresWhite) {
            board.AttackedSquaresWhite.add(s);
        }
      }
    }
    else //white rook
    {  
      boolean StopUp = false , StopDown = false, StopRight = false, StopLeft = false;

      /* clear out old lists */
      ClearAttackedSquares(RookAttackedSquaresWhite, RookAttackedSquaresBlack, false);
      
      //Add all squares that rook attacks
      if (visible) {
        for (int i = 1; i < 8; i++) {  
          if (!StopRight) {
            try {
              if (squares[CurrentX + i][CurrentY].OccupiedWhite || squares[CurrentX + i][CurrentY].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY]);
                squares[CurrentX + i][CurrentY].AttackedByWhite = true;
                StopRight = true;
              }
              else {
                RookAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY]);
                squares[CurrentX + i][CurrentY].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopRight = true;}
          }
          if (!StopLeft) {
            try {
              if (squares[CurrentX - i][CurrentY].OccupiedWhite || squares[CurrentX - i][CurrentY].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY]);
                squares[CurrentX - i][CurrentY].AttackedByWhite = true;
                StopLeft = true;
              }
              else {
                RookAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY]);
                squares[CurrentX - i][CurrentY].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopLeft = true;}
          }
          if (!StopDown) {
            try {
              if (squares[CurrentX][CurrentY + i].OccupiedWhite || squares[CurrentX][CurrentY + i].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY + i]);
                squares[CurrentX][CurrentY + i].AttackedByWhite = true;
                StopDown = true;
              }
              else {
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY + i]);
                squares[CurrentX][CurrentY + i].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopDown = true;}
          }
          if (!StopUp) {
            try {
              if (squares[CurrentX][CurrentY - i].OccupiedWhite || squares[CurrentX][CurrentY - i].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY - i]);
                squares[CurrentX][CurrentY - i].AttackedByWhite = true;
                StopUp = true;
              }
              else {
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY - i]);
                squares[CurrentX][CurrentY - i].AttackedByWhite = true;
              }
            } catch (IndexOutOfBoundsException e) {StopUp = true;}
          }          
        }
        
          for (Square s : RookAttackedSquaresBlack) {
            board.AttackedSquaresBlack.add(s);
          }
      }
    }
    
  }
  
  void KingPutInCheck(King [] kings) { 
   //kings[0] == white king, kings[1] == black king
    if (isBlack) {
      for (Square s : RookAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          kings[0].InCheck = true;     
          kings[0].AttackedByThesePieces.add(this);
        }
      }
    } else {
      for (Square s : RookAttackedSquaresBlack) {
        if (kings[1].x == s.x && kings[1].y == s.y) {
          kings[1].InCheck = true;
          kings[1].AttackedByThesePieces.add(this);
        }
      }
    }
        
  }
  
  void CastleMove(Rook [] rooks, Pawn [] pawns, King [] kings) {
    
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
    
    FirstMove = false;
    
    UpdateOccupiedSquares(board, pieces);
    //OnAttackedSquare(board.AttackedSquaresWhite, board.AttackedSquaresBlack);
    
    KingPutInCheck(kings);
    
    if (kings[1].InCheck) 
      kings[1].CanMoveBeBlocked(board, rooks);
      
    if (CheckForCheckmate(board, rooks, kings))
      println("mate");
  }
    
  boolean CheckBasicLegalMoves(SquareCollection board) {
    for (int row = 0; row < board.squares.length; row++) {
      for (int col = 0; col < board.squares[row].length; col++) {
        if (board.squares[row][col].active) { // this is the square the mouse is released on
        
          if ((XChange == 0 && YChange < 0)) { // If rook is moving up
            for (int i = 0; i < abs(YChange); i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row][col + i].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row][col + i].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row][col + i].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col + i].x;
                CapturedOnY = (int) board.squares[row][col + i].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row][col + i].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col + i].x;
                CapturedOnY = (int) board.squares[row][col + i].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
          if ((XChange == 0 && YChange > 0)) { // If rook is moving down
            for (int i = 0; i < YChange; i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row][col - i].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row][col - i].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row][col - i].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col - i].x;
                CapturedOnY = (int) board.squares[row][col - i].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row][col - i].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col - i].x;
                CapturedOnY = (int) board.squares[row][col - i].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
         if ((XChange > 0 && YChange == 0)) { // If rook is moving right
            for (int i = 0; i < XChange; i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row - i][col].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row - i][col].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row - i][col].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row - i][col].x;
                CapturedOnY = (int) board.squares[row - i][col].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row - i][col].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row - i][col].x;
                CapturedOnY = (int) board.squares[row - i][col].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
          if ((XChange < 0 && YChange == 0)) { // If rook is moving left
            for (int i = 0; i < abs(XChange); i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row + i][col].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row + i][col].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row + i][col].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row + i][col].x;
                CapturedOnY = (int) board.squares[row + i][col].y;
                BlackIsCaptured = false;
                UpdateAttackedSquares(board);
                return true;
              }
              if (board.squares[row + i][col].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row + i][col].x;
                CapturedOnY = (int) board.squares[row + i][col].y;
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
   
   boolean Legal(StateChecker StateChecker, SquareCollection board, King [] kings) { 
    if (CheckBasicLegalMoves(board) && CheckTurnColor(StateChecker) && !YourKinginCheck(kings))    
      return true;
    else {
      println(CheckBasicLegalMoves(board) + " , " + CheckTurnColor(StateChecker));
      return false;
    }
  }
}
