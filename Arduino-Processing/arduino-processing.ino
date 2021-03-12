void setup() {
  //initialised the serial port for data upload
  Serial.begin(9600);
}

void loop() {
  //capture data in arduino
  int var1 = int(random(100));

  //put the data onto the serial port
  Serial.println(var1);
  //Serial.println(var1);
  delay(2000);
}
