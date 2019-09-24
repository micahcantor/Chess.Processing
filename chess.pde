import java.util.Arrays;
import java.util.Collections;

PawnCollection pawns;
KingCollection kings;
RookCollection rooks;
BishopCollection bishops;
QueenCollection queens;

ArrayList <Piece> pieces;
SquareCollection board;
StateChecker StateChecker;

void setup() {
  size(480, 480);
  
  PImage WhitePawn = loadImage("icons/WhitePawn.png");
  PImage BlackPawn = loadImage("icons/BlackPawn.png");
  
  PImage WhiteKing = loadImage("icons/WhiteKing.png");
  PImage BlackKing = loadImage("icons/BlackKing.png");
  
  PImage WhiteRook = loadImage("icons/WhiteRook.png");
  PImage BlackRook = loadImage("icons/BlackRook.png");
  
  PImage WhiteBishop = loadImage("icons/WhiteBishop.png");
  PImage BlackBishop = loadImage("icons/BlackBishop.png");
  
  PImage WhiteQueen = loadImage("icons/WhiteQueen.png");
  PImage BlackQueen = loadImage("icons/BlackQueen.png");
  
  pawns   = new PawnCollection(WhitePawn, BlackPawn);
  kings   = new KingCollection(WhiteKing, BlackKing);
  rooks   = new RookCollection(WhiteRook, BlackRook);
  bishops = new BishopCollection(WhiteBishop, BlackBishop);
  queens  = new QueenCollection(WhiteQueen, BlackQueen);
  pieces  = new ArrayList<Piece>();
  
  board   = new SquareCollection();
  StateChecker = new StateChecker();
  
  board.createSquares();
  pawns.createPawns(pieces);
  kings.createKings(pieces);
  rooks.createRooks(pieces);
  bishops.createBishops(pieces);
  queens.createQueens(pieces);
  
  UpdatePieces();
  
  noLoop();
}

void UpdatePieces() {
  
  for (Piece pi : pieces) {
    pi.UpdateOccupiedSquares(board, pieces);
    pi.UpdateOccupiedSquaresPin(board,pieces);
  }
  
  for (King k : kings.kings) {
    k.UpdateAttackedSquares(board);
    k.SquareOccupiedKing(board);
  }
  for (Pawn p : pawns.pawns) {
    p.UpdateAttackedSquares(board);
  }
  for (Rook r : rooks.rooks) {
    r.UpdateAttackedSquares(board);
  }
  for (Bishop b : bishops.bishops) {
    b.UpdateAttackedSquares(board);
  }
  for (Queen q : queens.queens) {
    q.UpdateAttackedSquares(board);
  }
}

void draw() 
{
  background (255);
  board.draw();
  pawns.draw(); 
  kings.draw();
  rooks.draw();
  queens.draw();
  bishops.draw();
}

// fall through event handling
void mouseMoved() 
{ 
  pawns.mouseMoved(mouseX, mouseY);
  kings.mouseMoved(mouseX, mouseY);
  rooks.mouseMoved(mouseX, mouseY);
  bishops.mouseMoved(mouseX , mouseY);
  queens.mouseMoved(mouseX, mouseY);
  redraw();
}
void mousePressed() 
{
  pawns.mousePressed(mouseX, mouseY, board);
  kings.mousePressed(mouseX, mouseY, board);
  rooks.mousePressed(mouseX, mouseY, board);
  bishops.mousePressed(mouseX, mouseY, board);
  queens.mousePressed(mouseX, mouseY, board);
  redraw();
}
void mouseDragged() 
{ 
  pawns.mouseDragged(mouseX, mouseY);
  kings.mouseDragged(mouseX, mouseY);
  rooks.mouseDragged(mouseX, mouseY);
  bishops.mouseDragged(mouseX, mouseY);
  board.mouseDragged(mouseX, mouseY);
  queens.mouseDragged(mouseX, mouseY);
  redraw(); 
}
void mouseReleased() 
{
  pawns.mouseReleased(board, StateChecker, pieces, pawns.pawns, kings.kings, rooks.rooks, bishops.bishops);
  kings.mouseReleased(board, pieces, kings.kings, pawns.pawns, rooks.rooks, bishops.bishops);
  rooks.mouseReleased(board, pieces, kings.kings, pawns.pawns, rooks.rooks, bishops.bishops);
  bishops.mouseReleased(board, pieces, rooks.rooks, kings.kings, pawns.pawns, bishops.bishops);
  
  redraw(); 
}
