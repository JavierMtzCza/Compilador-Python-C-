package demo.compiler;

public class Token {
    String lexema, token;
    int linea;

    
    public Token(String lexema, String token, int linea) {
        this.lexema = lexema;
        this.token = token;
        this.linea = linea;
    }

    public String getLexema() {
        return lexema;
    }

    public void setLexema(String lexema) {
        this.lexema = lexema;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public int getLinea() {
        return linea;
    }

    public void setLinea(int linea) {
        this.linea = linea;
    }

    @Override
    public String toString() {
        return "[   "+lexema+"  , token=" + token + ", linea=" + linea + "]";
    }

}
