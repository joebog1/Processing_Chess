StringDict pos; // Initilise a string dictonary to store the position of all the pieces 
int[] gridPos; // Initilise an int to store the grid number on which the mouse is hovering
float squareSize; // Initilise the squareSize of each square on the grid (This scales with size)
float boardTLP; // Initilise the coordinate of the top left corner not including all the borders

String currentPiece = "None";
int[] currentPiecePos;

boolean whiteTurn;

PImage BRook;
PImage BKnight;
PImage BBishop;
PImage BQueen;
PImage BKing;
PImage BPawn;

PImage WRook;
PImage WKnight;
PImage WBishop;
PImage WQueen;
PImage WKing;
PImage WPawn;

// Setup what is required in this function
void setup(){
  size(800, 800); // Set the size to 800 pixels by 800 pixels (This is scalable but only in square)
  pos = new StringDict();
  gridPos = new int[3];
  currentPiecePos = new int[3];
  
  whiteTurn = true;
  
  BRook = loadImage("BRook.png");
  BKnight = loadImage("BKnight.png");
  BBishop = loadImage("BBishop.png");
  BQueen = loadImage("BQueen.png");
  BKing = loadImage("BKing.png");
  BPawn = loadImage("BPawn.png");
  
  WRook = loadImage("WRook.png");
  WKnight = loadImage("WKnight.png");
  WBishop = loadImage("WBishop.png");
  WQueen = loadImage("WQueen.png");
  WKing = loadImage("WKing.png");
  WPawn = loadImage("WPawn.png");
  
  initPos(); // Run the initPos function which initilises the starting position of all the chess pieces in the 'pos' string directory
  chessBoard(); // Run the chessBoard function which draws the actual chess board onto the screen
}

// This function is constantly updating so only put code in here which you want constantly updated
void draw(){
  // Put the mouseGridPos function here because the position of the mouse is always chacning so we need the 'gridPos' int constantly updated
  mouseGridPos(mouseX, mouseY); // We pass the x and y coordinates of the mouse into the function
}

// This function is run when a mouse press is detected so onlyh put code in here which you want to run when the mouse is pressed
void mousePressed(){
  // In this case we are checking if the position where the mouse was pressed down(clicked) is on our chess board grid
  if (currentPiece == "None"){
    if (pos.hasKey(str(gridPos[0]))){      
      if ((pos.get(str(gridPos[0])).charAt(0) == "W".charAt(0) && whiteTurn == true) || (pos.get(str(gridPos[0])).charAt(0) == "B".charAt(0) && whiteTurn == false)) {
        // If the mouse was over one of the sqare grid the following code would execute
        println("Current piece: " + pos.get(str(gridPos[0])));
        
        currentPiece = pos.get(str(gridPos[0]));
        currentPiecePos[0] = gridPos[0];
        currentPiecePos[1] = gridPos[1];
        currentPiecePos[2] = gridPos[2];
      }
    }
  } else {
    if (canMove(currentPiece)){
      pos.remove(str(currentPiecePos[0]));
      pos.set(str(gridPos[0]), currentPiece);
      
      if ((currentPiecePos[1] % 2) == 0 && (currentPiecePos[2] % 2) != 0){ // If the column is divisable by 2 and the row is not divisible 2 then execute this code
        fill(238, 210, 170);
      } else if ((currentPiecePos[1] % 2) != 0 && (currentPiecePos[2] % 2) == 0){ // If the column is not divisible by 2 and the row is divisible by 2 then execute this code  
        fill(238, 210, 170);
      } else { // Otherwise for every other posiblity execute the following code
        fill(61, 41, 32);
      }
      
      rect(boardTLP + (currentPiecePos[1] * squareSize), boardTLP + (currentPiecePos[2] * squareSize), squareSize, squareSize);
      drawPiece(currentPiece, gridPos[1], gridPos[2]);      
      
      if (whiteTurn){
        whiteTurn = false;
      } else {
        whiteTurn = true;
      }
      }
    
    currentPiece = "None";   
  }
}

boolean attack(){
  if(pos.hasKey(str(gridPos[0]))){
    if (pos.get(str(gridPos[0])).charAt(0)=='W' && pos.get(str(currentPiecePos[0])).charAt(0)=='B'){
      return true;
    } else if(pos.get(str(gridPos[0])).charAt(0)=='B' && pos.get(str(currentPiecePos[0])).charAt(0)=='W'){
      return true;
    }
  } else {
    return true;
  }
  return false;
}

boolean inTheWay(String name, String dir){
  if ((name == "BLRook" || name == "BRRook" || name == "WLRook" || name == "WRRook" || name == "BQueen" || name == "WQueen" || name == "BKing" || name == "WKing") && dir == "UpDown"){
    if (currentPiecePos[0] - gridPos[0] > 0){
      for (int i = currentPiecePos[0]; i >= gridPos[0]; i-=8){
        if(i == gridPos[0]){
          return attack();
        } else {
          if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
            return false;
          }
        }
      }
    } else {
      for (int i = currentPiecePos[0]; i <= gridPos[0]; i+=8){
        if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
          return false;
        }
      }
    }
  } else if ((name == "BLRook" || name == "BRRook" || name == "WLRook" || name == "WRRook" || name == "BQueen" || name == "WQueen" || name == "BKing" || name == "WKing") && dir == "Side"){
     if (currentPiecePos[0] - gridPos[0] > 0){
      for (int i = currentPiecePos[0]; i >= gridPos[0]; i--){
        if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
          return false;
        }
      }
    } else {
      for (int i = currentPiecePos[0]; i <= gridPos[0]; i++){
        if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
          return false;
        }
      }
    }
  } else if ((name == "BLBishop" || name == "BRBishop" || name == "WLBishop" || name == "WRBishop" || name == "BQueen" || name == "WQueen" || name == "BKing" || name == "WKing") && dir == "DiagLTR"){
     if (currentPiecePos[0] - gridPos[0] > 0){
      for (int i = currentPiecePos[0]; i >= gridPos[0]; i-=9){
        if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
          return false;
        }
      }
    } else {
      for (int i = currentPiecePos[0]; i <= gridPos[0]; i+=9){
        if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
          return false;
        }
      }
    }
  } else if ((name == "BLBishop" || name == "BRBishop" || name == "WLBishop" || name == "WRBishop" || name == "BQueen" || name == "WQueen" || name == "BKing" || name == "WKing") && dir == "DiagRTL"){
     if (currentPiecePos[0] - gridPos[0] > 0){
      for (int i = currentPiecePos[0]; i >= gridPos[0]; i-=7){
        if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
          return false;
        }
      }
    } else {
      for (int i = currentPiecePos[0]; i <= gridPos[0]; i+=7){
        if(pos.hasKey(str(i)) && i != currentPiecePos[0]){
          return false;
        }
      }
    }
    //else if((name=="WOnePawn" || name == "WTwoPawn" || name =="WThreePawn" || name=="WFourPawn"||name=="WFivePawn"||name=="WSixPawn"||name=="WSevenPawn"
  }
  
  return true;
}

boolean canMove(String name){
  if (name == "BLRook" || name == "BRRook" || name == "WLRook" || name == "WRRook"){
    if (gridPos[1] == currentPiecePos[1]){
      return inTheWay(name, "UpDown");
    } else if (gridPos[2] == currentPiecePos[2]){
      return inTheWay(name, "Side");
    }
  } else if (name == "BLKnight" || name == "BRKnight" || name == "WLKnight" || name  == "WRKnight"){
    if ((currentPiecePos[2] != gridPos[2])  && (abs(gridPos[0] - currentPiecePos[0])/6.0 == 1) || abs(gridPos[0] - currentPiecePos[0])/10.0 == 1 || abs(gridPos[0] - currentPiecePos[0])/15.0 == 1 || abs(gridPos[0] - currentPiecePos[0])/17.0 == 1){
      println(abs(gridPos[0] - currentPiecePos[0])/15.0);
      return true;
    }
  } else if (name == "BLBishop" || name == "BRBishop" || (name == "WLBishop" || name == "WRBishop")){
    if ((gridPos[0] - currentPiecePos[0]) % 7 == 0){
      return inTheWay(name, "DiagRTL");
    } else if ((gridPos[0] - currentPiecePos[0]) % 9 == 0){
      return inTheWay(name, "DiagLTR");
    }
  } else if (name == "BQueen" || name == "WQueen"){
    if (gridPos[1] == currentPiecePos[1]){
      return inTheWay(name, "UpDown");
    } else if (gridPos[2] == currentPiecePos[2]){
      return inTheWay(name, "Side");
    } else if ((gridPos[0] - currentPiecePos[0]) % 7 == 0){
      return inTheWay(name, "DiagRTL");
    } else if ((gridPos[0] - currentPiecePos[0]) % 9 == 0){
      return inTheWay(name, "DiagLTR");
    }
  } else if (name == "BKing" || name == "WKing"){
    if (gridPos[1] == currentPiecePos[1] && (gridPos[0] - currentPiecePos[0] == -8 || gridPos[0] - currentPiecePos[0] == 8)){
      return inTheWay(name, "UpDown");
    } else if (gridPos[2] == currentPiecePos[2] && (gridPos[0] - currentPiecePos[0] == -1 || gridPos[0] - currentPiecePos[0] == 1)){
      return inTheWay(name, "Side");
    } else if ((gridPos[0] - currentPiecePos[0]) % 7 == 0 && (gridPos[0] - currentPiecePos[0] > - 10 && gridPos[0] - currentPiecePos[0] < 10)){
      return inTheWay(name, "DiagRTL");
    } else if ((gridPos[0] - currentPiecePos[0]) % 9 == 0 && (gridPos[0] - currentPiecePos[0] > - 10 && gridPos[0] - currentPiecePos[0] < 10)){
      return inTheWay(name, "DiagLTR");
    }
  } else if (name == "BOnePawn" || name == "BTwoPawn" || name == "BThreePawn" || name == "BFourPawn" || name == "BFivePawn" || name == "BSixPawn" || name == "BSevenPawn" || name == "BEightPawn"){
    if (gridPos[0] - currentPiecePos[0] == 8 || (currentPiecePos[2] == 1 && gridPos[0] - currentPiecePos[0] == 16)){
      return true;
    }
  } else if (name == "WOnePawn" || name == "WTwoPawn" || name == "WThreePawn" || name == "WFourPawn" || name == "WFivePawn" || name == "WSixPawn" || name == "WSevenPawn" || name == "WEightPawn"){
    if (gridPos[0] - currentPiecePos[0] == -8 || (currentPiecePos[2] == 6 && gridPos[0] - currentPiecePos[0] == -16)){
      return true;
    }
  }
  
  return false;
}

void drawPiece(String name, int x, int y){
  if (name == "BLRook" || name == "BRRook"){
    image(BRook, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BRook.width/(width/200), BRook.height/(height/200));
  } else if (name == "BLKnight" || name == "BRKnight"){
    image(BKnight, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BKnight.width/(width/200), BKnight.height/(height/200));
  } else if (name == "BLBishop" || name == "BRBishop"){
    image(BBishop, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BBishop.width/(width/200), BBishop.height/(height/200)); 
  } else if (name == "BQueen"){
    image(BQueen, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BQueen.width/(width/200), BQueen.height/(height/200)); 
  } else if (name == "BKing"){
    image(BKing, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BKing.width/(width/200), BKing.height/(height/200)); 
  } else if (name == "BOnePawn" || name == "BTwoPawn" || name == "BThreePawn" || name == "BFourPawn" || name == "BFivePawn" || name == "BSixPawn" || name == "BSevenPawn" || name == "BEightPawn"){
    image(BPawn, boardTLP + (x * squareSize), boardTLP + (y * squareSize), BPawn.width/(width/200), BPawn.height/(height/200)); 
  } else if (name == "WLRook" || name == "WRRook"){
    image(WRook, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WRook.width/(width/200), WRook.height/(height/200)); 
  } else if (name == "WLKnight" || name  == "WRKnight"){
    image(WKnight, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WKnight.width/(width/200), WKnight.height/(height/200)); 
  } else if (name == "WLBishop" || name == "WRBishop"){
    image(WBishop, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WBishop.width/(width/200), WBishop.height/(height/200)); 
  } else if (name == "WQueen"){
    image(WQueen, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WQueen.width/(width/200), WQueen.height/(height/200));  
  } else if (name == "WKing"){
    image(WKing, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WKing.width/(width/200), WKing.height/(height/200));  
  } else if (name == "WOnePawn" || name == "WTwoPawn" || name == "WThreePawn" || name == "WFourPawn" || name == "WFivePawn" || name == "WSixPawn" || name == "WSevenPawn" || name == "WEightPawn"){
    image(WPawn, boardTLP + (x * squareSize), boardTLP + (y * squareSize), WPawn.width/(width/200), WPawn.height/(height/200)); 
  }
}

// This function draws the actual chess board onto the screen
void chessBoard(){
  // At the start we initilise all the variables we will need
  int borderWidth = width/16; // This is the scalable width of the outer boarder
  int innerBorderWidth = width/80; // This is the scalable with of the innner smaller border
  boardTLP = borderWidth + innerBorderWidth; // This is the top left point of the actual chess board not counting the above borders
  float boardSize = width - (2 * (borderWidth + innerBorderWidth)); // The actual size of the chess board not counting the borders
  squareSize = (boardSize/8) + 0.75; // Since there are always 64 squares 8x8 we can just divide by 8 to find the size of one such square
  
  // Set the border colour to a dark wood brown
  stroke(61, 41, 32);
  strokeWeight(borderWidth); // And the width to a fat one
  rect((borderWidth / 2), (borderWidth / 2), width - borderWidth, height - borderWidth); // Then draw the actual rectangle so the borders will be drawn
  
  // Change the broder colour to a light creme wood colour
  stroke(206, 185, 152);
  strokeWeight(innerBorderWidth); // Change the border width to a smaller one
  // And draw the square so the borders will be drawn
  rect((borderWidth + (innerBorderWidth / 2)),
      (borderWidth + (innerBorderWidth / 2)),
      width - ( 2 * borderWidth + (innerBorderWidth/2)),
      height - (2 * borderWidth + (innerBorderWidth/2)));
  
  // Now we need to draw the individual squares of the grid so set the border to 0
  strokeWeight(0);
  int count = 0;
  
  // Now the logic to figure out what colour of square to draw
  for(int i = 0; i < 8; i++){ // This is a loop that will repeat 8 times this is for each row
    for(int j = 0; j < 8; j++){ // This loop will also repeat 8 times this is for each column
      if ((j % 2) == 0 && (i % 2) != 0){ // If the column is divisable by 2 and the row is not divisible 2 then execute this code
        fill(238, 210, 170);
      } else if ((j % 2) != 0 && (i % 2) == 0){ // If the column is not divisible by 2 and the row is divisible by 2 then execute this code  
        fill(238, 210, 170);
      } else { // Otherwise for every other posiblity execute the following code
        fill(61, 41, 32);
      }
      
      // Now actually draw each square with a total of 64 once both loop have finished
      rect(boardTLP + (j * squareSize), boardTLP + (i * squareSize), squareSize, squareSize);
      if (pos.hasKey(str(count))){
        drawPiece(pos.get(str(count)), j, i);
      }
      
      count++;
    }
  }
}

// This function is to calculate what square the mouse is hovering over
void mouseGridPos(int x, int y){
  // Take 60 away from both x and y coordinates so 0,0 would be the top left corner of the board not the actual canavas
  x = x - 60;
  y = y - 60;
  
  //Check if the mouse is actually on the chess board and not the borders
  if (x > 0 && y > 0 && x < (width - 2 * boardTLP) && y < (height - 2 * boardTLP)){
    // Divide both x and y coordiantes by the square size to give the actual square number of the grid and set it to the variable gridPos
    gridPos[0] = int((floor(y / squareSize) * 8) + floor(x / squareSize));
    gridPos[1] = int(floor(x / squareSize));
    gridPos[2] = int(floor(y / squareSize));
    //println("X-Cord: " + x + " Y-Cord: " + y + " Square " + gridPos);
  }
}

void initPos(){
 // Top left square is 0 and the bottom right is 63 increasing left to right and down
 // Set the position of the black chess pieces on the 8x8 grid
 pos.set("0", "BLRook"); // Square 0 is black left rook
 pos.set("1", "BLKnight"); // Square 1 is black left knight
 pos.set("2", "BLBishop"); // Square 2 is black left bishop
 pos.set("3", "BQueen"); // Square 3 is black queen
 pos.set("4", "BKing"); // Square 4 is black king
 pos.set("5", "BRBishop"); // Square 5 is black right bishop
 pos.set("6", "BRKnight"); // Square 6 is black right knight
 pos.set("7", "BRRook"); // Square 7 is black right rook
 pos.set("8", "BOnePawn"); // Square 8 is black first pawn from left 
 pos.set("9", "BTwoPawn"); // Square 9 is black second pawn from left
 pos.set("10", "BThreePawn"); // Square 10 is the black third pawn from left
 pos.set("11", "BFourPawn"); // Square 11 is the balck fourth pawn from left
 pos.set("12", "BFivePawn"); // Square 12 is the black fifth pawn from left
 pos.set("13", "BSixPawn"); // Square 13 is the black sixth pawn from left
 pos.set("14", "BSevenPawn"); // Square 14 is the black seventh pawn from left
 pos.set("15", "BEightPawn"); // Square 15 is the black eighth pawn from left
 
 // Set the position of the white chess pieces on the 8x8 grid
 pos.set("48", "WOnePawn"); // Square 48 is the white first pawn from left
 pos.set("49", "WTwoPawn"); // Square 49 is the white second pawn from left
 pos.set("50", "WThreePawn"); // Square 50 is the white third pawn from left
 pos.set("51", "WFourPawn"); // Square 51 is the white fourth pawn from left
 pos.set("52", "WFivePawn"); // Square 52 is the white fifth pawn from left
 pos.set("53", "WSixPawn"); // Square 53 is the white sixth pawn from left
 pos.set("54", "WSevenPawn"); // Square 54 is the white seventh pawn from left
 pos.set("55", "WEightPawn"); // Square 55 is the white eight pawn from left
 pos.set("56", "WLRook"); // Square 56 is the white left rook
 pos.set("57", "WLKnight"); // Square 57 is the white left knight
 pos.set("58", "WLBishop"); // Square 58 is the white left bishop
 pos.set("59", "WQueen"); // Square 59 is the white queen
 pos.set("60", "WKing"); // Square 60 is the white king
 pos.set("61", "WRBishop"); // Square 61 is the right white bishop
 pos.set("62", "WRKnight"); // Square 62 is the white right knight
 pos.set("63", "WRRook"); // Square 63 is the white right rook
}