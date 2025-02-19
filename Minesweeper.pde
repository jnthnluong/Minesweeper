import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 5;
int NUM_COLS = 5;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(800, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < buttons.length; i++){
      for(int g = 0; g < buttons[i].length; g++){
        buttons[i][g] = new MSButton(i,g);
      }
    }
    
    setMines();
}

public void setMines()
{
    //your code
    
    int rRow = (int)(Math.random()*NUM_ROWS);
    int rCol = (int)(Math.random()*NUM_COLS);
    System.out.println(rRow + ", " + rCol);
    mines.add(buttons[rRow][rCol]);
    
    /*
    boolean add = true;
    for(int i = 0; i < buttons.length; i++){
      if((mines.get(i).getRow() == rRow && mines.get(i).getCol() == rCol)){
        add = false;
      }
      
    }
   if(add){
     mines.add(buttons[rRow][rCol]);
   }
   */
   
}

public void draw ()
{
    background( 0 );
   
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
}
public boolean isValid(int r, int c)
{
    //your code here
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public int getRow(){
      return myRow;
    }
    public int getCol(){
      return myCol;
    }
}
