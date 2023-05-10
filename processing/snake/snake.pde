/**
 * SNAKE GAME
 * Rules:
 *     Eat the food
 *     Do not bite your own tail
 *     Do not hit a wall
 * Specifications:
 *     The snake grows when eat food
 *     The speed increases when the snake grows
 *     Food is displayed randomly
 *     Food and parts of the snake body are squares
 */

// global variables
ArrayList<PVector> snake = new ArrayList<PVector>(); // snake body (not included the head)
PVector pos; // snake position (position of the head)

PVector food; // food position

PVector dir = new PVector(0, 0); // snake direction (up, down, left right)

int size = 40; // snake and food square size
int w, h; // how many snakes can be allocated

int spd = 20; // reverse speed (smaller spd will make the snake move faster)
int len = 4; // snake body

String actual_mode = "no_border"; // define the mode (either "no_border" or "border")

void setup() {
  size(1080, 720);
  w = width/size;
  h = height/size;
  
  pos = new PVector(w/2, h/2); // Initial snake position
  newFood(); // create 2D vector
  
  noStroke();
  fill(0);
}

void draw() {
  background(200);
  drawSnake();
  drawFood();
  
  // update snake if frameCount is a multiple of spd which is 20 at the begining
  if(frameCount % spd == 0) {
    updateSnake();   
  }
}

// draw the food item (square) which size is tha variable size
void drawFood() {
  fill(255, 0, 0); // red
  rect(food.x*size, food.y*size, size, size); 
}

// declare a new pVector (random) for food
void newFood() {
  food = new PVector(floor(random(w)), floor(random(h)));
}

// draw snake, consider the snake array size (each square of size size) + square of the current pos
void drawSnake() {
  fill(0, 255, 0); // green
  
  // Draw each segment of the snake body
  for(int i=0; i<snake.size(); i++) {
    rect(snake.get(i).x*size, snake.get(i).y*size, size, size); 
  }
  
  // Draw the snake head
  rect(pos.x*size, pos.y*size, size, size); 
}

void updateSnake() {
  // Add current position(head) to snake ArrayList
  snake.add(pos.copy());
  
  // Check the size of snake. Remove some items from snake ArrayList if needed
  while (snake.size() > len) {
    snake.remove(0);
  }
  
  // Calculate new position of snake (head). You must use the direction vector for this calculation
  pos.add(dir);
  
  // If snake (head) hits food, add +1 to the snake size and create a new food
  if (pos.equals(food)) {
    len++;
    spd -= 1;
    newFood();
  }
  
  // If snake (head) eat itself, gameover, reset()
  for (int i = 0; i < snake.size() - 1; i++) {
    if (pos.equals(snake.get(i))) {
      reset();
    }
  }
  
  // If mode 'no_border', snake is out of screen, wraps around
  // If mode 'border', when snake hit a border, gameover, reset()
  if (actual_mode == "no_border") {
    if (pos.x > w - 1) pos.x = 0;
    if (pos.x < 0) pos.x = w - 1;
    if (pos.y > h - 1) pos.y = 0;
    if (pos.y < 0) pos.y = h - 1;
  } else if (actual_mode == "border") {
    if (pos.x > w - 1 || pos.x < 0 || pos.y > h - 1 || pos.y < 0) {
      reset();
    }
  }
}

void reset() {
  spd = 20;
  len = 4;
  pos = new PVector(w/2, h/2);
  dir = new PVector(0, 0);
  newFood();
  snake = new ArrayList<PVector>();
}

void keyPressed() {
  if (keyCode == UP) {
    if (dir.y != 1) dir = new PVector(0, -1);
  } else if (keyCode == DOWN) {
    if (dir.y != -1) dir = new PVector(0, 1);
  } else if (keyCode == LEFT) {
    if (dir.x != 1) dir = new PVector(-1, 0);
  } else if (keyCode == RIGHT) {
    if (dir.x != -1) dir = new PVector(1, 0);
  }
}

// EXTRA FOR STUDENTS WHO FINISH WITH THE REQUIRED TASKS
// if '+' is pressed, increase the size of the squares (and recalculate w and h)
// same thing for '-'
// when 'm' is pressed, change the mode -> ONLY IF YOU IMPLEMENT BOTH MODES
// add colors: 
//     1. make the food colorful and when the snake eats the food, it adopts that color
//     2. make the backgroud looks like a grid adding colors
