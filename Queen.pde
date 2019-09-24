class Queen extends Piece {
  PImage QueenImage;
  ArrayList <Square> QueenAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> QueenAttackedSquaresBlack = new ArrayList();
  
  boolean StopUp = false , StopDown = false, StopRight = false, StopLeft = false;
  boolean StopDownRight = false, StopDownLeft = false, StopUpRight = false, StopUpLeft = false;
  
  boolean StopUpPin = false, StopDownPin = false, StopRightPin = false, StopLeftPin = false;
  boolean StopUpRightPin = false, StopDownRightPin = false, StopDownLeftPin = false, StopUpLeftPin = false;
  
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
  
  //void mouseReleased(SquareCollection board, ArrayList<Piece> pieces, King [] kings, Pawn [] pawns, Rook [] rooks, Bishop [] bishops) {
  //  if (active && visible) {      
  //    GetXYChange(board, mouseX, mouseY);
  //    LockPieceToSquare(board.squares);
  //    active = false;
      
  //    CheckIfPinned(board, pieces, rooks, bishops);
      
  //    if (Legal(board, pieces, kings, pawns, rooks, bishops)) 
  //    {  
  //     if (AttackingMove) 
  //        Capture(pieces);
          
  //      AttackingMove = false;
        
  //      StateChecker.FlipColor();
          
  //      UpdateXYIndices(board);
        
  //      UpdateOccupiedSquares(board, pieces);
  //      UpdateOccupiedSquaresPin(board,pieces);
        
  //      UpdateAllPiecesAttackedSquares(board, kings, pawns, rooks, bishops);
        
  //      UpdatePinnedSquares(board);
        
  //      KingPutInCheckAllPieces(board, kings, pawns, rooks, bishops);
                                     
  //   } else {
  //      this.x = InitXCoord;
  //      this.y = InitYCoord;
  //    }
  //  }
  //}
  
  void UpdateAttackedSquares(SquareCollection board) {
  
    /* clear out old lists */
    ClearAttackedSquares(QueenAttackedSquaresWhite, QueenAttackedSquaresBlack, true);
    
    //Add all squares that rook attacks
    if (visible) {
      for (int i = 1; i < 8; i++) { 
        if (!StopUpRight) {
          AttackedSqAlg(board.squares, 1, -1, i);
        }
        else if (!StopDownRight) {
          AttackedSqAlg(board.squares, 1, 1, i);
        }
        else if (!StopDownLeft) {
          AttackedSqAlg(board.squares, -1, 1, i);
        }
        else if (!StopUpLeft) {
          AttackedSqAlg(board.squares, -1, 1, i);
        }  
        else if (!StopRight) {
          AttackedSqAlg(board.squares, 1, 0, i);
        }
        else if (!StopLeft) {
          AttackedSqAlg(board.squares, -1, 0, i);
        }
        else if (!StopDown) {
          AttackedSqAlg(board.squares, 0, 1, i);
        }
        else if (!StopUp) {
          AttackedSqAlg(board.squares, 0, -1, i);
        }   
      }
      
      if (isBlack) {
        for (Square s : QueenAttackedSquaresBlack) {
          board.AttackedSquaresBlack.add(s);
        }
      }
      else {
        for (Square s : QueenAttackedSquaresWhite) {
          board.AttackedSquaresWhite.add(s);
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
  
  //void KingPutInCheck(King [] kings, SquareCollection board) { 
  // //kings[0] == white king, kings[1] == black king
  //  if (isBlack) {
  //    for (Square s : RookAttackedSquaresWhite) {
  //      if (kings[0].x == s.x && kings[0].y == s.y) {
  //        kings[0].InCheck = true;     
  //        kings[0].AttackedByThesePieces.add(this);
          
  //        CalcSquaresBetweenThisAndKing(kings, board);
  //      }
  //    }
  //  } else {
  //    for (Square s : RookAttackedSquaresBlack) {
  //      if (kings[1].x == s.x && kings[1].y == s.y) {
  //        kings[1].InCheck = true;
  //        kings[1].AttackedByThesePieces.add(this);
          
  //        CalcSquaresBetweenThisAndKing(kings, board);
  //      }
  //    }
  //  }
  //}
}
