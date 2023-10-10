
import java.util.Scanner;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
/**
 *
 * @author brian arrua
 */
public class LordsOfSteel {

    public static final int MAX_PJ = 10;
    public static Personaje[] PERSONAJES = new Personaje[MAX_PJ];

    public static void main(String[] args) {
        creacionPJsInic();
        if (menuJuego()) {
            System.out.println("¡Muchas gracias por jugar! Esperamos verle pronto.");
        }
    }

    //método para la creación de los 4 personajes iniciales de prueba
    public static void creacionPJsInic() {
        // creación de las armas
        Arma daga = new Arma(5, 15);
        Arma espada = new Arma(10, 10);
        Arma martillo = new Arma(15, 5);

        // creación de un mediano
        Mediano frodo = new Mediano("Frodo", 8, 7, 18,
                11, 16, daga);
        PERSONAJES[0] = frodo;

        //creación de un enano
        Enano gimli = new Enano("Gimli", 17, 16, 8,
                8, 11, martillo);
        PERSONAJES[1] = gimli;

        //creación de un humano
        Humano araggorn = new Humano("Aragorn", 15, 12, 11,
                11, 10, espada);
        PERSONAJES[2] = araggorn;

        //creación de un maia
        Maia gandalf = new Maia("Gandalf", 9, 11, 10,
                18, 14, daga);
        PERSONAJES[3] = gandalf;
    }

    // Menús
    // Menú específico para la función de borrar, lanzará un print de los pjs, recogerá 
    // el número de pj y lo pasará a otro método que se encargará de realizar el borrado.
    public static void menuBorrarPJ() {
        Scanner in = new Scanner(System.in);
        boolean exit = false;

        do {
            int opcion;

            System.out.println("Elige un personaje para borrarlo: ");
            printPJs();
            System.out.printf("(%d) Ir al menú anterior.%n", (posicionVacia() + 1));
            if (in.hasNextInt()) {
                opcion = in.nextInt();

                if (opcion > 0 && opcion <= posicionVacia() + 1) {
                    if (opcion < posicionVacia() + 1) {
                        borraPJ(opcion);
                    } else if (opcion == posicionVacia() + 1) {
                        exit = true;
                    }

                } else {
                    System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                    in.nextLine();
                }
            } else {
                System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                in.nextLine();
            }
        } while (!exit);

    }

    // Menú específico para la función de editar, lanzará un print de los pjs, recogerá 
    // el número de pj y lo pasará a otro método que se encargará de realizar los cambios.
    public static void menuEditarPJ() {
        Scanner in = new Scanner(System.in);
        boolean exit = false;

        do {
            int opcion;

            System.out.println("Elige un personaje para editarlo: ");
            printPJs();
            System.out.printf("(%d) Ir al menú anterior.%n", (posicionVacia() + 1));
            if (in.hasNextInt()) {
                opcion = in.nextInt();

                if (opcion > 0 && opcion <= posicionVacia() + 1) {
                    if (opcion < posicionVacia() + 1) {
                        editaPJ(opcion);
                    } else if (opcion == posicionVacia() + 1) {
                        exit = true;
                    }

                } else {
                    System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                    in.nextLine();
                }
            } else {
                System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                in.nextLine();
            }
        } while (!exit);

    }

    // Menú específico para la función de combate, lanzará un print de los pjs, recogerá 
    // el número de pj del atacante, volverá a lanzar el print y lo pasará a otro método que se encargará de
    // llevar a cabo el combate.
    public static void menuCombatir() {
        Scanner in = new Scanner(System.in);
        boolean defensa = false;
        boolean exit = false;
        int atacante = -1;
        int defensor = -1;

        do {
            int opcion;

            if (!defensa) {
                System.out.println("Elige el personaje atacante en el combate: ");
                printPJs();
            } else {
                System.out.println("Elige el personaje defensor en el combate: ");
                printPJs(atacante);
            }
            System.out.printf("(%d) Ir al menú anterior.%n", (posicionVacia() + 1));

            if (in.hasNextInt()) {
                opcion = in.nextInt();

                if (opcion > 0 && opcion <= posicionVacia() + 1) {
                    if (opcion < posicionVacia() + 1) {
                        if (!defensa) {
                            atacante = opcion - 1;
                            defensa = true;
                        } else if (defensa && opcion - 1 != atacante) {
                            defensor = opcion - 1;
                        } else {
                            System.out.println("No puedes elegir dos veces el mismo personaje.");
                        }
                    } else if (opcion == posicionVacia() + 1) {
                        exit = true;
                    }

                } else {
                    System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                    in.nextLine();
                }
            } else {
                System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                in.nextLine();
            }
            if (atacante != -1 && defensor != -1) {
                combate(atacante, defensor);
                exit = true;
            }
        } while (!exit);

    }

    // Menú inicial del juego, desde el se puede acceder a todas las funcionalidades: editar, borrar, crear
    // combatir o salir
    public static boolean menuJuego() {
        Scanner in = new Scanner(System.in);
        boolean exit = false;

        System.out.println("¡Bienvenidos a Lords of Steel!");

        do {
            int opcion;

            System.out.printf(
                    "Elegid una opción indicando un número:%n"
                    + "(1) Crear un nuevo Personaje%n"
                    + "(2) Borrar un Personaje%n"
                    + "(3) Editar un Personaje%n"
                    + "(4) Iniciar un combate%n"
                    + "(5) Salir%n");

            if (in.hasNextInt()) {
                opcion = in.nextInt();

                if (opcion > 0 && opcion <= 5) {
                    switch (opcion) {
                        // 1.Lanza un método para crear un nuevo PJ
                        case 1:
                            menucrearPJs();
                            break;

                        // 2.Lanza un método que muestra la lista de personajes, numerados
                        // y nos permite elegir uno para eliminarlo.
                        case 2:
                            menuBorrarPJ();
                            break;

                        // 3.Lanza un método que muestra la lista de personajes, numerados
                        // y nos permite elegir uno para editarlo.
                        case 3:
                            menuEditarPJ();
                            break;

                        // 4. Lanza el método que lleva los combates.
                        case 4:
                            menuCombatir();
                            break;

                        // 5. Permite salir del juego, cambia el booleano a true.
                        case 5:
                            exit = true;
                            break;
                        default:
                            throw new AssertionError();
                    }
                } else {
                    System.out.println("Ha de introducir un número entero del 1 al 5.");
                    in.nextLine();
                }
            } else {
                System.out.println("Ha de introducir un número entero del 1 al 5.");
                in.nextLine();
            }
        } while (!exit);

        return exit;
    }

    public static void menucrearPJs() {
        Scanner in = new Scanner(System.in);
        boolean exit = false;

        do {
            int opcion;
            System.out.printf("(%d) Enano.%n", 1);
            System.out.printf("(%d) Humano.%n", 2);
            System.out.printf("(%d) Mediano.%n", 3);
            System.out.printf("(%d) Maia.%n", 4);
            System.out.printf("(%d) Ir al menú anterior.%n", 5);
            if (in.hasNextInt()) {
                opcion = in.nextInt();

                if (opcion > 0 && opcion <= 5) {
                    if (opcion < 5) {
                        crearPJs(opcion);
                    } else if (opcion == 5) {
                        exit = true;
                    }

                } else {
                    System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                    in.nextLine();
                }
            } else {
                System.out.printf("Ha de introducir un número entero del 1 al %d.%n", posicionVacia() + 1);
                in.nextLine();
            }
        } while (!exit);
    }

    public static void crearPJs(int tipo) {
        Scanner in = new Scanner(System.in);
        boolean salir = true,
                repetir = false,
                repetircons = false,
                repetirvel = false,
                repetirint = false,
                repetirsue = false;
        Arma daga = new Arma(5, 15);
        Arma espada = new Arma(10, 10);
        Arma martillo = new Arma(15, 5);
        String nombre;
        int fuerza = 0, constitucion = 0, velocidad = 0, inteligencia = 0, suerte = 0, opcionArma = 0;

        System.out.println("Nombre del personaje:");
        nombre = in.nextLine();
        do {
            if (fuerza < 3 || fuerza > 18 || repetir == true) {
                System.out.println("fuerza:");
                fuerza = in.nextInt();
                repetir = false;
            } else if (constitucion < 3 || constitucion > 18 || repetircons == true) {
                System.out.println("constitucion:");
                constitucion = in.nextInt();
                repetircons = false;
            } else if (velocidad < 3 || velocidad > 18 || repetirvel == true) {
                System.out.println("velocidad:");
                velocidad = in.nextInt();
                repetirvel = false;
            } else if (inteligencia < 3 || inteligencia > 18 || repetirint == true) {
                System.out.println("inteligencia:");
                inteligencia = in.nextInt();
                repetirint = false;
            } else if (suerte < 3 || suerte > 18 || repetirsue == true) {
                System.out.println("suerte:");
                suerte = in.nextInt();
                repetirsue = false;
            } else if ((fuerza + constitucion + velocidad + inteligencia + suerte) > 60 
                    || (fuerza + constitucion + velocidad + inteligencia + suerte) < 60) {
                System.out.println("Los atributos son menores o mayores a los requeridos, repite.");
                repetir = true;
                repetircons = true;
                repetirvel = true;
                repetirint = true;
                repetirsue = true;
            } else {
                salir = false;
            }
        } while (salir == true);

        switch (tipo) {
            case 1:
                System.out.println("Escoge arma: (1)Daga (2)Espada (3)Martillo");
                opcionArma = in.nextInt();
                switch (opcionArma) {
                    case 1:
                        Enano enano = new Enano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, daga);
                        PERSONAJES[posicionVacia()] = enano;
                        break;
                    case 2:
                        Enano enano1 = new Enano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, espada);
                        PERSONAJES[posicionVacia()] = enano1;
                        break;
                    case 3:
                        Enano enano2 = new Enano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, martillo);
                        PERSONAJES[posicionVacia()] = enano2;
                        break;
                }
                break;
            case 2:
                System.out.println("Escoge arma: (1)Daga (2)Espada (3)Martillo");
                opcionArma = in.nextInt();
                switch (opcionArma) {
                    case 1:
                        Humano humano = new Humano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, daga);
                        PERSONAJES[posicionVacia()] = humano;
                        break;
                    case 2:
                        Humano humano1 = new Humano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, espada);
                        PERSONAJES[posicionVacia()] = humano1;
                        break;
                    case 3:
                        Humano humano2 = new Humano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, martillo);
                        PERSONAJES[posicionVacia()] = humano2;
                        break;
                }
                break;
            case 3:
                System.out.println("Escoge arma: (1)Daga (2)Espada (3)Martillo");
                opcionArma = in.nextInt();
                switch (opcionArma) {
                    case 1:
                        Mediano mediano = new Mediano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, daga);
                        PERSONAJES[posicionVacia()] = mediano;
                        break;
                    case 2:
                        Mediano mediano1 = new Mediano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, espada);
                        PERSONAJES[posicionVacia()] = mediano1;
                        break;
                    case 3:
                        Mediano mediano2 = new Mediano(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, martillo);
                        PERSONAJES[posicionVacia()] = mediano2;
                        break;
                }
                break;
            case 4:
                System.out.println("Escoge arma: (1)Daga (2)Espada (3)Martillo");
                opcionArma = in.nextInt();
                switch (opcionArma) {
                    case 1:
                        Maia maia = new Maia(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, daga);
                        PERSONAJES[posicionVacia()] = maia;
                        break;
                    case 2:
                        Maia maia1 = new Maia(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, espada);
                        PERSONAJES[posicionVacia()] = maia1;
                        break;
                    case 3:
                        Maia maia2 = new Maia(nombre, fuerza, constitucion, velocidad,
                                inteligencia, suerte, martillo);
                        PERSONAJES[posicionVacia()] = maia2;
                        break;
                }
                break;
        }
    }

    // Método que realiza la edición de los personajes.
    public static void editaPJ(int numPJ) {
        boolean exit = false;
        Scanner in = new Scanner(System.in);
        Personaje pj = PERSONAJES[numPJ - 1];
        String nombre;
        int fuerza, constitucion, velocidad, inteligencia, suerte;
        int puntosTotalesIniciales = pj.getEstadisticasPrincTotales();

        do {
            int opcion;
            System.out.println("¿Qué deseas modificar? Indica la opción con el número correspondiente.");
            System.out.println("Puntos de estadística por asignar: " + (puntosTotalesIniciales - pj.getEstadisticasPrincTotales()));
            System.out.printf("(1) Nombre: %s %n"
                    + "(2) Fuerza: %d%n"
                    + "(3) Constitución: %d%n"
                    + "(4) Velocidad: %d%n"
                    + "(5) Inteligencia: %d%n"
                    + "(6) Suerte: %d%n"
                    + "(7) Ir al menú anterior%n", pj.getNombre(), pj.getFuerza(),
                    pj.getConstitucion(), pj.getVelocidad(), pj.getInteligencia(),
                    pj.getSuerte());

            if (in.hasNextInt()) {
                opcion = in.nextInt();
                in.nextLine();

                if (opcion > 0 && opcion <= 7) {

                    int puntos;
                    int original;

                    switch (opcion) {
                        case 1:
                            System.out.printf("Introduzca un nuevo nombre para el personaje, el anterior era: %s.%n",
                                    pj.getNombre());
                            pj.setNombre(in.nextLine());
                            break;
                        case 2:
                            System.out.print("Introduzca un nuevo valor para la fuerza del personaje: ");
                            puntos = in.nextInt();
                            original = pj.getFuerza();
                            if (pj.getEstadisticasPrincTotales() - original + puntos <= puntosTotalesIniciales) {
                                pj.setFuerza(puntos);
                                System.out.println("-- Cambio realizado con éxito. --");
                            } else {
                                System.out.println("-- No hay suficientes puntos libres para asignar. --");
                            }
                            in.nextLine();
                            break;
                        case 3:
                            System.out.print("Introduzca un nuevo valor para la constitución del personaje: ");
                            puntos = in.nextInt();
                            original = pj.getConstitucion();
                            if (pj.getEstadisticasPrincTotales() - original + puntos <= puntosTotalesIniciales) {
                                pj.setConstitucion(puntos);
                                System.out.println("-- Cambio realizado con éxito. --");
                            } else {
                                System.out.println("-- No hay suficientes puntos libres para asignar. --");
                            }
                            in.nextLine();
                            break;
                        case 4:
                            System.out.print("Introduzca un nuevo valor para la velocidad del personaje: ");
                            puntos = in.nextInt();
                            original = pj.getVelocidad();
                            if (pj.getEstadisticasPrincTotales() - original + puntos <= puntosTotalesIniciales) {
                                pj.setVelocidad(puntos);
                                System.out.println("-- Cambio realizado con éxito. --");
                            } else {
                                System.out.println("-- No hay suficientes puntos libres para asignar. --");
                            }
                            in.nextLine();
                            break;
                        case 5:
                            System.out.print("Introduzca un nuevo valor para la inteligencia del personaje: ");
                            puntos = in.nextInt();
                            original = pj.getInteligencia();
                            if (pj.getEstadisticasPrincTotales() - original + puntos <= puntosTotalesIniciales) {
                                pj.setInteligencia(puntos);
                                System.out.println("-- Cambio realizado con éxito. --");
                            } else {
                                System.out.println("-- No hay suficientes puntos libres para asignar. --");
                            }
                            in.nextLine();
                            break;
                        case 6:
                            System.out.print("Introduzca un nuevo valor para la suerte del personaje: ");
                            puntos = in.nextInt();
                            original = pj.getSuerte();
                            if (pj.getEstadisticasPrincTotales() - original + puntos <= puntosTotalesIniciales) {
                                pj.setSuerte(puntos);
                                System.out.println("-- Cambio realizado con éxito. --");
                            } else {
                                System.out.println("-- No hay suficientes puntos libres para asignar. --");
                            }
                            in.nextLine();
                            break;
                        case 7:
                            int difPuntos = puntosTotalesIniciales - pj.getEstadisticasPrincTotales();
                            if (difPuntos == 0) {
                                exit = true;
                                pj.calculaSecundarias();
                            } else if (difPuntos < 0) {
                                System.out.printf("-- Has asignado más puntos de los disponibles."
                                        + " Sobran %d puntos. -- %n", difPuntos);
                            } else if (difPuntos > 0) {
                                System.out.printf("-- Te faltan %d puntos por asignar. -- %n", difPuntos);
                            }
                            break;
                        default:
                            throw new AssertionError();
                    }
                } else {
                    System.out.println("Ha de introducir un número entero del 1 al 5.");
                    in.nextLine();
                }
            } else {
                System.out.println("Ha de introducir un número entero del 1 al 5.");
                in.nextLine();
            }
        } while (!exit);

    }

    // Método que realiza el borrado de los personajes. Todo correcto.
    public static void borraPJ(int numPJ) {
        for (int i = numPJ - 1; i < posicionVacia(); i++) {
            if (i == posicionVacia() - 1) {
                PERSONAJES[i] = null;
            } else {
                PERSONAJES[i] = PERSONAJES[i + 1];
            }

        }
    }

    // Método que lleva a cabo los combates. Recibe dos integers el primero con la posición del atacante en el array
    // el segundo con la del defensor. Bucle que va pasando los turnos alternando entre los personajes el ataque y la defensa.
    public static void combate(int pj1, int pj2) {
        Personaje personaje1 = PERSONAJES[pj1];
        Personaje personaje2 = PERSONAJES[pj2];
        int saludP1 = personaje1.getpSalud();
        int saludP2 = personaje2.getpSalud();
        int xpGanada = 0;

        for (int i = 0; saludP1 > 0 && saludP2 > 0; i++) {
            System.out.printf("Turno %d.%n", i);
            if (i == 0 || i % 2 == 0) {
                System.out.printf("Atacante: %s | Defensor: %s %n", personaje1.getNombre(), personaje2.getNombre());
                if (personaje1.atacar(tirarDados())) {
                    boolean esquive = personaje2.esquivar(tirarDados());
                    if (!esquive) {
                        System.out.printf("%s ha hecho %d puntos de daño a %s.%n",
                                personaje1.getNombre(), personaje1.getpDmg(), personaje2.getNombre());
                        saludP2 -= personaje1.getpDmg();
                        // si el personaje pertenece al orden, recupera un 10% de la salud sin llegar al máximo.
                        if (personaje1 instanceof Orden && saludP1 <= (int) (0.9 * personaje1.getSaludTotal())) {
                            int recuperacion = (int) (0.1 * personaje1.getSaludTotal());
                            saludP1 += recuperacion;
                            System.out.printf("%s recupera %d puntos de salud.%n", personaje1.getNombre(), recuperacion);
                        }
                        // si el personaje enemigo es del Caos y esquiva, intenta lanzar un contraataque
                    } else if (esquive && personaje2 instanceof Caos) {
                        ((Caos) personaje2).contraataque(tirarDados());
                        System.out.printf("%s contraataca.%n", personaje2.getNombre());
                    }
                }
            } else {
                System.out.printf("Atacante: %s | Defensor: %s %n", personaje2.getNombre(), personaje1.getNombre());
                if (personaje2.atacar(tirarDados())) {
                    boolean esquive = personaje1.esquivar(tirarDados());
                    if (!esquive) {
                        System.out.printf("%s ha hecho %d puntos de daño a %s.%n",
                                personaje2.getNombre(), personaje2.getpDmg(), personaje1.getNombre());
                        saludP1 -= personaje2.getpDmg();
                        if (personaje2 instanceof Orden && saludP2 <= (int) (0.9 * personaje2.getSaludTotal())) {
                            int recuperacion = (int) (0.1 * personaje2.getSaludTotal());
                            saludP2 += recuperacion;
                            System.out.printf("%s recupera %d puntos de salud.%n", personaje2.getNombre(), recuperacion);
                        }
                    } else if (esquive && personaje1 instanceof Caos) {
                        ((Caos) personaje1).contraataque(tirarDados());
                        System.out.printf("%s contraataca.%n", personaje1.getNombre());
                    }
                }
            }
            System.out.println("");
        }
        System.out.println("Combate terminado.");
        if (saludP1 > 0) {
            xpGanada = personaje2.getpSalud();
            System.out.printf("%s es el vencedor y ha ganado %d puntos de experiencia.%n",
                    personaje1.getNombre(), xpGanada);
            personaje1.aumentarExp(xpGanada);
        } else if (saludP2 > 0) {
            xpGanada = personaje1.getpSalud();
            System.out.printf("%s es el vencedor y ha ganado %d puntos de experiencia.%n",
                    personaje2.getNombre(), xpGanada);
            personaje2.aumentarExp(xpGanada);
        }
    }

    // Método que hace un print de una lista numerada de los personajes creados.
    public static void printPJs() {
        for (int i = 0; i < posicionVacia(); i++) {
            System.out.printf("(%d) %s %n", i + 1, PERSONAJES[i].getNombre());
        }

    }

    // Método igual que el anterior pero que recibe una posición de personaje que no 
    // se ha de imprimir.
    public static void printPJs(int posExcepcion) {
        for (int i = 0; i < posicionVacia(); i++) {
            if (i != posExcepcion) {
                System.out.printf("(%d) %s %n", i + 1, PERSONAJES[i].getNombre());
            }
        }

    }

    // Método que devuelve cuál es la última posición vacía del Array de Personajes
    // OJOOOOO qué pasa cuando está LLENO??? revisar
    public static int posicionVacia() {
        boolean vacio = false;
        int posicion = 0;
        for (int i = 0; i < PERSONAJES.length && vacio == false; i++) {
            if (!(PERSONAJES[i] instanceof Personaje)) {
                posicion = i;
                vacio = true;
            }
        }
        return posicion;
    }

    // Método que simula el lanzamiento de 3 dados de 25 caras. Devuelve un INT 
    // con el resultado
    public static int tirarDados() {
        return ((int) (Math.random() * (25 - 1)) + 1) + ((int) (Math.random() * (25 - 1)) + 1)
                + ((int) (Math.random() * (25 - 1)) + 1);
    }

}
