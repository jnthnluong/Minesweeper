import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 25;
int NUM_COLS = 25;
private MyButton hardButton;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private int buttonsClicked = 0;
private boolean isLost = false;

void setup ()
{
  isLost = false;
  buttonsClicked = 0;

  showBombs = false;
  for (int i = mines.size()-1; i >= 0; i--) {
    mines.remove(i);
  }

  size(800, 700);

  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  hardButton = new MyButton(650, 250, 100, 45);
  hardButton.setLabel("RESET");
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  //System.out.println(NUM_ROWS + ", " + NUM_COLS);
  for (int i = 0; i < buttons.length; i++) {
    for (int g = 0; g < buttons[i].length; g++) {
      buttons[i][g] = new MSButton(i, g);
    }
  }

  //about 20% of tiles are mines
  ////System.out.println((int)((NUM_ROWS)*(NUM_COLS)*0.2));
  setMines((int)((NUM_ROWS)*(NUM_COLS)*0.2));

  ////System.out.println(i);
}

public void setMines(int count)
{
  //your code

  int rRow = (int)(Math.random()*NUM_ROWS);
  int rCol = (int)(Math.random()*NUM_COLS);
  ////System.out.println(rRow + ", " + rCol);
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
/*
public void mousePressed() {
 //System.out.println(mouseX + ", " + mouseY);
 }
 */
public void draw ()
{
  // System.out.println(buttonsFlagged);
  // System.out.println(mines.size() + " mines");
  // System.out.println(buttonsClicked);
  background( #44B736 );

  if (isWon() == true)
    displayWinningMessage();

  if (isLost) {
    displayLosingMessage();
    //delay(100);
    toggleBombs(true);
  }
  if (hardButton.isOn()) {
    //System.out.println("onononon");
    setup();
  }
}


public boolean isWon()
{
  //your code here
  for (int i = 0; i < mines.size(); i++) {
    if (mines.get(i).isFlagged() == false) {
      return false;
    }
  }
  for (int i = 0; i < buttons.length; i ++) {
    for (int g = 0; g < buttons[i].length; g++) {
      if (!buttons[i][g].isClicked()) {
        return false;
      }
      if (buttons[i][g].isFlagged() && !mines.contains(buttons[i][g])) {
        return false;
      }
    }
  }
  //System.out.println("WINWINWINWINWIN");
  return (true&&!isLost);
}

public void displayLosingMessage()
{
  //your code here
  fill(255, 0, 0);
  textSize(25);
  text("you died", 700, 350);
  //System.out.println("you died");

  //noLoop();
}
public void displayWinningMessage() // remember to check if all mines are flagged
{
  //System.out.println("SKIBIDI SIGMA OHIO RIZZ");
  for (int i = 0; i < buttons.length; i++) {
    for (int g = 0; g < buttons[i].length; g++) {
    }
  }
  fill(0, 255, 0);
  textSize(25);
  text("you win", 700, 350);
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
  if (isValid(row, col)) {
    for (int i = row-1; i <= row+1; i++) {
      for (int g = col-1; g <= col+1; g++) {
        if (isValid(i, g)) {
          if (mines.contains(buttons[i][g])) {
            numMines++;
          }
        }
      }
    }
  } else {
    ////System.out.println("invalid tile");
  }
  return numMines;
}
private boolean showBombs = false;
public void toggleBombs(boolean on) {
  for (int i = 0; i < buttons.length; i++) {
    for (int g = 0; g < buttons[i].length; g++) {
      if (mines.contains(buttons[i][g])) {
        buttons[i][g].setClicked(on);
        buttons[i][g].draw();
      }
    }
  }
}
public void keyPressed() {
  if (key == 'n' || key == 'N') {
    if (!showBombs) {
      showBombs = true;
      toggleBombs(true);
    }
  }
}

public class MSButton
{
  private int myRow, myCol, myValue;
  private float x, y, width, height;
  private boolean clicked, flagged, showing, isFlower;
  private String myLabel;
  private color myColor;

  public MSButton ( int row, int col )
  {
    myColor = color((int)(Math.random()*255+90), (int)(Math.random()*255+60), (int)(Math.random()*200));
    width = 600/NUM_COLS;
    height = 600/NUM_ROWS;
    myValue = 0;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    showing = false;
    //System.out.println(showing);
    //System.out.println(flagged);
    // System.out.println(clicked);
    Interactive.add( this ); // register it with the manager
    if ((int)(Math.random()*100) < 5) isFlower = true;
  }

  // called by manager


  public void mousePressed () 
  {
    isFlower = false;
    //System.out.println(buttonsClicked);
    if (buttonsClicked <= 1 && mouseButton == LEFT) {
      buttonsClicked++;
      if (mines.contains(this)) { // makes it impossible to immediately lose
        mines.remove(this);
      }

      for (int i = myRow-1; i <= myRow+1; i++) { // starts the first blob no matter what
        for (int g = myCol-1; g <= myCol+1; g++) {
          if (isValid(i, g) && !buttons[i][g].isClicked() && !buttons[i][g].isFlagged() && !mines.contains(buttons[i][g]) && mouseButton != RIGHT) {
            if (mouseButton == LEFT) {
              buttons[i][g].mousePressed();
            }
          }
        }
      }
    }
    if (!isLost)clicked = true;



    if (mouseButton == RIGHT && !showing && !isLost) {

      flagged = !flagged;

      if (!flagged) clicked = false;
    } else if (mines.contains(this) && !flagged) {
      displayLosingMessage();
      isLost = true;
    } else if (countMines(myRow, myCol)>0 && !flagged && !isLost) {
      myValue = countMines(myRow, myCol);
      setLabel(countMines(myRow, myCol));
    } else {
      for (int i = myRow-1; i <= myRow+1; i++) {
        for (int g = myCol-1; g <= myCol+1; g++) {
          if (isValid(i, g) && !buttons[i][g].isClicked() && !buttons[i][g].isFlagged() && !mines.contains(buttons[i][g]) && !flagged && mouseButton != RIGHT && !isLost) {
            buttons[i][g].mousePressed();
          }
        }
      }
    }
    //your code here
  }
  public void draw () 
  {
    if (isLost) {
      myColor = 0;
    }
    if (isWon()) {
      isFlower = true;
    }

    if (flagged && !showing) {
      fill(255, 255, 0);
    } else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked && !flagged) {
      fill(#EAC547);
      showing = true;
    } else {
      fill(110, 255, 100);
      if (myCol%2 == 0 || myRow%2 == 0) fill(#22C95B);
    }

    if (isWon() == true) {
      fill(0, 255, 0);
    }
    if (isLost) {
      fill(#79654F);
      if (myCol%2 == 0 || myRow%2 == 0) fill(#676057);
    }
    if ( clicked && mines.contains(this) && !flagged ) 
      fill(255, 0, 0);
    rect(x, y, width, height);
    if (myValue == 1) fill(0, 0, 255);
    if (myValue == 2) fill(#37A042);
    if (myValue == 3) fill(255, 0, 0);
    if (myValue == 4) fill(127, 0, 255);
    if (myValue == 5) fill(255, 140, 0);
    if (myValue == 6) fill(0, 255, 255);
    if (myValue == 7) fill(0, 0, 128);// i guess we will never see these two
    if (myValue == 8) fill(211, 211, 211);
    if (isFlower) {
      fill(myColor);
      ellipse(x+width/1.5-4, y+height/2, 10, 10+10);
      ellipse(x+width/1.5-4, y+height/2, 10+10, 10);
      fill(#FEFFBC);
      if (isLost) fill(#463E3E);
      ellipse(x+width/1.5-4, y+height/2, 10, 10);
    }
    textSize(width/1.5);
    text(myLabel, x+width/2+0.5, y+height/2-1);
  }
  public void setShowing(boolean s) {
    showing = s;
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
  public void setFlagged(boolean f) {
    flagged = f;
  }
  public boolean isClicked() {
    return clicked;
  }
  public void setClicked(boolean c) {
    clicked = c;
  }

  public int getRow() {
    return myRow;
  }
  public int getCol() {
    return myCol;
  }
} // end minesweeper button class

/*
public  void setDifficulty(int size) {
 NUM_ROWS = size;
 NUM_COLS = size;
 setup();
 //System.out.println("Reset and difficulty changed");
 }
 */
public class MyButton
{
  private float x, y, width, height;
  private boolean on;
  private String myLabel;
  public MyButton ( float xx, float yy, float w, float h )
  {
    x = xx; 
    y = yy; 
    width = w; 
    height = h;
    myLabel = "";
    Interactive.add( this ); // register it with the manager
  }
  public void mousePressed () { 
    on = !on;
  }
  public void mouseReleased() {
    on = !on;
  }



  public void draw ()
  {
    if ( on ) {
      fill(200, 0, 0 );
      //setup();
    } else fill(100, 150, 205);  
    rect(x, y, width, height);
    fill(0);
    textSize(25);
    text(myLabel, x+width/2, y+height/2-3);
  }
  public boolean isOn() {
    return on;
  }
  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }
}
