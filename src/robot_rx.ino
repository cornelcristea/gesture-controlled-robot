/*
************************************************************************

Universitatea Tehnica "Gheorghe Asachi" Iasi
Facultatea de Mecanica (Mecatronica)

ROBOT MOBIL CONTROLAT PRIN GESTURI
Program pentru Robot (Rx)

Student       : Cornel Cristea
Specializare  : Mecatronica
Data          : 12/06/2020

************************************************************************
*/

// Inlcuderea bibliotecilor necesare pentru program
#include <VirtualWire.h>    // modulul radio 433 MHz

// Definirea variabilelor
int IN1 = 5;                // motorul A (+)
int IN2 = 6;                // motorul A (-)
int IN3 = 7;                // motorul B (+)
int IN4 = 8;                // motorul B (-)
int viteza = 150;           // vitezei pentru motoare
int pin_primire_date = 2;   // pin primirea datelor de la Tx

/*
************************************************************************
Partea programului ce va rula o singura data dupa pornirea circuitului
************************************************************************
*/
void setup() {
  // Pinii pentru controlul motoarelor sunt setati ca iesire
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
    
  // Stabilirea comunicatiei intre receptor si transmitator
  Serial.begin(9600);                     // initializarea comunicatiei seriale
  vw_set_ptt_inverted(true);      
  vw_set_rx_pin(pin_primire_date);    
  vw_setup(4000);                         // viteza de transfer a datelor in Kbps
  vw_rx_start();                          // receptorul incepe sa primeasca date
  Serial.println("Robotul functioneaza"); // text afisat in Serial Monitor
}


/*
************************************************************************
Partea programului ce va rula incontinuu dupa pornirea circuitului
************************************************************************
*/
void loop() {
  uint8_t buf[VW_MAX_MESSAGE_LEN];
  uint8_t buflen = VW_MAX_MESSAGE_LEN;

  if (vw_get_message(buf, &buflen)) {
    // Deplasarea robotului in functie de orientarea mainii
    if((buf[0] == 'X') && (buf[1] == '1')) {   
      Serial.println("Robotul se deplaseaza INAPOI");
      inapoi();
      delay(100);
      stop();
    }   
    else if((buf[0] == 'X') && (buf[1] == '2')) {  
      Serial.println("Robotul se deplaseaza INAINTE");
      inainte();
      delay(100);
      stop();
    }
    else if((buf[0] == 'Y') && (buf[1] == '2')) {  
      Serial.println("Robotul se deplaseaza spre STANGA");
      stanga(); 
      delay(100);
      stop();
    }
    else if((buf[0] == 'Y') && (buf[1] == '1')) {  
      Serial.println("Robotul se deplaseaza spre DREAPTA");
      dreapta();
      delay(100);
      stop();
    }
    else if((buf[0] == 'A') && (buf[1] == '1')) {  
      Serial.println("Robotul s-a OPRIT");
      stop();
      delay(100); 
    }
  }
  else {
    Serial.println("Nu se primeste semnal...");
  }
}

/*
************************************************************************
Definirea functiilor pentru starea robotului
************************************************************************
*/

// Functia pentru deplasarea inainte
void inainte() {
  analogWrite(IN1, viteza);
  analogWrite(IN2, 0);
  analogWrite(IN3, viteza);
  analogWrite(IN4, 0);
}

// Functia pentru deplasarea inapoi
void inapoi() { 
  analogWrite(IN1, 0);
  analogWrite(IN2, viteza);
  analogWrite(IN3, 0);
  analogWrite(IN4, viteza);
}

// Functia pentru deplasarea spre stanga
void dreapta() { 
  analogWrite(IN1, 0);
  analogWrite(IN2, viteza);
  analogWrite(IN3, viteza);
  analogWrite(IN4, 0);
}

// Functia pentru deplasarea spre dreapta
void stanga() { 
  analogWrite(IN1, viteza);
  analogWrite(IN2, 0);
  analogWrite(IN3, 0);
  analogWrite(IN4, viteza);
}

// Functia pentru oprirea robotului
void stop() {  
  analogWrite(IN1, 0);
  analogWrite(IN2, 0);
  analogWrite(IN3, 0);
  analogWrite(IN4, 0);
}
