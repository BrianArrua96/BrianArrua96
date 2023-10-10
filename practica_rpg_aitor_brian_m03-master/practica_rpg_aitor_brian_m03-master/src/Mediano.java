/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.util.Scanner;
/**
 *
 * @author alshi
 */
public class Mediano extends Personaje {

    public Mediano(String nombre, int fuerza, int constitucion, int velocidad, int inteligencia, int suerte, Arma arma) {
        super(nombre, fuerza, constitucion, velocidad, inteligencia, suerte, arma);
    }

    @Override
    public void calculaProbEsquivar() {
        this.setProbEsquivar(this.getVelocidad()+this.getSuerte()+
                this.getInteligencia()+this.getFuerza());
    }
    
}
