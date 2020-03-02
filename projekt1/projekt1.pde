PImage pozadina;

//pocetni = 0; prva igra = 1; druga igra = 2; povratak = 3, 4; pravila = 5  
int prozor=0; 

//za prvu igricu
int radijus=50;
int rezultat;
boolean igra;
boolean kraj;
Loptica[] protiv;
Loptica dohvati;

//za drugu igricu
int lopticax, lopticay, visinaLop, sirinaLop, brzinax, brzinay;
int lijevaL, lijevaV, debljina, visina, pomak;
int desnaD, desnaV;
boolean doleL, doleD, goreL, goreD;
color boja1 = color(255, 255, 153);
color boja2 = color (255, 255, 255);
int bodovi1 = 0; 
int bodovi2 = 0;
int p = 0;

//klasa koju implementiramo za loptice u prvoj igrici
class Loptica
{
  int x, y, brzinax, brzinay;
  
  Loptica (int x_, int y_, int brzinax_, int brzinay_)
  {
    x = x_;
    y = y_;
    brzinax = brzinax_;
    brzinay = brzinay_;
  }
  
  void update()
  {
    x += brzinax;
    y += brzinay;
    if(x <= 0 || x >= width)
      brzinax = -brzinax;
      
    if(y <= 0 || y >= width)
      brzinay = -brzinay;
  }
}

//kreiranje loptice na bilo kojoj lokaciji s random brzinom
Loptica napraviLopticu()
{
  int x, y, brzinax, brzinay;
   
  do
  {
    x = (int) random(width);
    y = (int) random(height);
  } while (dist(mouseX, mouseY, x, y) < radijus*2 + 50);
  brzinax = (int) random(5);
  brzinay = (int) random(5);
  return new Loptica(x, y, brzinax, brzinay);
}

void mousePressed()
{
  setup();
}

//napravi lopticu na početnoj lokaciji u drugoj igrici
void nacrtajLopticu() {
  fill(153, 255, 255);
  ellipse(lopticax, lopticay, visinaLop, sirinaLop);
}

//micanje lopcite određenom brzinom
void pomakniLopticu() {  
  lopticax = lopticax + brzinax*2;
  lopticay = lopticay + brzinay*2;
}

//kreiranje dvije pločice s kojima se udara loptica
void nacrtajPlocicu() {
  fill(boja1);
  rect(lijevaL, lijevaV, debljina, visina);
  fill(boja2);
  rect(desnaD, desnaV, debljina, visina);
}

//udarac loptice u bočne strane ili gornju i donju
void loptica() {
 if ( lopticax > width - sirinaLop/2) {
    setup();
    brzinax = -brzinax;
    bodovi1 = bodovi1 + 1;
  } else if ( lopticax < 0 + sirinaLop/2) {
    setup();
    bodovi2 = bodovi2 + 1;
  }
  if ( lopticay > height - visinaLop/2) {
    brzinay = -brzinay;
  } else if ( lopticay < 0 + visinaLop/2) {
    brzinay = -brzinay;
  }
}

//ispisivanje rezultata
void rezultat() {
  fill(boja1);
  text(bodovi1, 100, 50);
  fill(boja2);
  text(bodovi2, width-100, 50);
}
 
//određivanje kada smo došli do kraja igrice
void kraj() 
{
  if(bodovi1 == 5) {
    prozor = 4;
    bodovi1=0; 
    bodovi2=0;
    p=1;
  }
  if(bodovi2 == 5) {
    prozor = 4;
    bodovi1=0;
    bodovi2=0;
    p=2;
  }
}

void keyPressed() {
if (key == 'w' || key == 'W') {
    goreL = true;
  }
  if (key == 's' || key == 'S') {
    doleL = true;
  }
  if (keyCode == UP) {
    goreD = true;
  }
  if (keyCode == DOWN) {
    doleD = true;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    goreL = false;
  }
  if (key == 's' || key == 'S') {
    doleL = false;
  }
  if (keyCode == UP) {
    goreD = false;
  }
  if (keyCode == DOWN) {
    doleD = false;
  }
}

//pomicanje pločice gore ili dole
void pomakniPlocicu(){
  if (goreL) {
    lijevaV = lijevaV - pomak;
  }
  if (doleL) {
    lijevaV = lijevaV + pomak;
  }
  if (goreD) {
    desnaV = desnaV - pomak;
  }
  if (doleD) {
    desnaV = desnaV + pomak;
  }
}

//gledamo je li pločica možda došla do vrha ili dna
void plocicaUZid() {
  if (lijevaV - visina/100 < 0) {
    lijevaV = lijevaV + pomak;
  }
  if (lijevaV + visina > height) {
    lijevaV = lijevaV - pomak;
  }
  if (desnaV - visina/100 < 0) {
    desnaV = desnaV + pomak;
  }
  if (desnaV + visina > height) {
    desnaV = desnaV - pomak;
  }
}

//provjeravamo je li loptica udarila o pločicu
void dodir() {
  if (lopticax - sirinaLop/2 < lijevaL + debljina && lopticay - visinaLop/2 < lijevaV + visina/2 && lopticay + visinaLop/2 > lijevaV - visina/2 ) {
    if (brzinax < 0) {
      brzinax = -brzinax*1 + 1;
    }
  }
  else if (lopticax + sirinaLop/2 > desnaD - debljina/2 && lopticay - visinaLop/2 < desnaV + visina/2 && lopticay + visinaLop/2 > desnaV - visina/2 ) {
    if (brzinax > 0) {
      brzinax = -brzinax*1 - 1;
    }
  }
}

//funkcija koja provjerava jesmo li prošli preko nekog dijela prozora
boolean prelazak (int x, int y, int width, int height){
  if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height)
    return true;
  return false;
}

void setup(){
  //najprije postavljamo veličinu i pozadinu koje su uvijek iste
  size(700, 800);
  pozadina = loadImage("pozadina.jpg");
  pozadina.resize(700, 800);
  
  //odabrana je prva igrica, 
  if(prozor == 1)
  {
    rezultat = 0;
    igra = true;
    dohvati = napraviLopticu();
    protiv = new Loptica[50];
    protiv[0] = napraviLopticu();
  }
  
  //odabrana je druga igrica
  if(prozor == 2)
  {
    lopticax = width/2; 
    lopticay = height/2;
    visinaLop = 50;
    sirinaLop = 50;
    brzinax = 1;
    brzinay = 1;

    lijevaL = 40;
    lijevaV = height/2;
    desnaD = width-40;
    desnaV = height/2;
    debljina = 30;
    visina = 100;
    pomak = 5;
  }
}

void draw(){
  //početni prozor
  if(prozor == 0)
  {
      background(pozadina);
      
      fill(255, 255, 153);
      textSize(60);
      text("Igrice s lopticom", 330, 100);
      
      fill(185, 59, 59);
      rect(150, 300, 160, 100);
      
      fill(185, 59, 59);
      rect(350, 300, 160, 100);
      
      fill(185, 59, 59);
      rect(250, 440, 160, 100);
      

      fill(0, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(20);
      //tri buttona 
      text("1 IGRAČ", 230, 350);
      text("2 IGRAČA", 430, 350);
      text("PRAVILA", 330, 490);

      if(mousePressed)
      {
        if(prelazak(150, 300, 160, 100))
          {
            prozor = 1;
          }
        if(prelazak(350, 300, 160, 100))
        {
          prozor = 2;
        }
        if(prelazak(250, 440, 160, 100))
        {
          prozor = 5;
        }
      }
  }
  
  //prva igrica
  if(prozor == 1)
  {
    if(igra)
    {
      background(pozadina);
    
      fill(255, 255, 255);
      textSize(30);
      text("Rezultat: " + rezultat, 80, 40);
      
      //crvena loptica koja je uvijek tamo gdje je miš
      fill(255, 0, 0);
      ellipse(mouseX, mouseY, radijus, radijus);
      
      //zelena loptica koju trebamo uhvatiti
      fill(0, 255, 0);
      ellipse(dohvati.x, dohvati.y, radijus, radijus);
      dohvati.update();
    
      //plave loptice koje ne smijemo udariti
      fill(0, 0, 255);
      for(int i = 0; i<rezultat +1; i++)
      {
        protiv[i].update();
        ellipse(protiv[i].x, protiv[i].y, radijus, radijus);
        
        //dotakli smo plavu
        if (dist(mouseX, mouseY, protiv[i].x, protiv[i].y) < radijus )
        {
          igra = false;
          prozor = 3;
        }
      }
    
      //dotakli smo zelenu
      if (dist(mouseX, mouseY, dohvati.x, dohvati.y) < radijus)
      {
        rezultat++;
        protiv[rezultat] = napraviLopticu();
        dohvati = napraviLopticu();
      }
    }
  }
  
  //odabrana je druga igrica
  if(prozor == 2)
  {
    background(pozadina);
    nacrtajLopticu();
    pomakniLopticu();
    loptica();
    nacrtajPlocicu();
    pomakniPlocicu();
    plocicaUZid();
    dodir();
    rezultat();
    kraj();
  }
  
  //prozor nakon kraja prve igrice
  if(prozor == 3)
  {
    background(pozadina);
      
    fill(255, 255, 153);
    textSize(60);
    text("Kraj igre\nOsvojili ste " + rezultat + " loptica", 330, 100);
    
    fill(185, 59, 59);
    rect(150, 200, 160, 100);
     
    fill(185, 59, 59);
    rect(350, 200, 160, 100);
      

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("IGRAJ \nPONOVO", 430, 250);
    text("POČETNI \nIZBORNIK", 230, 250);

    if(mousePressed)
    {
      if(prelazak(150, 200, 160, 100))
      {
        prozor = 0;
        setup();
      }
      if(prelazak(350, 200, 160, 100))
      {
        prozor = 1;
        setup();
      }
    }
  }  
  
  //prozor nakon kraja druge igrice
  if(prozor == 4)
  {
    background(pozadina);
      
    fill(255, 255, 153);
    textSize(60);
    text("Kraj igre\nPobijedio je igrač broj " + p, 330, 100);
    
    fill(185, 59, 59);
    rect(150, 300, 160, 100);
     
    fill(185, 59, 59);
    rect(350, 300, 160, 100);
      

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("IGRAJ \nPONOVO", 430, 350);
    text("POČETNI \nIZBORNIK", 230, 350);

    if(mousePressed)
    {
      if(prelazak(150, 300, 160, 100))
      {
        prozor = 0;
        setup();
      }
      if(prelazak(350, 300, 160, 100))
      {
        prozor = 2;
        setup();
      }
    }
  }
  
  //pravila
  if(prozor == 5)
  {
    background(pozadina);
      
    fill(boja1);
    textSize(40);
    text("Igrica za jednog igrača", 320 , 50);
    textSize(30);
    textAlign(LEFT);
    fill(boja2);
    text("U ovoj igrici, vi ste crvena loptica. \nPomičući miša, mičete svoju lopticu. \nCilj je tom lopticom dotaknuti što više zelenih. \nSa svakom dotaknutom zelenom lopticom, \nbroj plavih se povečava.\nIgra je gotova kada dotaknete plavu lopticu", 25, 100);
   
    fill(boja1);
    textSize(40);
    text("Igrica za dva igrača", 100, 400);
    textSize(30);
    textAlign(LEFT);
    fill(boja2);
    text("Cilj ove igrice je poslati protivniku \nlopticu tako da je on ne može vratiti. \nPobjednik je onaj igrač kojem to 5 puta \npođe za rukom.", 25, 450);
 
    fill(185, 59, 59);
    rect(250, 650, 160, 100); 

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("NAZAD", 330, 700);
    
    if(mousePressed)
    {
      if(prelazak(250, 650, 160, 100))
      {
        prozor = 0;
        setup();
      }
    }
  }
}
