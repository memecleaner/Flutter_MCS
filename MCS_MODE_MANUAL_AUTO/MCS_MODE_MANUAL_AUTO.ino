#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>

#define WIFI_SSID "kokocute"
#define WIFI_PASSWORD "qwertyuiop"
#define FIREBASE_HOST "proyek-mcs-c23ac-default-rtdb.asia-southeast1.firebasedatabase.app"
#define FIREBASE_AUTH "l60Nqsin6WlqYaHLfLgr0V9SOwhpf9IbfGFxNbbD"

#define LDR_PIN A0
#define RELAY_PIN D1 

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

bool autoMode = false;
bool dataLed = false;
int ldrThreshold = 40; 

void setup() {
  Serial.begin(115200);
  pinMode(RELAY_PIN, OUTPUT);
  
  // Changed to LOW so it starts OFF for your specific relay wiring
  digitalWrite(RELAY_PIN, LOW); 

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

// ... (Keep configuration and setup as they are)

void loop() {
  // 1. Sync states
  if (Firebase.getBool(fbdo, "/AutoMode")) { autoMode = fbdo.boolData(); }
  if (Firebase.getBool(fbdo, "/dataLed")) { dataLed = fbdo.boolData(); }
  if (Firebase.getInt(fbdo, "/LdrThreshold")) { ldrThreshold = fbdo.intData(); }

 // ... (Setup and Sync code remain same)

  // 2. Read Sensor
  int ldrValue = analogRead(LDR_PIN);
  int lightPercent = map(ldrValue, 0, 1024, 0, 100); 

  // ... (Sync code)

// 3. Main Control Logic
if (autoMode) {
  // --- AUTO MODE ---
  // If Dark (below threshold) -> Turn ON
  if (lightPercent < ldrThreshold) {
    digitalWrite(RELAY_PIN, LOW); 
    if (dataLed != true) Firebase.setBool(fbdo, "/dataLed", true); // Sync FB icon
  } else {
    digitalWrite(RELAY_PIN, HIGH);  
    if (dataLed != false) Firebase.setBool(fbdo, "/dataLed", false); // Sync FB icon
  }
} else {
  // --- MANUAL MODE ---
  // Use the SAME High/Low as Auto mode so it's consistent
  if (dataLed == true) {
    digitalWrite(RELAY_PIN, HIGH); // Manual ON
  } else {
    digitalWrite(RELAY_PIN, LOW);  // Manual OFF
  }
}

  // 4. Update Firebase
  Firebase.setInt(fbdo, "/CurrentLightLevel", lightPercent);
  delay(500); 
}