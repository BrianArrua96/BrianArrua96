/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.util.Scanner;
/**
 *
 * @author alshi
 */
public class Maia extends Personaje {

    public Maia(String nombre, int fuerza, int constitucion, int velocidad, int inteligencia, int suerte, Arma arma) {
        super(nombre, fuerza, constitucion, velocidad, inteligencia, suerte, arma);
    }
    
    public void calculaProbAtaque(){
        this.setProbAtaque(this.getInteligencia()+this.getSuerte()+this.getArma().getwPow()
                +getVelocidad());
    }
}
