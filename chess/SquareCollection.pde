class SquareCollection
{
  Square [] [] squares;
  ArrayList <Square> AttackedSquaresWhite = new ArrayList();
  ArrayList <Square> AttackedSquaresBlack = new ArrayList();
  int [] SquareNumbers = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64, 65};
  float [] SquareYValues = {0,60,120,180,240,300,360,420,0,60,120,180,240,300,360,420,0,60,120,180,240,300,360,420,0,60,120,180,240,300,360,420,0,60,120,180,240,300,360,420,0,60,120,180,240,300,360,420,0,60,120,180,240,300,360,420,0,60,120,180,240,300,360,420};
  float [] SquareXValues = {0,0,0,0,0,0,0,0,60,60,60,60,60,60,60,60,120,120,120,120,120,120,120,120,180,180,180,180,180,180,180,180,240,240,240,240,240,240,240,240,300,300,300,300,300,300,300,300,360,360,360,360,360,360,360,360,420,420,420,420,420,420,420,420};
  int ColorCounter = 1;
  boolean BlackSquareTurn = true;
  
  public SquareCollection() { }
  
  void createSquares()
  {
    squares = new Square[8][8];
    int i = 0;
    for (int rows = 0; rows < 8; rows++)
    {
      for (int columns = 0; columns < 8; columns++)
      {
        if (ColorCounter != 8)
        {
          if (BlackSquareTurn == false)
          { //<>//
            squares[rows][columns] = new Square(SquareXValues[i], SquareYValues[i], false, SquareNumbers[i]);
            BlackSquareTurn = true;
            i++;
          }
          else 
          {
            squares[rows][columns] = new Square(SquareXValues[i], SquareYValues[i], true, SquareNumbers[i]);
            BlackSquareTurn = false;
            i++;
          }
          ColorCounter++;
        }
        else 
        {
          if (BlackSquareTurn == false)
          {
            squares[rows][columns] = new Square(SquareXValues[i], SquareYValues[i], false, SquareNumbers[i]);
            i++;
          }
          else 
          {
            squares[rows][columns] = new Square(SquareXValues[i], SquareYValues[i], true, SquareNumbers[i]);
            i++;
          }
          ColorCounter = 1;
        } //<>//
      }
    }
  }
  
  /* These methods will find the x and y indeces of the squares [][] given the coordinates of the mouse*/
  
  int GetXIndexMouse(float mousex)
  {
   for(int row = 0; row < 8; row++)
   {
     for(int column = 0; column < 8; column++)
     {
       if ((squares[row][column].x - mousex) > -40 && (squares[row][column].x - mousex) < 1)
       {
         return row;
       }
     }
   }
   return 0;
  }
  
  int GetYIndexMouse(float mousey)
  {
   for(int row = 0; row < 8; row++)
   {
     for(int column = 0; column < 8; column++)
     {
       if ((squares[row][column].y - mousey) > -40 && (squares[row][column].y - mousey) < 1)
       {
         return column;
       }
     }
   }
   return 0;
  }
  
  // Fall through to activating Square methods:
  void draw()
  {
    for (Square[] rows : squares)
    {
      for (Square s : rows)
      {
        s.draw();
      }
    }
  }
  void mouseDragged(int mousex, int mousey) 
  {
    for (Square[] rows : squares)
    {
      for (Square s : rows)
      {
        s.mouseDragged(mousex, mousey);
      }
    }
  }
  void mouseReleased()
  {
    for (Square[] rows : squares)
    {
      for (Square s : rows)
      {
        s.mouseReleased();
      }
    }
  }
}
