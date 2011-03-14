//  Showoff :)  
//  randomSeed(analogRead(5));
//  registerWrite(rows[random(8)], colsR[random(8)]);

//  render dot based on input
//  registerWrite(rows[p1_pos], colsR[p2_pos]); 

int colsR[9] = {1,2,4,8,16,32,64,128, 0};
int rows[9] = {254,253,251,247,239,223,191,127, 255};

const int latchPin = 8;
const int clockPin = 12;
const int dataPinRow = 11;
const int dataPinCol = 10;
const int latchC = 2;
const int clockC = 3;

int player_one = A0;
int player_two = A1;
int p1_pos, p2_pos;
 
int ball_x=3, ball_y=3;
int ball_dir_x=1, ball_dir_y=-1;
int count = 0;

void setup() {
  pinMode(latchPin, OUTPUT);
  pinMode(dataPinRow, OUTPUT);  
  pinMode(dataPinCol, OUTPUT);  
  pinMode(clockPin, OUTPUT);
  pinMode(latchC, OUTPUT);
  pinMode(clockC, OUTPUT);  
  Serial.begin(9600);
}

void registerWrite(int row,  int col) {
  digitalWrite(latchPin, LOW);
  shiftOut(dataPinRow, clockPin, MSBFIRST, row);
  digitalWrite(latchPin, HIGH);

  digitalWrite(latchC, LOW);
  shiftOut(dataPinCol, clockC, MSBFIRST, col);
  digitalWrite(latchC, HIGH);
}

void getPlayerPositions()
{
  p1_pos = analogRead(player_one);
  p1_pos = p1_pos/128;
  p2_pos = analogRead(player_two);
  p2_pos = p2_pos/128;  
}

void renderBall()
{
  registerWrite(rows[ball_y], colsR[ball_x]);
  delay(3);
  registerWrite(rows[8], colsR[8]);
  delay(3);  
}  

void moveBall()
{
  ball_x += ball_dir_x;
  ball_y += ball_dir_y;
}

void checkLocationAndBounce()
{
  if(ball_y >= 7)
    ball_dir_y= -1;
  else if(ball_y <= 0)
    ball_dir_y = 1;

  // on x only bounce if player
  // paddle is on same spot

  if(ball_x >= 7)
    ball_dir_x= -1;
  else if(ball_x <= 0)
    ball_dir_x = 1;   
}

void renderPlayerPaddles()
{
  getPlayerPositions();
  registerWrite(rows[p2_pos], colsR[0]);
  delay(3);
  registerWrite(rows[8], colsR[8]);
  delay(3);
  registerWrite(rows[p1_pos], colsR[7]);  
  delay(3);
  registerWrite(rows[8], colsR[8]);
  delay(3);
}

void loop() {  
  renderBall();
  renderPlayerPaddles();
  if(count >5) {  
    moveBall();
    checkLocationAndBounce();
    count = 0;
  }
  count++;
}
