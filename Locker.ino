//Including Libraries
#include <WiFi.h>
#include <IOXhop_FirebaseESP32.h>
#include <ESP32Servo.h>

//Initializing Firebase
#define FIREBASE_HOST "esp32led.firebaseio.com"   
#define FIREBASE_AUTH "4QHdeFZquTh4fdXZkum2EPt2A50gXXXXXXXXX"   
#define WIFI_SSID "XXXXXX"               
#define WIFI_PASSWORD "XXXXXXXXXX"
Servo servo;
int servoPin = 13;
int pos = 0;


//This is the setup code which runs on startup
void setup() {
  Serial.begin(9600);
  delay(1000);
  pinMode(servoPin, OUTPUT);                
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);                                  
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  while (WiFi.status() != WL_CONNECTED) {
  Serial.print(".");
  delay(500);
  }
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH); 
  Firebase.setString("LED_STATUS", "OFF");
}

//This is the code which runs continuously throughout the lifecycle of the system.
void loop() {
  fireStatus = Firebase.getString("LED_STATUS");
  if (fireStatus == "ON") { 
    myservo.write(90);    
  }
  if (fireStatus == "OFF"){
    myservo.write(0);
  }
}
