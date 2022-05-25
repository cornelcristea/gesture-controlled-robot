/* 
-------------------------------------------------------

Universitatea Tehnica "Gheorghe Asachi" Iasi
Facultatea de Mecanica (Mecatronica)

PROIECT:
ROBOT MOBIL CONTROLAT PRIN GESTURI

Descriere: Program pentru Controler (Tx)
Student: Petru-Cornel CRISTEA

-------------------------------------------------------
*/


// Inlcuderea bibliotecilor necesare pentru program
#include <VirtualWire.h>                      // Biblioteca pentru modulul radio 433 MHz
#include <MPU6050_tockn.h>                    // Biblioteca pentru modulul MPU6050
#include <Wire.h>                             // Biblioteca pentru comunicatie


// Declararea constantelor si a variabilelor necesare pentru functionarea programului
MPU6050 mpu6050(Wire);                        
const char *controler;                      
int pin_trimitere_date = 12;  


// Partea programului ce va rula o singura data dupa pornirea circuitului
void setup() {

// Stabilirea comunicatiei intre receptor si transmitator
    Serial.begin(9600);                       // Initializarea comunicatiei seriale
    Wire.begin();
    mpu6050.begin();                          // Initializarea modulului MPU6050
    mpu6050.calcGyroOffsets(true);            // Citirea coordonatelor axelor modulului grioscop
    vw_set_ptt_inverted(true);  
    vw_set_tx_pin(pin_trimitere_date);        // Setarea pinului DATA al transmitatorului radio
    vw_setup(4000);                           // Viteza de transfer a datelor in Kbps
}


// Partea programului ce va rula incontinuu dupa pornirea circuitului
void loop() {

// Actualizarea pozitiei giroscopului in functie de orientarea acestuia
 mpu6050.update();

  if (mpu6050.getAccAngleX()<-30){ 
    controler="X1"  ;
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); 
    //Serial.print("X: ");Serial.print(mpu6050.getAngleX());Serial.print("   ");
    //Serial.print("Y: ");Serial.print(mpu6050.getAngleY());Serial.print("   ");
    Serial.println("Inapoi");
  } 
  
  else if (mpu6050.getAccAngleX()>30) { 
    controler = "X2";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); 
    //Serial.print("X: "); Serial.print(mpu6050.getAngleX()); Serial.print("   ");
    //Serial.print("Y: "); Serial.print(mpu6050.getAngleY()); Serial.print("   ");
    Serial.println("Inainte");
  }
  
  else if (mpu6050.getAccAngleY()<-40 ) { 
    controler = "Y1";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx();
    //Serial.print("X: ");Serial.print(mpu6050.getAngleX());Serial.print("   ");
    //Serial.print("Y: ");Serial.print(mpu6050.getAngleY());Serial.print("   ");
    Serial.println("Stanga");
  }
  
    else if (mpu6050.getAccAngleY()>40) { 
    controler = "Y2";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); // Wait until the whole message is gone
    //Serial.print("X: ");Serial.print(mpu6050.getAngleX());Serial.print("   ");
    //Serial.print("Y: ");Serial.print(mpu6050.getAngleY());Serial.print("   ");
    Serial.println("Dreapta");
  }
  
    else if (mpu6050.getAccAngleX()<10 && mpu6050.getAccAngleX()>-10 && mpu6050.getAccAngleY()<10 && mpu6050.getAccAngleY()>-10) { 
    controler = "A1";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); 
   // Serial.print("X: ");Serial.print(mpu6050.getAngleX());Serial.print("   ");
    //Serial.print("Y: ");Serial.print(mpu6050.getAngleY());Serial.print("   ");
    Serial.println("Stop");
  }
}
