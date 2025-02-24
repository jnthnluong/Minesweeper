import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 25;
int NUM_COLS = 25;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(800, 500);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < buttons.length; i++) {
    for (int g = 0; g < buttons[i].length; g++) {
      buttons[i][g] = new MSButton(i, g);
    }
  }

  //about 20% of tiles are mines
  //System.out.println((int)((NUM_ROWS)*(NUM_COLS)*0.2));
  setMines((int)((NUM_ROWS)*(NUM_COLS)*0.2));
  //System.out.println(i);
}

public void setMines(int count)
{
  //your code

  int rRow = (int)(Math.random()*NUM_ROWS);
  int rCol = (int)(Math.random()*NUM_COLS);
  //System.out.println(rRow + ", " + rCol);
  for (int i = 0; i < count; i++) {
    rRow = (int)(Math.random()*NUM_ROWS);
    rCol = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[rRow][rCol])) {
      mines.add(buttons[rRow][rCol]);
    } else {
      i--; // rerolling if there is a duplicate location
    }
  }
}
public void draw ()
{
  background( 0 );

  if (isWon() == true)
    displayWinningMessage();
}

public boolean isWon()
{
  //your code here
  for(int i = 0; i < buttons.length; i++){
    for(int g = 0; g < buttons[i].length; g++){
      if(!(buttons[i][g].flagged == true || buttons[i][g].clicked == true)){
        return false;
      }
    }
  }
 
  
  return true;
}
public void displayLosingMessage()
{
  //your code here
  //System.out.println("you died");
  noLoop();
}
public void displayWinningMessage()
{
  //System.out.println("SKIBIDI SIGMA OHIO RIZZ");
  //your code here
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r < 0 || c < 0) return false;
  if (r < NUM_ROWS && c < NUM_COLS) return true;
  return false;
  
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  if(isValid(row,col)){
    for(int i = row-1; i <= row+1; i++){
      for(int g = col-1; g <= col+1; g++){
        if(isValid(i,g)){
          if(mines.contains(buttons[i][g])){
            numMines++;
          }
        }
      }
    }
  }else{
    System.out.println("invalid tile");
  }
  return numMines;
}
private int buttonsClicked = 0;
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
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
    if(buttonsClicked <= 1){
      buttonsClicked++;
      if(mines.contains(this)){ // makes it impossible to immediately lose
        mines.remove(this);
      }
      
      for(int i = myRow-1; i <= myRow+1; i++){
        for(int g = myCol-1; g <= myCol+1; g++){
          if(isValid(i,g) && !buttons[i][g].isClicked() && !buttons[i][g].isFlagged() && !mines.contains(buttons[i][g])){
            buttons[i][g].mousePressed();
          }
        }
      }
      
    }
    clicked = true;
    if(mouseButton == RIGHT){
      flagged = !flagged;
    }else if(mines.contains(this)){
      
      displayLosingMessage();
    }else if(countMines(myRow,myCol)>0){
      setLabel(countMines(myRow,myCol));
    }else{
      // recursively call mousePressed??
      for(int i = myRow-1; i <= myRow+1; i++){
        for(int g = myCol-1; g <= myCol+1; g++){
          if(isValid(i,g) && !buttons[i][g].isClicked() && !buttons[i][g].isFlagged() && !mines.contains(buttons[i][g])){
            buttons[i][g].mousePressed();
          }
        }
      }
    }
    //your code here
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
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
  public boolean isClicked(){
    return clicked;
  }

  public int getRow() {
    return myRow;
  }
  public int getCol() {
    return myCol;
  }
}
