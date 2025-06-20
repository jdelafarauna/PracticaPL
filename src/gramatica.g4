grammar gramatica;

@members {
    java.util.List<String> mainLocalVars = new java.util.ArrayList<>();
    java.util.List<String> globalConstDefs = new java.util.ArrayList<>();


    String currentFunction = null;
    int indentLevel = 0;
    java.util.Map<String, String> symbolTable = new java.util.HashMap<>();
    boolean isGlobalContext = true;

    void println(String line) {
        for (int i = 0; i < indentLevel; i++) System.out.print("    ");
        System.out.println(line);
    }

    void print(String line) {
        for (int i = 0; i < indentLevel; i++) System.out.print("    ");
        System.out.print(line);
    }
    String toCRelOp(String op) {
        if (op.equals("="))  return "==";
        if (op.equals("<>")) return "!=";
        return op;
    }
    String toCArithOp(String op) {
        if (op.equals("div")) return "/";
        if (op.equals("mod")) return "%";
        return op;
    }



}


/* ───────────────────  PROGRAMA PRINCIPAL ─────────────────── */
prg
: 'program' ID ';'
  {
    System.out.println("#include <stdio.h>\n");
    isGlobalContext = true;
  }
  dcllist
  {
    // Ahora ya se han recopilado todas las constantes
    for (String def : globalConstDefs) {
        System.out.println(def);
    }

    println("");
    println("void main(void) {");
    indentLevel++;
    for (String decl : mainLocalVars) {
        println(decl);
    }
    isGlobalContext = false;
  }
  'begin' sentlist 'end' '.'
  {
    println("return 0;");
    indentLevel--;
    println("}");
  }
;


vardcls: (defcte | defvar)* ;
procdcls: (defproc | deffun)* ;

/* ───────────────────  DECLARACIONES ─────────────────── */
dcllist      : dcl dcllistPrima | ;
dcllistPrima : dcl dcllistPrima | ;
dcl : defcte | defvar | defproc | deffun ;

/* constantes */
defcte : 'const' ctelist { println(""); };

ctelist
    : ID '=' simpvalue ';' {
        String val = $simpvalue.text;
        if (val.startsWith("'") && val.endsWith("'")) {
            val = "\"" + val.substring(1, val.length() - 1) + "\"";
        }
        String id = $ID.text;

        if (isGlobalContext) {
            globalConstDefs.add("#define " + id + " " + val);
        } else {
            if (val.startsWith("'")) {
                println("const char* " + id + " = " + val.replace('\'', '\"') + ";");
            } else if (val.contains(".") || val.toLowerCase().contains("e")) {
                println("const float " + id + " = " + val + ";");
            } else {
                println("const int " + id + " = " + val + ";");
            }
        }
    } ctelistPrima
;

ctelistPrima
    : ID '=' simpvalue ';' {
        String val = $simpvalue.text;
        if (val.startsWith("'") && val.endsWith("'")) {
            val = "\"" + val.substring(1, val.length() - 1) + "\"";
        }
        String id = $ID.text;

        if (isGlobalContext) {
            globalConstDefs.add("#define " + id + " " + val);
        } else {
            if (val.startsWith("'")) {
                println("const char* " + id + " = " + val.replace('\'', '\"') + ";");
            } else if (val.contains(".") || val.toLowerCase().contains("e")) {
                println("const float " + id + " = " + val + ";");
            } else {
                println("const int " + id + " = " + val + ";");
            }
        }
    } ctelistPrima
    | // vacío
    ;

/* variables y tipos básicos */
simpvalue : CONSTINT | CONSTREAL | CONSTLIT ;

defvar : 'var' defvarlist ';' ;

defvarlist
    : varlist ':' tbas {
        String[] vars = $varlist.text.split(",");
        for (String var : vars) symbolTable.put(var.trim(), $tbas.val);

        if (isGlobalContext) {
            mainLocalVars.add($tbas.val + " " + $varlist.text + ";");
        } else {
            println($tbas.val + " " + $varlist.text + ";");
        }
      } defvarlistPrima
    ;

defvarlistPrima
    : ';' varlist ':' tbas {
        String[] vars = $varlist.text.split(",");
        for (String var : vars) symbolTable.put(var.trim(), $tbas.val);

        if (isGlobalContext) {
            mainLocalVars.add($tbas.val + " " + $varlist.text + ";");
        } else {
            println($tbas.val + " " + $varlist.text + ";");
        }
      } defvarlistPrima
    | /* vacío */ ;

varlist      : ID varlistPrima ;
varlistPrima : ',' ID varlistPrima | ;

/* procedimientos y funciones */
defproc
returns [String fname]
    : 'procedure' ID { $fname = $ID.text; isGlobalContext = false; }
      fp=formal_paramlist
      ';'
      { print("void " + $fname); print("(" + $fp.text + ") {"); System.out.println(); indentLevel++; }
      blq
      ';'
      { indentLevel--; println("}"); isGlobalContext = true; }
;

deffun
    : 'function' ID fname=formal_paramlist ':' rtype=tbas ';'
      {
        currentFunction = $ID.text;
        isGlobalContext = false;
        print($rtype.val + " " + currentFunction + "(" + $fname.text + ") {");
        System.out.println();
        indentLevel++;
        symbolTable.put(currentFunction, $rtype.val);
      }
      blq
      ';'
      {
        indentLevel--;
        println("}");
        currentFunction = null;
        isGlobalContext = true;
      }
;

/* lista de parámetros formales */
formal_paramlist returns [String text = ""]
    : '(' params+=formal_param (';' params+=formal_param)* ')' {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < $params.size(); i++) {
            if (i > 0) builder.append(", ");
            builder.append($params.get(i).text);
        }
        $text = builder.toString();
      }
    | { $text = ""; }
    ;

formal_param returns [String text]
    : vl=varlist ':' tb=tbas {
        String[] vars = $vl.text.split(",");
        for (String var : vars) symbolTable.put(var.trim(), $tb.val);
        $text = $tb.val + " " + $vl.text;
      }
    ;

/* tipos básicos pascal → C */
tbas returns [String val]
    : 'INTEGER' { $val = "int"; }
    | 'REAL'    { $val = "float"; }
    ;

/* bloque */
blq : dcllist 'begin' sentlist 'end' blqfin ;

blqfin : ';' | ;

/* ───────────────────  SENTENCIAS ─────────────────── */
sentlist      : sent sentlistPrima ;
sentlistPrima : sent sentlistPrima | ;

/* condición lógica sencilla */
expcond returns [String text]
    : a=expcond 'or' b=expcond { $text = $a.text + " || " + $b.text; }
    | a=expcond 'and' b=expcond { $text = $a.text + " && " + $b.text; }
    | 'not' fc=factorcond {
          String inner = $fc.text;
          if (inner.startsWith("(") && inner.endsWith(")")) {
              $text = "!" + inner;  // No añadir más paréntesis
          } else {
              $text = "!(" + inner + ")";
          }
      }
    | fc=factorcond             { $text = $fc.text; }
    ;

factorcond returns [String text]
    : a=exp rop=oprel b=exp { $text = $a.text + " " + toCRelOp($rop.text) + " " + $b.text; }
    | '(' ec=expcond ')'     { $text = "(" + $ec.text + ")"; }
    ;

ifstmt
    : 'if' c=expcond 'then'
        {
            print("if (" + $c.text + ") {"); System.out.println(); indentLevel++;
        }
        s1=blq
        {
            indentLevel--; println("}");
        }
        elsepart
    ;

elsepart
    : 'else'
        {
            println("else {"); indentLevel++;
        }
        s2=blq
        {
            indentLevel--; println("}");
        }
    | // vacío (no hay else)
    ;


whilestmt
    : 'while' c=expcond 'do'
        { print("while (" + $c.text + ") {"); System.out.println(); indentLevel++; }
        b=blq
        { indentLevel--; println("}"); }
    ;
repeatstmt
    : 'repeat'
        {
            println("do {");
            indentLevel++;
        }
      sentlist
      'until' cond=expcond ';'
        {
            indentLevel--;
            println("} while (!(" + $cond.text + "));");
        }
    ;


forstmt
    : 'for' id=ID ':=' inicio=exp direccion=inc fin=exp 'do'
      {
        String var = $id.text;
        String from = $inicio.text;
        String to = $fin.text;

        boolean ascendente = $direccion.text.equals("to");
        String condicion = ascendente ? var + " <= " + to : var + " >= " + to;
        String incremento = ascendente ? var + "++" : var + "--";

        println("for (" + var + " = " + from + "; " + condicion + "; " + incremento + ") {");
        indentLevel++;
      }
      blq
      {
        indentLevel--;
        println("}");
      }
    ;

inc : 'to' | 'downto' ;



/* todas las sentencias posibles */
sent
    : ifstmt
    | whilestmt
    | repeatstmt
    | forstmt
    | asig ';'
    | proc_call ';'
    | 'begin' sentlist 'end'
    ;




/* asignación (o “return” implícito) */
asig
    : ID ':=' e=exp {
        if ($ID.text.equals(currentFunction)) {
            println("return " + $e.text + ";");
        } else {
            println($ID.text + " = " + $e.text + ";");
        }
    }
;


/* expresiones aritméticas */
exp returns [String text]
    : f=factor {
        $text = $f.text;
    } r=expPrimaAux[$text] {
        $text = $r.text;
    }
    ;

expPrimaAux[String acc] returns [String text]
    : o=op f=factor r=expPrimaAux["(" + acc + " " + toCArithOp($o.text) + " " + $f.text + ")"] {
        $text = $r.text;
    }
    | { $text = acc; }
    ;


op returns [String text]
    : t=('+' | '-' | '*' | DIV | MOD) { $text = $t.getText(); }
    ;


oparit : '+' | '-' | '*' | DIV | MOD ;



/* factor */
factor returns [String text]
    : s=simpvalue         { $text = $s.text; }
    | '(' e=exp ')'       { $text = "(" + $e.text + ")"; }
    | id=ID sp=subparamlist {
          $text = $id.text;
          if (!$sp.text.isEmpty()) {
              $text += "(" + $sp.text + ")";
          }
      }
    ;


/* parámetros reales (llamadas) */
subparamlist returns [String text = ""]
    : '(' ')'                 { $text = ""; }
    | '(' explist ')'         { $text = $explist.text; }
    |                         { $text = ""; }
    ;

explist returns [String text = ""]
    : a=exp { $text = $a.text; } explistPrima[$text]
    ;
explistPrima[String prev] returns [String text]
    : ',' b=exp r=explistPrima[$prev + ", " + $b.text] { $text = $r.text; }
    | { $text = $prev; }
    ;

/* llamada a procedimiento */
proc_call
    : ID s=subparamlist {
        if ($s.text.isEmpty()) {
            println($ID.text + "();");
        } else {
            println($ID.text + "(" + $s.text + ");");
        }
    }
    ;






exprList returns [java.util.List<String> values = new java.util.ArrayList<>()]
    : a=exp { $values.add($a.text); } (',' b=exp { $values.add($b.text); })*
    ;

/* operadores relacionales */
oprel : '=' | '<>' | '<' | '<=' | '>' | '>=' ;

/* ───────────────────  LÉXICO ─────────────────── */
DIV : 'div' ;
MOD : 'mod' ;
ID        : [a-zA-Z] [a-zA-Z0-9_]* ;
CONSTINT  : ('+' | '-')? [0-9]+ ;
CONSTREAL : (('+' | '-')? [0-9]+ '.' [0-9]+
            | ('+' | '-')? [0-9]+ ('e' | 'E') ('+' | '-')? [0-9]+
            | ('+' | '-')? [0-9]+ '.' [0-9]+ ('e' | 'E') ('+' | '-')? [0-9]+) ;
CONSTLIT  : '\'' (~('\'' | '\\') | '\\\'')* '\'' ;

COMENTARIO_LINEA      : '{' ~[\r\n]* '}' -> skip ;
COMENTARIO_MULTILINEA : '(*' .*? '*)'    -> skip ;
WS                    : [ \t\r\n]+       -> skip ;


