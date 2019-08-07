class Pawn extends Piece //<>//
{
  PImage PawnImage;
  ArrayList <Square> PawnAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> PawnAttackedSquaresBlack = new ArrayList();
  boolean OnAttackedSquare;

  public Pawn(PImage _PawnImage, boolean _isBlack, float _x, float _y) {
    PawnImage = _PawnImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;
  }

  void draw()
  {
    if (visible)
      image(PawnImage, x + offsetx, y + offsety, l, l);
  }

  void mouseReleased(SquareCollection SquareCollection, Square [][] squares, StateChecker StateChecker, Pawn [] pawns, King [] kings, Rook [] rooks, ArrayList<Piece> pieces)
  {
    if (Active && visible) {      
      GetXYChange(SquareCollection, mouseX, mouseY);    // gets x and y change in indices, stored in XChange/YChange
      LockPieceToSquare(squares);                       // locks piece to the middle of the square it move to
      Active = false;                                   // turn off mouse activity for this piece

    // if legal move :
      if (Legal(StateChecker, squares, kings)) {  
        UpdateXYIndices(board);
        
        if (AttackingMove) {                            // Capture if attacking move
          Capture(pieces);
        }
     
        // Update attacked squares for all pieces
        for (Pawn p : pawns) {
          p.UpdateAttackedSquares(SquareCollection);
        }
        for (Rook r : rooks) {
          r.UpdateAttackedSquares(SquareCollection);
        }
        
        FirstMove = false;
        StateChecker.FlipColor();
        
        UpdateOccupiedSquares(SquareCollection, pieces);  // Piece moved so occupied squares changes
        KingPutInCheck(kings);                            // Check if king is now in check (and if this piece is now an attacker of king)
      //  OnAttackedSquare(SquareCollection.AttackedSquaresWhite, SquareCollection.AttackedSquaresBlack); // Not sure what the point of this is
        
        AttackingMove = false;                            // turns attacking move back to false
     
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
        } catch(IndexOutOfBoundsException e){}
        try {
          PawnAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY + 1]);  // diagonal down left
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
        } catch(IndexOutOfBoundsException e){}
        try {
          PawnAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY - 1 ]);  // diag up left
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
  
  void Promotion()
  {
    if (isBlack && y == 540)
    {
      //promote
    }
    else
    {
      if (y == 0) {}
        //Promote
    }
  }
  
  boolean CheckBasicLegalMoves(Square [][] Squares)
  {  
    for (int row = 0; row < Squares.length; row++)
    {
      for (int col = 0; col < Squares[row].length; col++)
      {
        if (Squares[row][col].active) // this is the square the mouse is released on
        {
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
            return true;
          }
          else if ((XChange == 1 || XChange == -1) && YChange == 1 && isBlack && Squares[row][col].OccupiedWhite) {
           AttackingMove = true;
           CapturedOnX = (int) Squares[row][col].x;
           CapturedOnY = (int) Squares[row][col].y;
           BlackIsCaptured = false;
           return true;
          }
          else return false;
        }
      }
    }
    return false;
  }

  boolean Legal(StateChecker StateChecker, Square [][] Squares, King [] kings)
  { 
    if (CheckBasicLegalMoves(Squares) && CheckTurnColor(StateChecker) && !YourKinginCheck(kings))    
      return true;
    else return false;
  }
  
  
}
