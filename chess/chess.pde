import java.util.Arrays;
import java.util.Collections;

PawnCollection pawns;
KingCollection kings;
RookCollection rooks;
ArrayList <Piece> pieces;
SquareCollection board;
StateChecker StateChecker;

void setup()
{
  size(480, 480);
  
  PImage WhitePawn = loadImage("WhitePawn.png");
  PImage BlackPawn = loadImage("BlackPawn.png");
  
  PImage WhiteKing = loadImage("WhiteKing.png");
  PImage BlackKing = loadImage("BlackKing.png");
  
  PImage WhiteRook = loadImage("WhiteRook.png");
  PImage BlackRook = loadImage("BlackRook.png");
  
  pawns = new PawnCollection(WhitePawn, BlackPawn);
  kings = new KingCollection(WhiteKing, BlackKing);
  rooks = new RookCollection(WhiteRook, BlackRook);
  pieces = new ArrayList<Piece>();
  
  board = new SquareCollection();
  StateChecker = new StateChecker();
  
  board.createSquares();
  pawns.createPawns(pieces);
  kings.createKings(pieces);
  rooks.createRooks(pieces);
  
  UpdatePieces();
  
  noLoop();
}

void UpdatePieces() {
  
  for (Piece pi : pieces) {
    pi.UpdateOccupiedSquares(board, pieces);
  }
    
  for (King k : kings.kings) {
    k.UpdateAttackedSquares(board);
  }
  for (Pawn p : pawns.pawns) {
    p.UpdateAttackedSquares(board);
  }
  for (Rook r : rooks.rooks) {
    r.UpdateAttackedSquares(board);
  }
}

void draw() 
{
  background (255);
  board.draw();
  pawns.draw(); 
  kings.draw();
  rooks.draw();
}

// fall through event handling
void mouseMoved() 
{ 
  pawns.mouseMoved(mouseX, mouseY);
  kings.mouseMoved(mouseX, mouseY);
  rooks.mouseMoved(mouseX, mouseY);
  redraw();
}
void mousePressed() 
{
  pawns.mousePressed(mouseX, mouseY, board);
  kings.mousePressed(mouseX, mouseY, board);
  rooks.mousePressed(mouseX, mouseY, board);
  redraw();
}
void mouseDragged() 
{ 
  pawns.mouseDragged(mouseX, mouseY);
  kings.mouseDragged(mouseX, mouseY);
  rooks.mouseDragged(mouseX, mouseY);
  board.mouseDragged(mouseX, mouseY);
  redraw(); 
}
void mouseReleased() 
{
  pawns.mouseReleased(board, board.squares, StateChecker, pawns.pawns, kings.kings, rooks.rooks, pieces);
  kings.mouseReleased(board, pieces, kings.kings, pawns.pawns, rooks.rooks);
  rooks.mouseReleased(board, rooks.rooks, kings.kings, pawns.pawns);
  kings.kings[0].AttackedSquaresLogging(board);
  redraw(); 
}
