class Knight extends Piece { 
  PImage KnightImage;
  ArrayList <Square> KnightAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> KnightAttackedSquaresBlack = new ArrayList();

  public Knight(PImage _KnightImage, boolean _isBlack, float _x, float _y) {
    KnightImage = _KnightImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;
  }
  
  void draw() {
    if (visible)
      image(KnightImage, x + offsetx, y + offsety, l, l);
  }
  
  void mouseReleased(SquareCollection sc, ArrayList<Piece> pieces, Pawn [] pawns, King [] kings, Rook [] rooks, Bishop [] bishops, ArrayList <Queen> queens, Knight [] knights) { 
    if (active && visible) {
      GetXYChange(sc, mouseX, mouseY);    // gets x and y change in indices, stored in XChange/YChange
      LockPieceToSquare(board.squares);                 // locks piece to the middle of the square it move to
      active = false;                                   // turn off mouse activity for this piece
      
      if (!kings[0].InCheck && !kings[1].InCheck)
        CheckIfPinned(board, pieces, rooks, bishops, queens);
      
      if (Legal(board, kings)) {  
        if (AttackingMove) 
          Capture(pieces);
          
        AttackingMove = false;
        
        StateChecker.FlipColor();
          
        UpdateXYIndices(board);
         
        UpdateOccupiedSquares(board, pieces);
        UpdateOccupiedSquaresPin(board,pieces);

        UpdateAllPiecesAttackedSquares(board, kings, pawns, rooks, bishops, queens, knights);
                
        KingPutInCheckAllPieces(board, kings, pawns, rooks, bishops, queens, knights);
                              
        CheckForCheckmate(board, rooks, kings, bishops, queens);
    // if not a legal move, return piece to original coords
    } else {
        this.x = InitXCoord;
        this.y = InitYCoord;
      }      
    }
  }
  
  void UpdateAttackedSquares(SquareCollection board) {
    Square [][] squares = board.squares;
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
    int dx = 1, dy = 2;  // default values
    
    ClearAttackedSquares(KnightAttackedSquaresWhite, KnightAttackedSquaresBlack, isBlack);   // clear out old lists
    
    for (int n = 1; n < 8; n++) {              // loops 8 times
    // x : 1, 2, 2, 1, -1, -2 ,-2, -1          // values for dx and dy for each possible knight move
    // y : -2, -1, 1, 2, 2, 1, -1, -2
    
    // logic to get dx and dy right:
      if (n == 2 | n == 3 | n == 6 | n == 7) {
        dx = 2;
        dy = 1;
      }
      if (n > 4)
        dx *= -1;
      if (n < 3 | n > 6)
        dy *= -1;
      
    // add attacked squares; try catch block in case move is off the board
    if (visible) {
      try {
        if (isBlack) {
          KnightAttackedSquaresWhite.add(squares[CurrentX + dx][CurrentY + dy]); 
          squares[CurrentX + dx][CurrentY + dy].AttackedByBlack = true;
        }
        else {
          KnightAttackedSquaresBlack.add(squares[CurrentX + dx][CurrentY + dy]); 
          squares[CurrentX + dx][CurrentY + dy].AttackedByWhite = true;
        }        
      } catch(IndexOutOfBoundsException e) {}
    }
    
    if (isBlack) {
        for (Square s : KnightAttackedSquaresWhite) {
          board.AttackedSquaresWhite.add(s);
        }
      }
      else {
        for (Square s : KnightAttackedSquaresBlack) {
          board.AttackedSquaresBlack.add(s);
        }
      } 
   }
    
  }
  
  void KingPutInCheck(King [] kings) { 
    if (isBlack) {
      for (Square s : KnightAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          kings[0].InCheck = true;     
          kings[1].AttackedByThesePieces.add(this);
        }
      }
    } else {
      for (Square s : KnightAttackedSquaresBlack) {
        if (kings[1].x == s.x && kings[1].y == s.y) {
          kings[1].InCheck = true;
          kings[1].AttackedByThesePieces.add(this);
        }
      }
    }
  }
  
  boolean CheckBasicLegalMoves(Square [][] Squares) { 
    for (int row = 0; row < Squares.length; row++) {
      for (int col = 0; col < Squares[row].length; col++) {
        if (Squares[row][col].active) { // this is the square the mouse is released on
          
          if ((abs(XChange) == 1 | abs(XChange) == 2) 
              && (abs(YChange) == 1 | abs(YChange) == 2)
              && (abs(XChange) != abs(YChange))) {
            if (isBlack) {
              if (Squares[row][col].OccupiedWhite) {
                 AttackingMove = true;
                 CapturedOnX = (int) Squares[row][col].x;
                 CapturedOnY = (int) Squares[row][col].y;
                 BlackIsCaptured = false;
                 UpdateAttackedSquares(board);
                 return true;
              }
              if (!Squares[row][col].OccupiedBlack) {
                return true;
              }
            }
            else {
               if (Squares[row][col].OccupiedBlack) {
                AttackingMove = true;
                CapturedOnX = (int) Squares[row][col].x;
                CapturedOnY = (int) Squares[row][col].y;
                BlackIsCaptured = true;
                UpdateAttackedSquares(board);
                return true;
              }
              if (!Squares[row][col].OccupiedWhite) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }
  
  boolean Legal(SquareCollection board, King [] kings) {    
    if (CheckBasicLegalMoves(board.squares) && CheckTurnColor(StateChecker)) {
      if (YourKingInCheck(kings)) { 
        println("here" + AttackingTheAttacker(kings) , BlockingMove(kings));
        if (AttackingTheAttacker(kings) || BlockingMove(kings))
          return true;       
        else return false;
      }
      
      else if (!board.PinnedPieceMoved(isBlack))
        return true; // return true if king is not in check and not pinned piece moved
      else return false;
      
    } else {
      println(CheckBasicLegalMoves(board.squares) + " , " + CheckTurnColor(StateChecker));
      return false;
    } 
  } 
}
