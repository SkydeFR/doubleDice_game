import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

int nb_lancer = 0, nb_loose = 0, nb_win = 0, nb_db6 = 0;
boolean stats, pressed_check, key_p, mouse_p, test_db, test_db6;
boolean keyPressed_check = false, mousePressed_check = false;
char touche;

void setup()
{
  /*DEBUT PARAMETRES*/
  //Fichier de configuration
  String CONFIG_FILE = "config.properties";
  Properties prop = new Properties();
  try {
    prop.load(new FileInputStream(sketchPath("")+CONFIG_FILE));
    prop.list(System.out);
    System.out.println("-- loading properties successfully --");
  } catch (IOException ex) {
    ex.printStackTrace(); 
  }
  
  //Configuration recommandée
  stats = boolean(prop.getProperty("stats")); //Afficher ou non les statistiques (nécessite d'activer la fonction "rejouer" au moins par touche ou par bouton cliquable)
  key_p = boolean(prop.getProperty("key_p")); //Activer ou non la fonction "rejouer" à l'aide d'une touche
  mouse_p = boolean(prop.getProperty("mouse_p")); //Activer ou non la fonction "rejouer" à l'aide du bouton cliquable

  //Configuration avancée
  pressed_check = boolean(prop.getProperty("pressed_check")); //Empêche l'activation de la fonction "rejouer" de façon continue (notamment en laissant la touche ou le clique activé en permanance)
  test_db = boolean(prop.getProperty("test_db")); //Forcer le résultat "Obtenir un double"
  test_db6 = boolean(prop.getProperty("test_db6")); //Forcer le résultat "Obtenir un double 6"

  //Variables à configurer
  String name = "Lancer de dés"; //Nom du programme
  touche = prop.getProperty("touche").charAt(0); //Touche utilisée pour rejouer
  /*FIN PARAMETRES*/
  
  //surface.setTitle(name); /* Fonction compatible Processing 3 uniquement */
  frame.setTitle(name); /* Fonction compatible Processing 2 & 3 */

  size(350, 450);
  background(0);
  if (stats == true && (key_p == false && mouse_p == false))
    stats = false;

  lancer();
  delay(500);
}

void draw()
{
  if (key_p) { /* Effectuer un nouveau lancer via une touche */
    if (!keyPressed) keyPressed_check = false; /* Empêche de laisser la touche activée en continue */
    else if (keyPressed && (keyPressed_check == false || pressed_check == false)) {
      if (key == touche) {
        lancer();
        delay(500);
        keyPressed_check = true;
      } else
        keyPressed_check = false;
    }
  }
  if (mouse_p) { /* Effectuer un nouveau lancer via le bouton cliquable */
    if (!mousePressed) mousePressed_check = false; /* Empêche de laisser la zone cliquable activée en continue */
    else if (mousePressed && (mousePressed_check == false || pressed_check == false)) {
      //Rappel : Coordonnées de la zone cliquable => rect(100, 275, 150, 45)
      if ((mouseX >= 100 && mouseX <= 100+150) && (mouseY >= 275 && mouseY <= 275+45)) {
        lancer();
        delay(500);
        mousePressed_check = true;
      }
    }
  }
}

/* Fonction principale (lancer de dés) */
void lancer()
{
  background(0);
  nb_lancer++;
  if (stats) println("Lancer numéro : "+nb_lancer);
  float X = random(1, 7), Y = random(1, 7);
  int x = int(X), y = int(Y);
  if (test_db) y = x; /* Forcer un double */
  if (test_db6) {
    /* Forcer un double 6 */
    x = 6; 
    y = 6;
  }

  /* Partie principale */
  println ("le lancer de dés donne "+ x + " et "+ y +" !");
  textSize(15);
  fill(255);
  text("Le lancer de dés donne "+ x +" et "+ y +" !", 55, 175);
  if (x == y) {
    print("Bravo ! Vous avez fait un double !");
    nb_win++;
    fill(50, 255, 50);
    text("Bravo ! Vous avez fait un double !", 55, 200);
    if (x == 6 && y == 6) {
      println(" Et en plus, c'est un double 6 !");
      nb_db6++;
      fill(255, 255, 50);
      text("Et en plus, c'est un double 6 !", 55, 225);
    } else {
      println();
    }
  } else {
    println("Dommage ! C'est perdu ):");
    nb_loose++;
    fill(255, 50, 50);
    text("Dommage ! C'est perdu ):", 55, 200);
  }
  println();

  if (stats) {
    stroke(255);
    strokeWeight(1);
    noFill();
    rect(45+10, 375, 240, 60);

    fill(200);
    textSize(12);
    text("Lancer numéro : "+ nb_lancer, 10, 20);
    fill(255, 50, 50);
    text("Parties perdues : "+ nb_loose, 55+10, 395);
    fill(50, 255, 50);
    text("Parties gagnées : "+ nb_win, 54+10, 410);
    fill(255, 255, 50);
    text("Doubles six : "+nb_db6, 187+10, 425);
  }

  if (key_p) { /* Effectuer un nouveau lancer via une touche */
    fill(150, 150, 200);
    textSize(12);
    text("Touche pour rejouer : "+ touche, 200, 20);
  }
  if (mouse_p) { /* Effectuer un nouveau lancer via un bouton cliquable */
    stroke(0, 0, 100);
    strokeWeight(3);
    fill(150, 150, 200);
    rect(100, 275, 150, 45);
    fill(0, 0, 75);
    textSize(18);
    text("Rejouer", 142, 305);
  }

  /* Graphiques des faces de dés */
  fill(0);
  stroke(255);
  strokeWeight(5);
  rect(60, 50, 75, 75);
  rect(210, 50, 75, 75);
  fill(255);

  strokeWeight(10);
  if (x == 1) {
    d1();
  } else if (x == 2) {
    d2();
  } else if (x == 3) {
    d3();
  } else if (x == 4) {
    d4();
  } else if (x == 5) {
    d5();
  } else if (x == 6) {
    d6();
  } else {
    println("Error 01");
  }
  translate(150, 0);
  if (y == 1) {
    d1();
  } else if (y == 2) {
    d2();
  } else if (y == 3) {
    d3();
  } else if (y == 4) {
    d4();
  } else if (y == 5) {
    d5();
  } else if (y == 6) {
    d6();
  } else {
    println("Error 02");
  }
  translate(-150, 0);
}

/* Fonctions des différentes faces de dés */
void d1()
{
  point(97, 87);
}

void d2()
{
  point(97-20, 87-20);
  point(97+20, 87+20);
}

void d3()
{
  d1();
  d2();
}

void d4()
{
  d2();
  point(97+20, 87-20);
  point(97-20, 87+20);
}

void d5()
{
  d1();
  d4();
}

void d6()
{
  d4();
  point(97-20, 87);
  point(97+20, 87);
}