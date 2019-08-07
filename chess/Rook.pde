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
  
  void mouseReleased(SquareCollection board, Rook [] rooks, King [] kings, Pawn [] pawns)
  {
    if (Active) {      
      GetXYChange(board, mouseX, mouseY);
      LockPieceToSquare(board.squares);
      Active = false;      
      
      if (Legal(StateChecker, board, kings)) {  
        UpdateXYIndices(board);
        
        if (AttackingMove) {
          Capture(pieces);
        } 
        
        for (Rook r : rooks) {
          r.UpdateAttackedSquares(board);
        }
        for (Pawn p : pawns) {
          p.UpdateAttackedSquares(board);
        }
        
        FirstMove = false;
        StateChecker.FlipColor();
        
        UpdateOccupiedSquares(board, pieces);
        //OnAttackedSquare(board.AttackedSquaresWhite, board.AttackedSquaresBlack);
        
        KingPutInCheck(kings);
        
        if (kings[1].InCheck) 
          kings[1].CanMoveBeBlocked(board);
        
        AttackingMove = false;
      
      
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
         
    if (isBlack) {    // black pieces 
      boolean StopUp = false , StopDown = false, StopRight = false, StopLeft = false;

      /* clear out old lists */
      ClearAttackedSquares(RookAttackedSquaresWhite, RookAttackedSquaresBlack, true);
      
      //Add all squares that rook attacks
      if (visible) {
        for (int i = 1; i < 8; i++) { 
          if (!StopRight) {
            try {
              if (squares[CurrentX + i][CurrentY].OccupiedWhite || squares[CurrentX + i][CurrentY].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY]);
                StopRight = true;
              }
              else
                RookAttackedSquaresWhite.add(squares[CurrentX + i][CurrentY]);
            } catch (IndexOutOfBoundsException e) {StopRight = true;}
          }
          if (!StopLeft) {
            try {
              if (squares[CurrentX - i][CurrentY].OccupiedWhite || squares[CurrentX - i][CurrentY].OccupiedBlack) {
                RookAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY]);
                StopLeft = true;
              }
              else
                RookAttackedSquaresWhite.add(squares[CurrentX - i][CurrentY]);
            } catch (IndexOutOfBoundsException e) {StopLeft = true;}
          }
          if (!StopDown) {
            try {
              if (squares[CurrentX][CurrentY + i].OccupiedWhite || squares[CurrentX][CurrentY + i].OccupiedBlack) {
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY + i]);
                StopDown = true;
              }
              else
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY + i]);
            } catch (IndexOutOfBoundsException e) {StopDown = true;}
          }
          if (!StopUp) {
            try {
              if (squares[CurrentX][CurrentY - i].OccupiedWhite || squares[CurrentX][CurrentY - i].OccupiedBlack) {
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY - i]);
                StopUp = true;
              }
              else
                RookAttackedSquaresWhite.add(squares[CurrentX][CurrentY - i]);
            } catch (IndexOutOfBoundsException e) {StopUp = true;}
          }          
        }
        
        for (Square s : RookAttackedSquaresWhite) {
            board.AttackedSquaresWhite.add(s);
        }
      }
    }
    else //white pieces
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
                StopRight = true;
              }
              else
                RookAttackedSquaresBlack.add(squares[CurrentX + i][CurrentY]);
            } catch (IndexOutOfBoundsException e) {StopRight = true;}
          }
          if (!StopLeft) {
            try {
              if (squares[CurrentX - i][CurrentY].OccupiedWhite || squares[CurrentX - i][CurrentY].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY]);
                StopLeft = true;
              }
              else
                RookAttackedSquaresBlack.add(squares[CurrentX - i][CurrentY]);
            } catch (IndexOutOfBoundsException e) {StopLeft = true;}
          }
          if (!StopDown) {
            try {
              if (squares[CurrentX][CurrentY + i].OccupiedWhite || squares[CurrentX][CurrentY + i].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY + i]);
                StopDown = true;
              }
              else
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY + i]);
            } catch (IndexOutOfBoundsException e) {StopDown = true;}
          }
          if (!StopUp) {
            try {
              if (squares[CurrentX][CurrentY - i].OccupiedWhite || squares[CurrentX][CurrentY - i].OccupiedBlack) {
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY - i]);
                StopUp = true;
              }
              else
                RookAttackedSquaresBlack.add(squares[CurrentX][CurrentY - i]);
            } catch (IndexOutOfBoundsException e) {StopUp = true;}
          }          
        }
        
          for (Square s : RookAttackedSquaresBlack) {
            board.AttackedSquaresBlack.add(s);
          }
      }
    }
    
 //  AttackedSquaresLogging(board);

  }
  
  void KingPutInCheck(King [] kings) { 
   //kings[0] == white king, kings[1] == black king
    if (isBlack) {
      for (Square s : RookAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          println("hey");
          kings[0].InCheck = true;     
          kings[1].AttackedByThesePieces.add(this);
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
                return true;
              }
              if (board.squares[row][col - i].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col - i].x;
                CapturedOnY = (int) board.squares[row][col - i].y;
                BlackIsCaptured = true;
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
                CapturedOnX = (int) board.squares[row][col - i].x;
                CapturedOnY = (int) board.squares[row][col - i].y;
                BlackIsCaptured = false;
                return true;
              }
              if (board.squares[row - i][col].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col - i].x;
                CapturedOnY = (int) board.squares[row][col - i].y;
                BlackIsCaptured = true;
                return true;
              }              
            }
            return true; // if there is nothing in the way then return true;
          }
          
          if ((XChange < 0 && YChange == 0)) { // If rook is moving right
            for (int i = 0; i < XChange; i++) { // for each square that it moved
              // check if that square was occupied
              if (board.squares[row + i][col].OccupiedBlack && isBlack) //occupied black and black piece
                return false;
              if (board.squares[row + i][col].OccupiedWhite && !isBlack) //occupied white and white piece
                return false;
              if (board.squares[row + i][col].OccupiedWhite && isBlack) { // capture of white
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col + i].x;
                CapturedOnY = (int) board.squares[row][col + i].y;
                BlackIsCaptured = false;
                return true;
              }
              if (board.squares[row + i][col].OccupiedBlack && !isBlack) { // capture of black
                AttackingMove = true;
                CapturedOnX = (int) board.squares[row][col + i].x;
                CapturedOnY = (int) board.squares[row][col + i].y;
                BlackIsCaptured = true;
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
   
   boolean Legal(StateChecker StateChecker, SquareCollection board, King [] kings)
  { 
    if (CheckBasicLegalMoves(board) && CheckTurnColor(StateChecker) && !YourKinginCheck(kings))    
      return true;
    else {
      println(CheckBasicLegalMoves(board) + " , " + CheckTurnColor(StateChecker));
      return false;
    }
  }
}
