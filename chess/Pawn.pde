class Pawn extends Piece //<>//
{
  PImage PawnImage;
  PImage QueenImage;
  ArrayList <Square> PawnAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> PawnAttackedSquaresBlack = new ArrayList();
  boolean OnAttackedSquare;

  public Pawn(PImage _PawnImage, PImage _QueenImage, boolean _isBlack, float _x, float _y) {
    PawnImage = _PawnImage;
    QueenImage = _QueenImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;
  }

  void draw() {
    if (visible)
      image(PawnImage, x + offsetx, y + offsety, l, l);
  }

  void mouseReleased(SquareCollection sc, ArrayList<Piece> pieces, Pawn [] pawns, King [] kings, Rook [] rooks, Bishop [] bishops, ArrayList <Queen> queens, Knight [] knights)
  {
    if (active && visible) {
      GetXYChange(sc, mouseX, mouseY);    // gets x and y change in indices, stored in XChange/YChange
      LockPieceToSquare(board.squares);                 // locks piece to the middle of the square it move to
      active = false;                                   // turn off mouse activity for this piece
      
      if (!kings[0].InCheck && !kings[1].InCheck)
        CheckIfPinned(board, pieces, rooks, bishops, queens);
      
    // if legal move :
      if (Legal(board, kings)) {  
        if (AttackingMove) 
          Capture(pieces);
          
        AttackingMove = false;
        
        StateChecker.FlipColor();
        
        Promotion(QueenImage, queens, pieces);
          
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
   
  String toString(SquareCollection board) {
    int snumber = 0;
    for (Square [] row : board.squares) {
      for (Square s : row) {
        if (s.x == this.x && s.y == this.y) 
          snumber = s.squarenumber;
      }
    }
    return ("Pawn " + String.valueOf(snumber));
  }
  
  void UpdateAttackedSquares(SquareCollection board) {
    /* Add all squares that piece attacks to its own list
    Then add squares from this list to a master list for the enemy color*/
    Square [][] squares = board.squares;
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
         
    if (isBlack) {    // black pieces 
      /* clear out old lists */
      ClearAttackedSquares(PawnAttackedSquaresWhite, PawnAttackedSquaresBlack, true);
      
      //Add all squares that pawn attacks
      if (visible) {
        try {
          PawnAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY + 1]);  // diagonal down right
          squares[CurrentX + 1][CurrentY + 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}
        try {
          PawnAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY + 1]);  // diagonal down left
          squares[CurrentX - 1][CurrentY + 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}    
        
        for (Square s : PawnAttackedSquaresWhite) {
          board.AttackedSquaresWhite.add(s);                                  // add these to master list for attacked pieces
        }
      }
    }
    else //white pieces
    {  
      ClearAttackedSquares(PawnAttackedSquaresWhite, PawnAttackedSquaresBlack, false);
      
      if (visible) {
        try {
          PawnAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY - 1]);  // diag up right
          squares[CurrentX + 1][CurrentY - 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}
        try {
          PawnAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY - 1 ]);  // diag up left
          squares[CurrentX - 1][CurrentY - 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}
        
        for (Square s : PawnAttackedSquaresBlack) {
          board.AttackedSquaresBlack.add(s);                                   // add to master list
        }
      }
    } 
    
   //AttackedSquaresLogging(board);

  }
  
  void KingPutInCheck(King [] kings) { 
   //kings[0] == white king, kings[1] == black king
    if (isBlack) {
      for (Square s : PawnAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          kings[0].InCheck = true;     
          kings[1].AttackedByThesePieces.add(this);
        }
      }
    } else {
      for (Square s : PawnAttackedSquaresBlack) {
        if (kings[1].x == s.x && kings[1].y == s.y) {
          kings[1].InCheck = true;
          kings[1].AttackedByThesePieces.add(this);
        }
      }
    }
  }
  
  void Promotion(PImage QueenImage, ArrayList<Queen> queens, ArrayList <Piece> pieces)
  {
    if (isBlack && y == 540) {
      visible = false;
      Queen PromotedQ = new Queen(QueenImage, true, x, y);
      pieces.add(PromotedQ);
      queens.add(PromotedQ);
    }
    if (!isBlack && y == 0) {
      visible = false; 
      Queen PromotedQ = new Queen(QueenImage, false, x, y);
      pieces.add(PromotedQ);
      queens.add(PromotedQ);
    }
  }
  
  boolean CheckBasicLegalMoves(Square [][] Squares) {  
    for (int row = 0; row < Squares.length; row++) {
      for (int col = 0; col < Squares[row].length; col++) {
        if (Squares[row][col].active) { // this is the square the mouse is released on
        
          if (XChange == 0 && YChange == 1 && isBlack && !Squares[row][col].OccupiedBlack && !Squares[row][col].OccupiedWhite)
            return true;
          else if (XChange == 0 && YChange == -1 && !isBlack && !Squares[row][col].OccupiedWhite && !Squares[row][col].OccupiedBlack)
            return true;
          else if (XChange == 0 && YChange == 2 && isBlack && FirstMove && !Squares[row][col].OccupiedBlack && !Squares[row][col].OccupiedWhite && !Squares[row][col - 1].OccupiedWhite && !Squares[row][col - 1].OccupiedBlack)
            return true;
          else if (XChange == 0 && YChange == -2 && !isBlack && FirstMove && !Squares[row][col].OccupiedWhite && !Squares[row][col].OccupiedBlack && !Squares[row][col + 1].OccupiedWhite && !Squares[row][col + 1].OccupiedBlack)
            return true;
          else if ((XChange == 1 || XChange == -1) && YChange == -1 && !isBlack && Squares[row][col].OccupiedBlack) {
            AttackingMove = true;
            CapturedOnX = (int) Squares[row][col].x;
            CapturedOnY = (int) Squares[row][col].y;
            BlackIsCaptured = true;
            UpdateAttackedSquares(board);
            return true;
          }
          else if ((XChange == 1 || XChange == -1) && YChange == 1 && isBlack && Squares[row][col].OccupiedWhite) {
           AttackingMove = true;
           CapturedOnX = (int) Squares[row][col].x;
           CapturedOnY = (int) Squares[row][col].y;
           BlackIsCaptured = false;
           UpdateAttackedSquares(board);
           return true;
          }
          else return false;
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
