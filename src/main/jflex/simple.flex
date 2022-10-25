package demo.compiler;
import java.util.Hashtable;
import java.lang.IllegalArgumentException;
import java.util.ArrayList;
import java.util.Stack;

%%

%line
%column
%public
%class AnalizadorLexico
%type TipoDeToken

%init{
    System.out.println("DEDENT");
%init}

%{
    private ArrayList<Token> listaDeToken = new ArrayList<Token>();
    private int contadorDeIdentacion = 0;
    private int nivelDeIdentado = 0;
    private boolean bloqueValido = false;
    private Stack<Integer> pilaDeIdentado = new Stack<Integer>();
%}

%{

    public String getReviewString() {
        String result = "";
        for (Token token : listaDeToken)
            result += token.toString() + "\n";
        return result;
    }

    private TipoDeToken nuevoToken(String lexema, TipoDeToken token) {
        try {
            listaDeToken.add(new Token(lexema, token.toString(), yyline));
            return token;
        } catch (IllegalArgumentException e) {
            System.out.println(e.getMessage());
            return TipoDeToken.INVALIDO;
        }
    }

    private TipoDeToken verificarIdentacion(String lexema, int linea) {

        if(lexema == "ESPACIO_ESPECIAL"){
            System.out.println(" IDENT");
        }else if(lexema == "ESPACIO_ESPECIAL_DOS"){
            System.out.println(" IDENT IDENT");
        }else{
            System.out.println("DEDENT");
        }

        /*for(char caracter : lexema.toCharArray()) {
            if (caracter == '\n') {
                //System.out.println("/n");
                contadorDeIdentacion = 0;
                nivelDeIdentado++;
                bloqueValido = true;
                pilaDeIdentado.push(contadorDeIdentacion + 4);
            } else if (caracter == ' ') {
                contadorDeIdentacion++;
                //System.out.println("esp-");
            } else {
                bloqueValido = false;
            }

            try {
                if (bloqueValido && nivelDeIdentado != 0) {
                    if (contadorDeIdentacion >= (pilaDeIdentado.lastElement())) {
                        listaDeToken.add(new Token("__", TipoDeToken.INDENT.toString(), linea));
                        pilaDeIdentado.push(contadorDeIdentacion + 3);
                        return TipoDeToken.INDENT;
                    }
                }
            } catch (IllegalArgumentException e) {
                return TipoDeToken.INVALIDO;
            }
        }*/

        return null;
    }
%}

/* -------- listaDeToken invalidos ------- */
CARACTER_INVALIDO   = "á"|"é"|"í"|"ó"|"ú"|"Á"|"É"|"Í"|"Ó"|"Ú"|"ñ"|"Ñ"|"¿"|"ä"|"ë"|"ï"|"ö"|"ü"|"à"|"è"|"ì"|"ò"|"ù"|\\

/* --------- Comentarios   ---------- */
COMENTARIO          =  {LINEA_COMENTARIO}|{BLOQUE_COMENTARIO}
LINEA_COMENTARIO    = \#[^\n\r]*
BLOQUE_COMENTARIO   = \"\"\"([^\"])* ~ \"\"\"

/* --------- Espaciado --------- */
ESPACIO                 = " "
SALTO_LINEA             = \n|\r|\r\n
ESPACIO_ESPECIAL        = \n\s\s\s\s
ESPACIO_ESPECIAL_DOS    = \n\s\s\s\s\s\s\s\s
SALTO_NORMAL            = \n{LETRA}

/* -------- Identificador ---------- */
LETRA                   = [a-zA-Z]
IDENTIFICADOR           = ({LETRA}|"_")({LETRA}|{INT}|"_")*
IDENTIFICADOR_INVALIDO  = {IDENTIFICADOR}*{CARACTER_INVALIDO}+({IDENTIFICADOR}|{CARACTER_INVALIDO})*

/* -------- Operaciones  -----------*/
OPERADOR_ARITMETICO       = "+"|"-"|"*"|"/"|"%"|"**"|"//"
COMPARADOR_OPERACIONAL    = "=="|"!="|"<>"|">"|"<"|">="|"<="
ASIGNACION_OPERACIONAL    = "="|"+="|"-="|"*="|"/="|"//="|"%="|"**="
OPERACIONAL_BIT           = "&"|"|"|"^"|"~"|"<<"|">>"
OPERADOR_LOGICO           = "AND"|"OR"|"NOT"|"and"|"or"|"not"
OPERACIONAL_MIEMBRO       = "in"|"not in"
OPERACIONAL_IDENTIDAD     = "is"|"is not"|"isn't"
OPERACIONAL_DELIMITAR     = "@"|">>="|"<<="|"&="|"|="

OPERACION               = {OPERADOR_ARITMETICO}|{COMPARADOR_OPERACIONAL}|{ASIGNACION_OPERACIONAL}|{OPERACIONAL_BIT}|{OPERADOR_LOGICO}|{OPERACIONAL_MIEMBRO}|
                        {OPERACIONAL_IDENTIDAD}|{OPERACIONAL_DELIMITAR}

/* -------- Puntuado  -----------*/
DOS_PUNTOS                = ":"
COMA                      = ","
PUNTO                     = "."
PUNTO_COMA                = ";"

PUNTUADO                  ={PUNTO}|{PUNTO_COMA}

/* -------- Delimitadores  -----------*/
PARENTESIS_ABRE           = "("
PARENTESIS_CIERRA         = ")"
CORCHETE_ABRE             = "["
CORCHETE_CIERRA           = "]"
LLAVE_ABRE                = "{"
LLAVE_CIERRA              = "}"

DELIMITADOR           = {CORCHETE_ABRE}|{CORCHETE_CIERRA}|{LLAVE_ABRE}|{LLAVE_CIERRA}

/* -------- Palabras Reservadas y funciones -----------*/
RESERVADA = "and"|"del"|"from"|"not"|"while"|"as"|"elif"|"global"|"or"|"with"|"assert"|"else"|"if"|"pass"|"yield"|"break"|"except"|"import"|"print"|"class"|"exec"|"in"|"raise"|"continue"|"finally"|"is"|"return"|"def"|"for"|"lambda"|"try"|"end"|"input"

/* -------- Literales  -----------*/
ENTERO_LONG                 = {INT}("l"|"L")
INT                         = {NUMERO_DECIMAL}|{ENTERO_OCT}|{ENTERO_HEX}|{ENTERO_BIN}
NUMERO_DECIMAL              = {DIGITO_SIN_CERO}{DIGITO}*|"0"
ENTERO_OCT                  = "0"("o" | "O"){DIGITO_OCT}+ |  "0"{DIGITO_OCT}+
ENTERO_HEX                  = "0"("x" | "X"){DIGITO_HEX}+
ENTERO_BIN                  = "0"("b" | "B") {DIGITO_BIN}+
DIGITO                      = [0-9]
DIGITO_SIN_CERO             = [1-9]
DIGITO_BIN                  = "0"|"1"
DIGITO_OCT                  = [0-7]
DIGITO_HEX                  = {DIGITO}|[a-f]|[A-F]

NUMERO_FLOTANTE             = {PUNTO_FLOTANTE}|{EXPONENCIAL_FLOTANTE}
PUNTO_FLOTANTE              = {PARTE_ENTERA}?{PARTE_FRACCIONARIA}|{PARTE_ENTERA}"."
EXPONENCIAL_FLOTANTE        = ({PARTE_ENTERA}|{PUNTO_FLOTANTE}){EXP}
PARTE_ENTERA                = {DIGITO}+
PARTE_FRACCIONARIA          = "."{DIGITO}+
EXP                         = ("e" | "E")("+" | "-") {DIGITO}+
NUMERO_IMAGINARIO           = ({NUMERO_FLOTANTE}|{PARTE_ENTERA})("j" | "J")

NUMERO_LITERAL              = {ENTERO_LONG}|{INT}|{NUMERO_FLOTANTE}|{NUMERO_IMAGINARIO}

PREFIJO_CADENA              = "r" | "u" | "ur" | "R" | "U" | "UR" | "Ur" | "uR"| "b" | "B" | "br" | "Br" | "bR" | "BR"
CADENA_LITERAL              = \"[^\n\r\"]*\"
CADENA_INVALIDA_LITERAL     = \"+{CADENA_LITERAL} | {CADENA_LITERAL}\"+ | \"[^\n\r\"]*\
CARACTER_LITERAL            = \'[^\']\'
CARACTER_INVALIDO_LITERAL   = \'[^\']+\' | \'+\'[^\']+\' | \'[^\']+\'\'+
BOOLEAN_LITERAL             = "True"|"False"

LITERAL                     = {NUMERO_LITERAL}|{PREFIJO_CADENA}?({CADENA_LITERAL}|{CARACTER_LITERAL})|{BOOLEAN_LITERAL}
LITERAL_INVALIDO            = {CADENA_INVALIDA_LITERAL} | {CARACTER_INVALIDO_LITERAL} |{NUMERO_LITERAL}({LETRA} | {CARACTER_INVALIDO} | "_"| (({LETRA}|{CARACTER_INVALIDO}|"_"){NUMERO_LITERAL}))+

%%

<YYINITIAL> {

    /*CASOS A IGNORAR*/
    {COMENTARIO}                {                  /*         IGNORE        */                  }
    {ESPACIO}                   {                  /*         IGNORE        */                  }
    {SALTO_LINEA}               {                  /*         IGNORE        */                  }

    /*ESPACIADO E IDENTADO*/
    {SALTO_NORMAL}              { verificarIdentacion("SALTO_NORMAL", yyline);                  }
    {ESPACIO_ESPECIAL}          { verificarIdentacion("ESPACIO_ESPECIAL", yyline);              }
    {ESPACIO_ESPECIAL_DOS}      { verificarIdentacion("ESPACIO_ESPECIAL_DOS", yyline);          }

    /*DELIMITADORES*/
    {PARENTESIS_ABRE}           { return nuevoToken(yytext(), TipoDeToken.PARENTESIS_ABRE);     }
    {PARENTESIS_CIERRA}         { return nuevoToken(yytext(), TipoDeToken.PARENTESIS_CIERRA);   }
    {DELIMITADOR}               { return nuevoToken(yytext(), TipoDeToken.DELIMITADOR);         }

    /*PUNTUADO*/
    {DOS_PUNTOS}                { return nuevoToken(yytext(), TipoDeToken.DOS_PUNTOS);          }
    {COMA}                      { return nuevoToken(yytext(), TipoDeToken.COMA);                }
    {PUNTUADO}                  { return nuevoToken(yytext(), TipoDeToken.PUNTUADO);            }

    
    {OPERACION}                 { return nuevoToken(yytext(), TipoDeToken.OPERACION);           }
    {RESERVADA}                 { return nuevoToken(yytext(), TipoDeToken.RESERVADA);           }
    {LITERAL}                   { return nuevoToken(yytext(), TipoDeToken.LITERAL);             }

    /*ERRORES*/
    {CARACTER_INVALIDO}         { return nuevoToken(yytext(), TipoDeToken.CARACTER_INVALIDO);   }
    {LITERAL_INVALIDO}          { return nuevoToken(yytext(), TipoDeToken.ERROR_LITERAL);       }
    {IDENTIFICADOR_INVALIDO}    { return nuevoToken(yytext(), TipoDeToken.ERROR_IDENTIFICADOR); }

    {IDENTIFICADOR}             { return nuevoToken(yytext(), TipoDeToken.IDENTIFICADOR);       }
}

[^]                             { return nuevoToken("", TipoDeToken.BAD_ERROR);                  }
