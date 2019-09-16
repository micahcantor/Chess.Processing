class Queen extends Piece {
  PImage QueenImage;
  ArrayList <Square> QueenAttackedSquaresWhite = new ArrayList();
  ArrayList <Square> QueenAttackedSquaresBlack = new ArrayList();
  boolean StopUp = false , StopDown = false, StopRight = false, StopLeft = false;
  boolean StopUpPin = false, StopDownPin = false, StopRightPin = false, StopLeftPin = false;
  
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
}
