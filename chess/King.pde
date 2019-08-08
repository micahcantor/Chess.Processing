//Todo method CheckChekmate

class King extends Piece
{
  PImage KingImage;
  boolean InCheck;
  boolean NoLegalMovesBlack, NoLegalMovesWhite;
  boolean AttackingPieceUncaptureableBlack, AttackingPieceUncaptureableWhite;
  boolean UnblockableAttackBlack, UnblockableAttackWhite;
  ArrayList <Piece> AttackedByThesePieces = new ArrayList<Piece>();
  ArrayList <Square> KingAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> KingAttackedSquaresBlack = new ArrayList();
  
  public King(PImage _KingImage, boolean _isBlack, float _x, float _y) {
    KingImage = _KingImage;
    isBlack = _isBlack;
    x = _x;
    y = _y;
    l = 60;
  }
  
  void draw() {
    image(KingImage, x + offsetx, y + offsety, l, l);
  }
  
  void mouseReleased(SquareCollection board, ArrayList <Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks) {
    if (active) {      
      GetXYChange(board, mouseX, mouseY);
      LockPieceToSquare(board.squares);
      active = false;      

      if (Legal(StateChecker, board, board.AttackedSquaresWhite, board.AttackedSquaresBlack)) {
        UpdateXYIndices(board);
        
        if (AttackingMove)
          Capture(pieces);
        
        for (King k : kings) {
          k.UpdateAttackedSquares(board);
        }
        for (Pawn p : pawns) {
          p.UpdateAttackedSquares(board);
        }
        for (Rook r : rooks) {
          r.UpdateAttackedSquares(board);
        }
          
        FirstMove = false;
        StateChecker.FlipColor();
        
        UpdateOccupiedSquares(board, pieces);
        
        KingPutInCheck(kings);   
        OutOfCheck(board.AttackedSquaresWhite, board.AttackedSquaresBlack);
                
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
    return ("King " + String.valueOf(snumber));
  }
  
  void OutOfCheck(ArrayList AttackedSquaresWhite, ArrayList AttackedSquaresBlack)
  {
    if (this.InCheck == true && IsSquareAttacked(AttackedSquaresWhite, AttackedSquaresBlack) == false) {
      this.InCheck = false;
      AttackedByThesePieces.clear();
    }
  }
  
  boolean Checkmate(SquareCollection board, Rook [] rooks)
  {
    //If you cannot move to any unattacked squares
    CheckLegalKingMoves(board);
    
    //If the attacking piece is not on an attacked square for their color
    IsPieceCaptureable(board); 
    
    //If the move cannot be blocked
    CanMoveBeBlocked(board, rooks);
    
    if (isBlack) {
      if (NoLegalMovesBlack && AttackingPieceUncaptureableBlack && UnblockableAttackBlack)
        return true;
    }
    
    else {
      if (NoLegalMovesWhite && AttackingPieceUncaptureableWhite && UnblockableAttackWhite)
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
    
    for (Piece pi : AttackedByThesePieces) {
      if (pi.isBlack) {
        for (Square s : board.AttackedSquaresBlack) {
          if (pi.x == s.x && pi.y == s.y)
            AttackingPieceUncaptureableBlack = false;
        }
      }
      else {
        for (Square s : board.AttackedSquaresWhite) {
          if (pi.x == s.x && pi.y == s.y)
            AttackingPieceUncaptureableWhite = false;
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
        } catch(IndexOutOfBoundsException e){}   
         try {
          KingAttackedSquaresWhite.add(squares[CurrentX][CurrentY + 1]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY + 1]);
        } catch(IndexOutOfBoundsException e){}
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX - 1][CurrentY - 1]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX][CurrentY - 1]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresWhite.add(squares[CurrentX + 1][CurrentY - 1]);
        } catch(IndexOutOfBoundsException e){}   
        
        for (Square s : KingAttackedSquaresWhite) {
          board.AttackedSquaresWhite.add(s);
        }
      }
    }
    else //white pieces
    {  
      ClearAttackedSquares(KingAttackedSquaresWhite, KingAttackedSquaresBlack, false);
      
      if (visible) {
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY + 1]);
        } catch(IndexOutOfBoundsException e){}   
         try {
          KingAttackedSquaresBlack.add(squares[CurrentX][CurrentY + 1]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY + 1]);
        } catch(IndexOutOfBoundsException e){}
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX - 1][CurrentY - 1]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX][CurrentY - 1]);
        } catch(IndexOutOfBoundsException e){}   
        try {
          KingAttackedSquaresBlack.add(squares[CurrentX + 1][CurrentY - 1]);
        } catch(IndexOutOfBoundsException e){}
        
        for (Square s : KingAttackedSquaresBlack) {
          board.AttackedSquaresBlack.add(s);
        }
      }
    } 
    
   //AttackedSquaresLogging(board);

  }
  
  void KingPutInCheck(King [] kings) { 
   //kings[0] == white king, kings[1] == black king
    if (isBlack) {
      for (Square s : KingAttackedSquaresWhite) {
        if (kings[0].x == s.x && kings[0].y == s.y) {
          kings[0].InCheck = true;     
          kings[1].AttackedByThesePieces.add(this);
        }
      }
    } else {
      for (Square s : KingAttackedSquaresBlack) {
        if (kings[1].x == s.x && kings[1].y == s.y) {
          kings[1].InCheck = true;
          kings[1].AttackedByThesePieces.add(this);
        }
      }
    }
  }
  
  void CanMoveBeBlocked(SquareCollection board, Rook [] rooks) {
    
    int PiecesThatCanBlockWhite = 0, PiecesThatCanBlockBlack = 0;
    
    if (AttackedByThesePieces.size() == 0)  //stop function if king is not attacked
      return;
      
    // If attacked by more than one piece, it can't be blocked
    if (AttackedByThesePieces.size() > 1) {
      if (isBlack) 
        UnblockableAttackBlack = true;     
      else
        UnblockableAttackWhite = true;
    }
   
     
    if (AttackedByThesePieces.get(0).getClass().getSimpleName().equals("Pawn")) {    // if attacked by pawn
      //Pawn attacks can't be blocked
      
      if (isBlack)
        UnblockableAttackBlack = true;
      else
        UnblockableAttackWhite = true;
    }
    
    if (AttackedByThesePieces.get(0).getClass().getSimpleName().equals("Rook")) {    // if attacked by rook
      
      int XDiff = AttackedByThesePieces.get(0).XInd - this.XInd;
      int YDiff = AttackedByThesePieces.get(0).YInd - this.YInd;
      
   ///////// rook attacking from BELOW king  /////////////
      if (YDiff > 0) {                   
        for (int i = this.YInd + 1; i < AttackedByThesePieces.get(0).YInd; i++) { // for each square between rook and king
          if (isBlack) {    // black king
            for (Rook r : rooks) {
              if (r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockBlack++;
              }
            }
          }
          else {           // white king
            for (Rook r : rooks) {
              if (!r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockWhite++;
              }
            }
          }
        }
        
        if (PiecesThatCanBlockBlack == 0)
          UnblockableAttackBlack = true;
        if (PiecesThatCanBlockWhite == 0)
          UnblockableAttackWhite = true;
          
      }

    ///////// rook attacking from the ABOVE of king ///////////////////////
      if (YDiff < 0) {                   
        for (int i = this.YInd - 1 ; i > AttackedByThesePieces.get(0).YInd; i--) { // for each square between rook and king
          if (isBlack) {    // black king
            for (Rook r : rooks) {
              if (r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockBlack++;
              }
            }
          }
          else {           // white king
            for (Rook r : rooks) {
              if (!r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockWhite++;
              }
            }
          }
        }
        
        if (PiecesThatCanBlockBlack == 0)
          UnblockableAttackBlack = true;
        if (PiecesThatCanBlockWhite == 0)
          UnblockableAttackWhite = true;
          
      }
      
    ///////////// rook attacking from LEFT of king ////////////////////////
      if (XDiff < 0) {                   
        for (int i = this.XInd - 1; i > AttackedByThesePieces.get(0).XInd; i--) { // for each square between rook and king
          if (isBlack) {    // black king
            for (Rook r : rooks) {
              if (r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockBlack++;
              }
            }
          }
          else {           // white king
            for (Rook r : rooks) {
              if (!r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockWhite++;
              }
            }
          }
        }
        
        if (PiecesThatCanBlockBlack == 0)
          UnblockableAttackBlack = true;
        if (PiecesThatCanBlockWhite == 0)
          UnblockableAttackWhite = true;
          
      }
      
    ///////////// rook attacking from RIGHT of king ////////////////////////
      if (XDiff > 0) {                   
        for (int i = this.XInd + 1; i < AttackedByThesePieces.get(0).XInd; i++) { // for each square between rook and king
          if (isBlack) {    // black king
            for (Rook r : rooks) {
              if (r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockBlack++;
              }
            }
          }
          else {           // white king
            for (Rook r : rooks) {
              if (!r.isBlack) {
                if (r.ValidMove(board, this.XInd, i))
                  PiecesThatCanBlockWhite++;
              }
            }
          }
        }
        
        if (PiecesThatCanBlockBlack == 0)
          UnblockableAttackBlack = true;
        if (PiecesThatCanBlockWhite == 0)
          UnblockableAttackWhite = true;
          
      }
      
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
  boolean CheckBasicLegalMoves(Square [][] Squares) {  
    for (Square [] rows : Squares) {
      for (int i = 0; i < rows.length; i++) {
        if (rows[i].active) {
          if ((XChange == 1 || XChange == 0 || XChange == -1) && (YChange == 0 || YChange == 1 || YChange == -1) && !isBlack && !rows[i].OccupiedWhite) {
            
            //Check for capture
            if (rows[i].OccupiedBlack) {
              AttackingMove = true;
              CapturedOnX = (int) rows[i].x;
              CapturedOnY = (int) rows[i].y;
              BlackIsCaptured = true;
            }
            return true;
          }
          else if ((XChange == 1 || XChange == 0 || XChange == -1) && (YChange == 0 || YChange == 1 || YChange == -1) && isBlack && !rows[i].OccupiedBlack) {
            if (rows[i].OccupiedWhite) {
              AttackingMove = true;
              CapturedOnX = (int) rows[i].x;
              CapturedOnY = (int) rows[i].y;
              BlackIsCaptured = false;
            }
            return true;
          }
          
          else return false;
        }
      }
    }
    return false;
  } 
  
  boolean Legal(StateChecker StateChecker, SquareCollection board, ArrayList <Square> AttackedSquaresWhite, ArrayList <Square> AttackedSquaresBlack) {
    if (CheckBasicLegalMoves(board.squares) && CheckTurnColor(StateChecker) && !IsSquareAttacked(AttackedSquaresWhite, AttackedSquaresBlack))       
      return true;
    else 
      return false;
  }
  
}
