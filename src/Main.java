import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        // Comprobar si se ha pasado un argumento
        if (args.length == 0) {
            System.err.println("Uso: java -jar traductorPascalC.jar <archivo_pascal.pas>");
            return;
        }

        String filePath = args[0];
        runFile(filePath);
    }

    public static void runFile(String filePath) throws IOException {
        CharStream input = CharStreams.fromFileName(filePath);

        // Generar nombre de archivo .c
        String outputPath = filePath.endsWith(".pas")
                ? filePath.substring(0, filePath.length() - 4) + ".c"
                : filePath + ".c";

        // Redirigir salida estándar a archivo .c
        try (FileOutputStream outFile = new FileOutputStream(outputPath);
             PrintStream printStream = new PrintStream(outFile)) {

            PrintStream originalOut = System.out;
            System.setOut(printStream);

            gramaticaLexer lexer = new gramaticaLexer(input);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            gramaticaParser parser = new gramaticaParser(tokens);

            parser.prg();

            System.setOut(originalOut); // restaurar salida

            if (parser.getNumberOfSyntaxErrors() > 0) {
                System.err.println("Errores en: " + filePath);
            }

        } catch (Exception e) {
            System.err.println("Error al procesar: " + filePath);
            e.printStackTrace();
        }
    }
}
