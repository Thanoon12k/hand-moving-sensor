
#include <WiFi.h>
#define LED 2

const char* ssid = "HS";
const char* password = "&&&&2222";

WiFiServer server(80);

void setup() {
  Serial.begin(115200);

  // Connect to Wi-Fi network
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("");Serial.print("ESP32 IP address: ");Serial.println(WiFi.localIP());

  // Start server
  server.begin();
  Serial.println("Server started");
}

void loop() {
    digitalWrite(LED,LOW);
digitalWrite(LED,HIGH);

  // Wait for a client to connect
  WiFiClient client = server.available();
  if (client) {
    Serial.println("Client connected");

    // Wait for incoming data
     
    // Choose a random animal word to send
    String animalWords[10] = {"cat", "dog", "elephant", "giraffe", "lion", "monkey", "panda", "tiger", "whale", "zebra"};
    

    // Wait for incoming data
    while (client.connected()) {
      int randomIndex = random(10);
    String message = animalWords[randomIndex];
      Serial.println("send : " + message);
      client.println(message);
      delay(10000);
      client.stop();
      Serial.println("Client disconnected");
      }
    }

    
  
}
