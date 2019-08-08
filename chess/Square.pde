class Square
{
  float x, y, l;
  boolean active;
  boolean isBlack;
  color black, white;
  PShape SquareShape;
  int squarenumber;
  boolean OccupiedWhite, OccupiedBlack;
  
   public Square(float _x, float _y, boolean _isBlack, int _squarenumber) {
    x = _x;
    y = _y;
    l = 60;
    isBlack = _isBlack;
    SquareShape = createShape(RECT, x, y, l, l);
    black = color(232, 235, 239);
    white = color(80 , 135, 150);
    squarenumber = _squarenumber;
  }
  
  String toString() {
    return(String.valueOf(squarenumber));
  }
  
  void draw() {    
    if (isBlack) 
      fill(black);
    else 
      fill(white);
      
    rect(x , y, l, l);
  }
  
  void mouseDragged(int mousex, int mousey) {
    active = over(mousex, mousey);
  }
  void mouseReleased() {
    active = false;
  }
 
  boolean over(int mousex, int mousey) {
    return(mousex >= x && mousex <= x + 60 && mousey >= y && mousey <= y + 60); 
  }
}
