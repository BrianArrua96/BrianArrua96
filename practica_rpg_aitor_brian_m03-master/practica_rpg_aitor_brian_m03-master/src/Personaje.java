/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.util.Scanner;

/**
 *
 * @author alshi
 */
public abstract class Personaje {

    private String nombre;
    private int fuerza, constitucion, velocidad, inteligencia, suerte;
    private int pSalud, pDmg, probAtaque, probEsquivar;
    private int pExp, nivel;
    private Arma arma;
    private int saludTotal;

    //Constructor
    public Personaje(String nombre, int fuerza, int constitucion, int velocidad, int inteligencia, int suerte, Arma arma) {
        this.nombre = nombre;
        this.fuerza = fuerza;
        this.constitucion = constitucion;
        this.velocidad = velocidad;
        this.inteligencia = inteligencia;
        this.suerte = suerte;
        this.arma = arma;
        this.pExp = 0;
        this.nivel = 0;
        calculaSecundarias();
    }

    // Getters
    public String getNombre() {
        return nombre;
    }

    public int getFuerza() {
        return fuerza;
    }

    public int getConstitucion() {
        return constitucion;
    }

    public int getVelocidad() {
        return velocidad;
    }

    public int getInteligencia() {
        return inteligencia;
    }

    public int getSuerte() {
        return suerte;
    }

    public int getEstadisticasPrincTotales() {
        return fuerza + constitucion + velocidad + inteligencia + suerte;
    }

    public int getpSalud() {
        return pSalud;
    }

    public int getpDmg() {
        return pDmg;
    }

    public int getProbAtaque() {
        return probAtaque;
    }

    public int getProbEsquivar() {
        return probEsquivar;
    }

    public int getpExp() {
        return pExp;
    }

    public int getNivel() {
        return nivel;
    }

    public Arma getArma() {
        return arma;
    }

    // Setters
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setFuerza(int fuerza) {
        if (fuerza >= 3) {
            this.fuerza = fuerza;
        } else {
            System.out.println("Ninguna estadística principal puede ser menor a 3.");
        }
    }

    public void setConstitucion(int constitucion) {
        if (constitucion >= 3) {
            this.constitucion = constitucion;
        } else {
            System.out.println("Ninguna estadística principal puede ser menor a 3.");
        }
    }

    public void setVelocidad(int velocidad) {
        if (velocidad >= 3) {
            this.velocidad = velocidad;
        } else {
            System.out.println("Ninguna estadística principal puede ser menor a 3.");
        }
    }

    public void setInteligencia(int inteligencia) {
        if (inteligencia >= 3) {
            this.inteligencia = inteligencia;
        } else {
            System.out.println("Ninguna estadística principal puede ser menor a 3.");
        }
    }

    public void setSuerte(int suerte) {
        if (suerte >= 3) {
            this.suerte = suerte;
        } else {
            System.out.println("Ninguna estadística principal puede ser menor a 3.");
        }
    }

    // Setters para estadísticas secundarias. Protected para que solo puedan acceder
    // los hijos.
    protected void setpSalud(int pSalud) {
        this.pSalud = pSalud;
    }

    protected void setpDmg(int pDmg) {
        this.pDmg = pDmg;
    }

    protected void setProbAtaque(int probAtaque) {
        this.probAtaque = probAtaque;
    }

    protected void setProbEsquivar(int probEsquivar) {
        this.probEsquivar = probEsquivar;
    }

    public int recibirDmg(int pDmg) {
        return ((int) (pSalud - pDmg));
    }

    public void restaurarSalud() {
        pSalud = saludTotal;
    }

    public void aumentarExp(int Exp) {
        pExp += Exp;
        compruebaExpNivel();
    }

    public void subirNivel() {
        if (nivel < 5) {
            nivel++;
            setFuerza(getFuerza() + 2);
            setConstitucion(getConstitucion() + 2);
            setVelocidad(getVelocidad() + 2);
            setInteligencia(getInteligencia() + 2);
            setSuerte(getSuerte() + 2);
            this.calculaSecundarias();
            System.out.printf("Enhorabuena, %s ha llegado al nivel %d. Todas sus"
                    + " estadísticas se han visto aumentadas en 2 puntos. %n", this.getNombre(), this.getNivel());
        } else {
            System.out.println("Has llegado al nivel máximo, no se puede conseguir más experiencia");
        }
    }

    public void compruebaExpNivel() {
        int nivelActual = this.nivel;
        switch (nivelActual) {
            case 0:
                if (pExp >= 100) {
                    subirNivel();
                    pExp -= 100;
                }
                break;
            case 1:
                if (pExp >= 200) {
                    subirNivel();
                    pExp -= 200;
                }
                break;
            case 2:
                if (pExp >= 500) {
                    subirNivel();
                    pExp -= 500;
                }
                break;
            case 3:
                if (pExp >= 1000) {
                    subirNivel();
                    pExp -= 1000;
                }
                break;
            case 4:
                if (pExp >= 2000) {
                    subirNivel();
                    pExp -= 2000;
                }
                break;
            default:
                throw new AssertionError();
        }
    }

    // Métodos para calcular estadísticas secundarias
    protected void calculaSecundarias() {
        calculapSalud();
        calculapDmg();
        calculaProbAtaque();
        calculaProbEsquivar();
    }

    public int getSaludTotal() {
        return saludTotal;
    }

    public void setSaludTotal(int saludTotal) {
        this.saludTotal = saludTotal;
    }

    protected void calculapSalud() {
        this.pSalud = constitucion + fuerza;
        saludTotal = pSalud;
    }

    protected void calculapDmg() {
        this.pDmg = (fuerza + arma.getwPow()) / 4;
    }

    protected void calculaProbAtaque() {
        this.probAtaque = inteligencia + suerte + velocidad;
    }

    protected void calculaProbEsquivar() {
        this.probEsquivar = velocidad + suerte + inteligencia;
    }

    //Métodos de acción del juego
    public boolean atacar(int resultadoDados) {
        System.out.println("tirada: " + resultadoDados);
        if (resultadoDados <= probAtaque) {
            System.out.println(this.nombre + " ha acertado el ataque.");
            return true;
        } else {
            System.out.println(this.nombre + " ha fallado el ataque.");
            return false;
        }
    }

    public boolean esquivar(int resultadoDados) {
        System.out.println("tirada: " + resultadoDados);
        if (resultadoDados <= probEsquivar) {
            System.out.println(this.nombre + " ha esquivado el ataque.");
            return true;
        } else {
            System.out.println(this.nombre + " no ha esquivado el ataque.");
            return false;
        }
    }
}
