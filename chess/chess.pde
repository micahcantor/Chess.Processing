PawnCollection pawns;
KingCollection kings;
SquareCollection board;
StateChecker StateChecker;

void setup()
{
  size(480, 480);
  
  PImage WhitePawn = loadImage("WhitePawn.png");
  PImage BlackPawn = loadImage("BlackPawn.png");
  PImage WhiteKing = loadImage("WhiteKing.png");
  PImage BlackKing = loadImage("BlackKing.png");
  
  pawns = new PawnCollection(WhitePawn, BlackPawn);
  kings = new KingCollection(WhiteKing, BlackKing);
  board = new SquareCollection();
  StateChecker = new StateChecker();
  
  board.createSquares();
  pawns.createPawns(board.squares, board);
  kings.createKings();
  
  noLoop();
}

void draw() 
{
  background (255);
  board.draw();
  pawns.draw(); 
  kings.draw();
}

// fall through event handling
void mouseMoved() 
{ 
  pawns.mouseMoved(mouseX, mouseY);
  kings.mouseMoved(mouseX, mouseY);
  redraw();
}
void mousePressed() 
{
  pawns.mousePressed(mouseX, mouseY, board);
  kings.mousePressed(mouseX, mouseY, board);
  redraw();
}
void mouseDragged() 
{ 
  pawns.mouseDragged(mouseX, mouseY);
  kings.mouseDragged(mouseX, mouseY);
  board.mouseDragged(mouseX, mouseY);
  redraw(); 
}
void mouseReleased() 
{
  pawns.mouseReleased(board, board.squares, StateChecker, pawns.pawns, kings.kings);
  kings.mouseReleased(board, board.squares, pawns.pawns);
  redraw(); 
}
