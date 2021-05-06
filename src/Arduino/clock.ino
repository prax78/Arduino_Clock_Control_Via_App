#include <Wire.h>
   
#include "DS1307.h"
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <SoftwareSerial.h>
#include <Wire.h>

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels
DS1307 clock;//define a object of DS1307 class
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

SoftwareSerial BTSerial(2,3);//RX,TX
String time="";
String y="1900";
String m="";
String d="";
String h="";
String mt="";
String s="";
int i=0;
int j=0;
int hr=0;
int mn=0;


void setup() {
    Serial.begin(9600);
    BTSerial.begin(9600);
   
    clock.begin();
      if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) { // Address 0x3D for 128x64
    Serial.println(F("SSD1306 allocation failed"));
    for(;;);
    
  }
  delay(2000);
  display.clearDisplay();

  while(i<1){

        printTime();
  }
    
  
}


void loop() {
    


    clock.getTime();

    time=(String)clock.hour + ":" + (String)clock.minute;
    displayTime(time,4,5,20);

   
    getAlarm();

     if(clock.hour==hr && clock.minute==mn)
   {
 

tone(9,750,100);

   }

 

   // Serial.println(time);
    delay(1000);
}
/*Function: Display time on the serial monitor*/

void displayTime(String msg,int size, int x, int y)
{

  
  // Display static text
  display.setTextSize(size);
  display.setTextColor(WHITE);
  display.setCursor(x,y);
  display.clearDisplay();
   
  display.print(msg);
  display.display(); 

}
void printTime() {
    

if(BTSerial.available()>0 && i<1)
{
  i++;
   y= BTSerial.readStringUntil(':'); 
   m=BTSerial.readStringUntil(':'); 
   d=BTSerial.readStringUntil(':'); 
   h=BTSerial.readStringUntil(':'); 
   mt=BTSerial.readStringUntil(':'); 
   s=BTSerial.readStringUntil(':'); 
timeFromPC(y,m,d,h,mt,s);

}
 
}

void timeFromPC(String year, String month, String day, String hour, String minute, String second )
{
  
  clock.fillByYMD(year.toInt(),month.toInt(), day.toInt());
    clock.fillByHMS(hour.toInt(), minute.toInt(), second.toInt());

    clock.setTime();//write time to the RTC chip

}

void getAlarm()
{
   
  if(BTSerial.available()>0)
{


  
  
switch((char)BTSerial.read())
 {

  
   case 's':
    displayTime("Al " + (String)hr +":" + (String)mn,3,0,0);

  break;

   case 'c':
   hr=0;
   mn=0;
  
    displayTime("Clr Alm",3,0,0);

    break;
    
  case '+':
   if(hr<23)
   {
   hr++;
   }
  
   displayTime("Hr="+String(hr),3,0,0);

   break;   
   
  case '-':
  if(hr>0)
  {
  hr--;
  }
  
    displayTime("Hr="+String(hr),3,0,0);

  break; 

  case 'p':
   if(mn<59)
   {
   mn++;
   }
 
     displayTime("Mt="+String(mn),3,0,0);

   break;
   
  case 'm':
  if(mn>0)
  {
  mn--;
  }

    displayTime("Mt="+String(mn),3,0,0);
   
  break;

  
  } 
  }

  }
