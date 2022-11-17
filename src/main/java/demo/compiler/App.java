package demo.compiler;

import picocli.CommandLine;

import java.io.BufferedReader;
import java.io.File;
import java.nio.file.Files;
import java.util.concurrent.Callable;
@CommandLine.Command(name = "lexer", mixinStandardHelpOptions = true, version = "0.0.1", description = "Correr el analizador lexico")
public class App implements Callable<Integer>{

    @CommandLine.Option(names = {"-f","--file"}, description = "Archivo a leer", required = true)
    private File file;

    public static void main( String[] args ){
        int exitCode =  new CommandLine(new App()).execute(args);
        System.exit(exitCode);
    }

    // Para ejecutar el codigo se utiliza -mvn -
    @Override
    public Integer call() throws Exception {
        if(file != null){
            BufferedReader buffer = Files.newBufferedReader(file.toPath());
            AnalizadorLexico analizadorLexico =  new AnalizadorLexico(buffer);
            TipoDeToken token;
            while((token=analizadorLexico.yylex()) != null){}
            System.out.println(analizadorLexico.getReviewString());
        }
        return 0;
    }
}
