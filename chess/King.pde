
class King extends Piece
{
  PImage KingImage;
  boolean InCheck;
  boolean NoLegalMovesBlack, NoLegalMovesWhite;
  boolean AttackingPieceUncaptureableBlack, AttackingPieceUncaptureableWhite;
  boolean UnblockableAttackBlack, UnblockableAttackWhite;
  boolean KingsideLegalBlack, QueensideLegalBlack, KingsideLegalWhite, QueensideLegalWhite;
  ArrayList <Piece> AttackedByThesePieces = new ArrayList<Piece>();
  ArrayList <Square> BetweenAttackerAndKing = new ArrayList<Square>();
  ArrayList <Square> KingAttackedSquaresWhite = new ArrayList<Square>();
  ArrayList <Square> KingAttackedSquaresBlack = new ArrayList<Square>();
  
  public King(PImage _KingImage, boolean _isBlack, float _x, float _y, int _XInd, int _YInd) {
    KingImage = _KingImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;
    XInd = _XInd;
    YInd = _YInd;
  }
  
  public King() {}
  
  void draw() {
    image(KingImage, x + offsetx, y + offsety, l, l);
  }
  
  void mouseReleased(SquareCollection board, ArrayList <Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops, Queen [] queens, Knight [] knights) {
    if (active) {      
      GetXYChange(board, mouseX, mouseY);
      LockPieceToSquare(board.squares);
      active = false;      

      if (Legal(StateChecker, board, rooks, pawns, kings, bishops, queens)) {
        if (AttackingMove) 
          Capture(pieces);
          
        AttackingMove = false;
        
        StateChecker.FlipColor();
         board.WhiteTurn = !board.WhiteTurn;
          
        UpdateXYIndices(board);
          
        UpdateAttackedSquares(board);
        
        UpdateOccupiedSquares(board, pieces);
        
        UpdateAllPiecesAttackedSquares(board, kings, pawns, rooks, bishops, queens, knights);
        
        KingPutInCheckAllPieces(board, kings, pawns, rooks, bishops, queens, knights);
        
        SquareOccupiedKing(board);

       
       
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
    return ("King " + String.valueOf(snumber));
  }
  
  void OutOfCheck(ArrayList AttackedSquaresWhite, ArrayList AttackedSquaresBlack)
  {
    if (this.InCheck == true && IsSquareAttacked(AttackedSquaresWhite, AttackedSquaresBlack) == false) {
      this.InCheck = false;
      AttackedByThesePieces.clear();
    }
  }
  
  void SquareOccupiedKing(SquareCollection board) { 
    for (Square [] row : board.squares) {
          for (Square s : row) {
            if (s.x == x && s.y == y) {
              if (isBlack)
                s.OccupiedBlackKing = true;
              else
                s.OccupiedWhiteKing = true;
            }
          }
        }
  }
  
  boolean Checkmate(SquareCollection board, Rook [] rooks, Bishop [] bishops, Queen[] queens) {
    //If you cannot move to any unattacked squares
    CheckLegalKingMoves(board);
    
    //If the attacking piece is not on an attacked square for their color
    IsPieceCaptureable(board); 
    
    //If the move cannot be blocked
    CanMoveBeBlocked(board, rooks, bishops, queens);
    
    if (isBlack) {
      if (NoLegalMovesBlack && AttackingPieceUncaptureableBlack && UnblockableAttackBlack && InCheck) 
        return true;      
    }
    
    else {
      if (NoLegalMovesWhite && AttackingPieceUncaptureableWhite && UnblockableAttackWhite && InCheck)
        return true;      
    }
    
    return false;
    
  }
  
  void CheckLegalKingMoves(SquareCollection board)
  {
    int X = board.GetXIndexMouse(this.x);
    int Y = board.GetYIndexMouse(this.y);
    int IllegalSquareCounterBlack = 0, IllegalSquareCounterWhite = 0;
    Square [][] squares = board.squares;
    
    if (isBlack)
    {
      try {
        if (board.AttackedSquaresBlack.contains(squares[X][Y+1]) || squares[X][Y+1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X][Y-1]) || squares[X][Y-1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X-1][Y+1]) || squares[X-1][Y+1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X-1][Y]) || squares[X-1][Y].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      
      try {
        if (board.AttackedSquaresBlack.contains(squares[X+1][Y]) || squares[X+1][Y].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      try {
        if (board.AttackedSquaresBlack.contains(squares[X+1][Y+1]) || squares[X+1][Y+1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      try {
        if (board.AttackedSquaresBlack.contains(squares[X-1][Y-1]) || squares[X-1][Y-1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
      try {
        if (board.AttackedSquaresBlack.contains(squares[X+1][Y-1]) || squares[X+1][Y-1].OccupiedBlack)
          IllegalSquareCounterBlack++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterBlack++; 
      }
            
      if (IllegalSquareCounterBlack == 8)
        NoLegalMovesBlack = true;
    }
    else 
    {
      try {
        if (board.AttackedSquaresWhite.contains(squares[X][Y+1]) || squares[X][Y+1].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X][Y-1]) || squares[X][Y-1].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X-1][Y+1]) || squares[X-1][Y+1].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X-1][Y]) || squares[X-1][Y].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      try {
        if (board.AttackedSquaresWhite.contains(squares[X+1][Y]) || squares[X+1][Y].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      try {
        if (board.AttackedSquaresWhite.contains(squares[X+1][Y+1]) || squares[X+1][Y+1].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      try {
        if (board.AttackedSquaresWhite.contains(squares[X+1][Y+1]) || squares[X+1][Y+1].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      try {
        if (board.AttackedSquaresWhite.contains(squares[X+1][Y+1]) || squares[X+1][Y+1].OccupiedWhite)
          IllegalSquareCounterWhite++;
      } catch (ArrayIndexOutOfBoundsException e){ 
          IllegalSquareCounterWhite++; 
      }
      
      if (IllegalSquareCounterWhite == 8)
        NoLegalMovesWhite = true;
    }
  }
  
  void IsPieceCaptureable(SquareCollection board) {
    AttackingPieceUncaptureableBlack = true;
    AttackingPieceUncaptureableWhite = true;
    
    for (Piece pi : AttackedByThesePieces) {
      if (pi.isBlack) {
        for (Square s : board.AttackedSquaresBlack) {
          if (pi.x == s.x && pi.y == s.y) {
            AttackingPieceUncaptureableWhite = false;
            return;
          }
          
        }
      }
      else {
        for (Square s : board.AttackedSquaresWhite) {
          if (pi.x == s.x && pi.y == s.y) {
            AttackingPieceUncaptureableBlack = false;
            return;
          }
        }
      }
      
    }
  }
  
  void UpdateAttackedSquares(SquareCollection board) {
    Square [][] squares = board.squares;
    int CurrentX = board.GetXIndexMouse(this.x);
    int CurrentY = board.GetYIndexMouse(this.y);
         
    if (isBlack) {    // black pieces 
      /* clear out old lists */
      ClearAttackedSquares(KingAttackedSquaresWhite, KingAttackedSquaresBlack, true);
      
      //Add all squares that king attacks
      if (visible) {
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY + 1]);
          squares[CurrentX - 1][CurrentY + 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}   
         try {
          KingAttackedSquaresWhite.add(squares[CurrentX][CurrentY + 1]);
          squares[CurrentX][CurrentY + 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY + 1]);
          squares[CurrentX + 1][CurrentY + 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY]);
          squares[CurrentX - 1][CurrentY].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY]);
          squares[CurrentX + 1][CurrentY].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY - 1]);
          squares[CurrentX - 1][CurrentY - 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX][CurrentY - 1]);
          squares[CurrentX][CurrentY - 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY - 1]);
          squares[CurrentX + 1][CurrentY - 1].AttackedByBlack = true;
        } catch(IndexOutOfBoundsException e){}   
        
      }
    }
    else //white pieces
    {  
      ClearAttackedSquares(KingAttackedSquaresWhite, KingAttackedSquaresBlack, false);
      
      if (visible) {
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY + 1]);
          squares[CurrentX - 1][CurrentY + 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}   
         try {
          KingAttackedSquaresBlack.add(squares[CurrentX][CurrentY + 1]);
          squares[CurrentX][CurrentY + 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY + 1]);
          squares[CurrentX + 1][CurrentY + 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY]);
          squares[CurrentX - 1][CurrentY].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY]);
          squares[CurrentX + 1][CurrentY].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY - 1]);
          squares[CurrentX - 1][CurrentY - 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX][CurrentY - 1]);
          squares[CurrentX][CurrentY - 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY - 1]);
          squares[CurrentX + 1][CurrentY - 1].AttackedByWhite = true;
        } catch(IndexOutOfBoundsException e){}
        
    // removed adding to master list for king
      }
    } 
    

  }
  
  
  void CanMoveBeBlocked(SquareCollection board, Rook [] rooks, Bishop [] bishops, Queen [] queens) {
    UnblockableAttackBlack = true;    // attacks are by default unblockable
    UnblockableAttackWhite = true; 
    
    //TODO: add queens
    
    if (AttackedByThesePieces.size() == 0)  //stop function if king is not attacked
      return;
          
    // If attacked by more than one piece, it can't be blocked
    else if (AttackedByThesePieces.size() > 1) {
      return;      
    }
    
    if (AttackedByThesePieces.get(0).getClass().getSimpleName().equals("Pawn")
    || AttackedByThesePieces.get(0).getClass().getSimpleName().equals("Knight")) {    // if attacked by pawn or knight
      //Pawn and knight attacks can't be blocked 
      return;
    }
    
    else if (AttackedByThesePieces.get(0).getClass().getSimpleName().equals("Queen")) {
      int XDiff = AttackedByThesePieces.get(0).XInd - this.XInd; // queen x - king x
      int YDiff = AttackedByThesePieces.get(0).YInd - this.YInd; // queen y - king y
      
      ///////// queen attacking from below king  /////////////
      if (YDiff > 0) {                   
        for (int i = this.YInd + 1; i < AttackedByThesePieces.get(0).YInd; i++) { // for each square between queen and king         
          ValidMoveAllPieces(rooks, bishops, queens, this, this.XInd, i);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }          
      }

    ///////// queen attacking from the above of king ///////////////////////
      else if (YDiff < 0) {                   
        for (int i = this.YInd - 1 ; i > AttackedByThesePieces.get(0).YInd; i--) { // for each square between queen and king         
          ValidMoveAllPieces(rooks, bishops, queens, this, this.XInd, i);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }          
      }
      
    ///////////// queen attacking from left of king ////////////////////////
      if (XDiff < 0) {                   
        for (int i = this.XInd - 1; i > AttackedByThesePieces.get(0).XInd; i--) { // for each square between queen and king
          ValidMoveAllPieces(rooks, bishops, queens, this, i, this.YInd);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      
    ///////////// queen attacking from right of king ////////////////////////
      else if (XDiff > 0) {                   
        for (int i = this.XInd + 1; i < AttackedByThesePieces.get(0).XInd; i++) { // for each square between queen and king
          ValidMoveAllPieces(rooks, bishops, queens, this, i, this.YInd);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      
      /// queen attacking from above left of king ///
      if (XDiff < 0 && YDiff < 0) {
        for (int x = this.XInd - 1, y = this.YInd - 1; x > AttackedByThesePieces.get(0).XInd; x--, y--) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      /// queen attacking from above right of king ///
      if (XDiff > 0 && YDiff < 0) {
        for (int x = this.XInd + 1, y = this.YInd - 1; x < AttackedByThesePieces.get(0).XInd; x++, y--) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      /// queen attacking from below left of king ///
      if (XDiff < 0 && YDiff > 0) {
        for (int x = this.XInd - 1, y = this.YInd + 1; x > AttackedByThesePieces.get(0).XInd; x--, y++) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      /// queen attacking from below right of king ///
      if (XDiff > 0 && YDiff > 0) {
        for (int x = this.XInd + 1, y = this.YInd + 1; x < AttackedByThesePieces.get(0).XInd; x++, y++) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      
    }
        
    else if (AttackedByThesePieces.get(0).getClass().getSimpleName().equals("Rook")) {    // if attacked by rook
      int XDiff = AttackedByThesePieces.get(0).XInd - this.XInd; // rook x - king x
      int YDiff = AttackedByThesePieces.get(0).YInd - this.YInd; // rook y - king y
      
      ///////// rook attacking from below king  /////////////
      if (YDiff > 0) {                   
        for (int i = this.YInd + 1; i < AttackedByThesePieces.get(0).YInd; i++) { // for each square between rook and king         
          ValidMoveAllPieces(rooks, bishops, queens, this, this.XInd, i);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }          
      }

    ///////// rook attacking from the above of king ///////////////////////
      else if (YDiff < 0) {                   
        for (int i = this.YInd - 1 ; i > AttackedByThesePieces.get(0).YInd; i--) { // for each square between rook and king         
          ValidMoveAllPieces(rooks, bishops, queens, this, this.XInd, i);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }          
      }
      
    ///////////// rook attacking from left of king ////////////////////////
      if (XDiff < 0) {                   
        for (int i = this.XInd - 1; i > AttackedByThesePieces.get(0).XInd; i--) { // for each square between rook and king
          ValidMoveAllPieces(rooks, bishops, queens, this, i, this.YInd);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      
    ///////////// rook attacking from right of king ////////////////////////
      else if (XDiff > 0) {                   
        for (int i = this.XInd + 1; i < AttackedByThesePieces.get(0).XInd; i++) { // for each square between rook and king
          ValidMoveAllPieces(rooks, bishops, queens, this, i, this.YInd);                 // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      
    }
    
    if (AttackedByThesePieces.get(0).getClass().getSimpleName().equals("Bishop")) { // if attacked by bishop
      int XDiff = AttackedByThesePieces.get(0).XInd - this.XInd;
      int YDiff = AttackedByThesePieces.get(0).YInd - this.YInd;
      /// Bishop attacking from above left of king ///
      if (XDiff < 0 && YDiff < 0) {
        for (int x = this.XInd - 1, y = this.YInd - 1; x > AttackedByThesePieces.get(0).XInd; x--, y--) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      /// Bishop attacking from above right of king ///
      if (XDiff > 0 && YDiff < 0) {
        for (int x = this.XInd + 1, y = this.YInd - 1; x < AttackedByThesePieces.get(0).XInd; x++, y--) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      /// Bishop attacking from below left of king ///
      if (XDiff < 0 && YDiff > 0) {
        for (int x = this.XInd - 1, y = this.YInd + 1; x > AttackedByThesePieces.get(0).XInd; x--, y++) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
      /// Bishop attacking from below right of king ///
      if (XDiff > 0 && YDiff > 0) {
        for (int x = this.XInd + 1, y = this.YInd + 1; x < AttackedByThesePieces.get(0).XInd; x++, y++) {
          ValidMoveAllPieces(rooks, bishops, queens, this, x, y);                         // loops through each piece and checks
                                                                                  // if they can move to that square
        }
      }
    }
            
  }
  
  void EmptyCastleLane (Square [][] squares) {
    if (isBlack) {
      if (!squares[5][0].OccupiedBlack && !squares[5][0].OccupiedWhite && !squares[6][0].OccupiedBlack && !squares[6][0].OccupiedWhite)
        KingsideLegalBlack = true;
      if (!squares[3][0].OccupiedBlack && !squares[3][0].OccupiedWhite && !squares[2][0].OccupiedBlack && !squares[2][0].OccupiedWhite && !squares[1][0].OccupiedBlack && !squares[1][0].OccupiedWhite)
        QueensideLegalBlack = true;
    }
    else {
      if (!squares[5][7].OccupiedBlack && !squares[5][7].OccupiedWhite && !squares[6][7].OccupiedBlack && !squares[6][7].OccupiedWhite)
        KingsideLegalWhite = true;
      if (!squares[3][7].OccupiedBlack && !squares[3][7].OccupiedWhite && !squares[2][7].OccupiedBlack && !squares[2][7].OccupiedWhite && !squares[1][7].OccupiedBlack && !squares[1][0].OccupiedWhite)
        QueensideLegalWhite = true;
    }
  }
  
  boolean IsSquareAttacked(ArrayList <Square> AttackedSquaresWhite, ArrayList <Square> AttackedSquaresBlack) {
    if (isBlack) {
      for (Square s : AttackedSquaresBlack) {
        if (s.x == this.x && s.y == this.y) 
          return true;
      } 
      return false;
    }
    else {
      for (Square s : AttackedSquaresWhite) {
        if(s.x == this.x && s.y == this.y) 
          return true;
      }
      return false;
    }
  }
  boolean CheckBasicLegalMoves(Square [][] Squares, Rook [] rooks, Pawn [] pawns, King [] kings, Bishop [] bishops, Queen [] queens) { 
    EmptyCastleLane(Squares); // checks to see if empty lanes are open for white or black to castle
                              // turns on booleans kingside/queenside legal for either color
    
    for (Square [] rows : Squares) {
      for (int i = 0; i < rows.length; i++) {
        if (rows[i].active) {
          
          if ((XChange == 1 || XChange == 0 || XChange == -1) && (YChange == 0 || YChange == 1 || YChange == -1) && !isBlack && !rows[i].OccupiedWhite) {           
            //Check for capture
            if (rows[i].OccupiedBlack && !rows[i].AttackedByBlack) {
              AttackingMove = true;
              CapturedOnX = (int) rows[i].x;
              CapturedOnY = (int) rows[i].y;
              BlackIsCaptured = true;
            }
            return true;
          }
          else if ((XChange == 1 || XChange == 0 || XChange == -1) && (YChange == 0 || YChange == 1 || YChange == -1) && isBlack && !rows[i].OccupiedBlack) {
            if (rows[i].OccupiedWhite && !rows[i].AttackedByWhite) {
              AttackingMove = true;
              CapturedOnX = (int) rows[i].x;
              CapturedOnY = (int) rows[i].y;
              BlackIsCaptured = false;
            }
            return true;
          }
          
          else if (FirstMove && !isBlack && XChange == -2 && rooks[0].FirstMove && QueensideLegalWhite && !InCheck) {    //Queenside White Castle  
            rooks[0].CastleMove(kings, pawns, rooks, bishops, queens);
            return true;
          }
          
          else if (FirstMove && !isBlack && XChange == 2 && rooks[1].FirstMove && KingsideLegalWhite && !InCheck) {      //Kingside White Castle
            rooks[1].CastleMove(kings, pawns, rooks, bishops, queens);
            return true;
          }
          
          else if (FirstMove && isBlack && XChange == -2 && rooks[2].FirstMove && QueensideLegalBlack && !InCheck) {    // Queenside Black Castle
            rooks[2].CastleMove(kings, pawns, rooks, bishops, queens);
            return true;
          }
          
          else if (FirstMove && isBlack && XChange == 2 && rooks[3].FirstMove && KingsideLegalBlack && !InCheck) {      // Kingside Black Castle
            rooks[3].CastleMove(kings, pawns, rooks, bishops, queens);
            return true;
          }
           
          else return false;
        }
      }
    }
    
    ////// Turn off all legal castle moves that may have been true
    KingsideLegalWhite = false;
    QueensideLegalWhite = false;
    KingsideLegalBlack = false;
    QueensideLegalBlack = false;
    
    return false;   
  } 
  
  boolean Legal(StateChecker StateChecker, SquareCollection board, Rook [] rooks, Pawn [] pawns, King [] kings, Bishop [] bishops, Queen [] queens) {
    if (CheckBasicLegalMoves(board.squares, rooks, pawns, kings, bishops, queens) && CheckTurnColor(StateChecker) && !IsSquareAttacked(board.AttackedSquaresWhite, board.AttackedSquaresBlack))       
      return true;
    else 
      return false;
  }
  
}
