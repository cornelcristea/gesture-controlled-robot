/*
************************************************************************

Universitatea Tehnica "Gheorghe Asachi" Iasi
Facultatea de Mecanica

ROBOT MOBIL CONTROLAT PRIN GESTURI
Program pentru Controler (Tx)

Student       : Cornel Cristea
Specializare  : Mecatronica
Data          : 12/06/2020 

************************************************************************
*/

// Inlcuderea bibliotecilor necesare pentru program
#include <VirtualWire.h>            // modul radio 433 MHz
#include <MPU6050_tockn.h>          // giroscop MPU6050
#include <Wire.h>                   // modul comunicatie

// Definirea variabilelor
MPU6050 mpu6050(Wire);                        
const char *controler;                      
int pin_trimitere_date = 12;  

/*
************************************************************************
Partea programului ce va rula o singura data dupa pornirea circuitului
************************************************************************
*/
void setup() {
  Serial.begin(9600);                 // initializare comunicatie seriala
  Wire.begin();
  mpu6050.begin();                    // initializare giroscop MPU6050
  mpu6050.calcGyroOffsets(true);      // citire coordonate de la grioscop
  vw_set_ptt_inverted(true);  
  vw_set_tx_pin(pin_trimitere_date);  // pin DATA transmitator radio
  vw_setup(4000);                     // viteza de transfer [Kbps]
}

/*
************************************************************************
Partea programului ce va rula incontinuu dupa pornirea circuitului
************************************************************************
*/
void loop() {
  // Actualizarea pozitiei giroscopului in functie de orientarea acestuia
  mpu6050.update(); 
  if (mpu6050.getAccAngleX() < -30) { 
    controler = "X1"  ;
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); // asteapta pana cand mesajul a fost trimis
    //Serial.print("X: "); Serial.print(mpu6050.getAngleX()); Serial.print("   ");
    //Serial.print("Y: "); Serial.print(mpu6050.getAngleY()); Serial.print("   ");
    Serial.println("Inapoi");
  } 
  else if (mpu6050.getAccAngleX() > 30) { 
    controler = "X2";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); 
    //Serial.print("X: "); Serial.print(mpu6050.getAngleX()); Serial.print("   ");
    //Serial.print("Y: "); Serial.print(mpu6050.getAngleY()); Serial.print("   ");
    Serial.println("Inainte");
  }
  else if (mpu6050.getAccAngleY() < -40) { 
    controler = "Y1";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx();
    //Serial.print("X: "); Serial.print(mpu6050.getAngleX()); Serial.print("   ");
    //Serial.print("Y: "); Serial.print(mpu6050.getAngleY()); Serial.print("   ");
    Serial.println("Stanga");
  }
  else if (mpu6050.getAccAngleY() > 40) { 
    controler = "Y2";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); 
    //Serial.print("X: "); Serial.print(mpu6050.getAngleX()); Serial.print("   ");
    //Serial.print("Y: "); Serial.print(mpu6050.getAngleY()); Serial.print("   ");
    Serial.println("Dreapta");
  }
  else if (mpu6050.getAccAngleX() < 10 && mpu6050.getAccAngleX() > -10 && 
            mpu6050.getAccAngleY() < 10 && mpu6050.getAccAngleY() > -10) { 
    controler = "A1";
    vw_send((uint8_t *)controler, strlen(controler));
    vw_wait_tx(); 
    //Serial.print("X: "); Serial.print(mpu6050.getAngleX()); Serial.print("   ");
    //Serial.print("Y: "); Serial.print(mpu6050.getAngleY()); Serial.print("   ");
    Serial.println("Stop");
  }
}
