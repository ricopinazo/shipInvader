#include "notes.h"
//#include "PWM.h"

#define THRESHOLD       30

#define MISSILE         A0

#define FORWARD_P1      7
//#define BACKWARD_P1      8 

#define FORWARD_P2      12
#define BACKWARD_P2     13

#define MEL1            9
#define GND             11

#define IDLES           0
#define GOLPE           1
#define DESCARGA        2

char state = GOLPE;


struct player_data
{
  uint8_t player;         // 1 or 2  
  int8_t dir;             // -1 means backward, 1 foreward and 0 none.
  float force;            // 0 to 1
};

long double test1_tim, piezo_del = 0;
int pauseBetweenNotes1 = 0, pauseBetweenNotes2 = 0;

bool mel2 = false;

uint16_t force = 0;


void setup() 
{
  Serial.begin(9600);
  
  pinMode(MISSILE, INPUT);
  pinMode(FORWARD_P1, INPUT);
 // pinMode(BACKWARD_P1, INPUT);
  pinMode(FORWARD_P2, INPUT);
  pinMode(BACKWARD_P2, INPUT);
  
  pinMode(MEL1, OUTPUT);
  pinMode(GND, OUTPUT);
  digitalWrite(GND, LOW);
  test1_tim = 0;
  delay(10);
}




void loop() 
{

  switch(state)
  {
    case IDLES:
      if((force = analogRead(MISSILE)) > THRESHOLD)
        state = GOLPE;      
      break;
      
    case GOLPE:
        Serial.println(force);
        state = DESCARGA;
        piezo_del = millis();
      break;
      
    case DESCARGA:
      if((force = analogRead(MISSILE)) < 10 && (millis() - piezo_del > 200))
        state = IDLES;
      break;  
  }

  if(millis() - test1_tim >= pauseBetweenNotes1)
  {
    static unsigned note1 = 0;
    noTone(MEL1);
    tone(MEL1, test1[note1], test1_len[note1]);
    pauseBetweenNotes1 = test1_len[note1] * 1.30;
    
    if(note1 < 19)
      note1++;
    else{
      note1 = 0;
      mel2 = true;
      
    }
    test1_tim = millis();
  }
}
