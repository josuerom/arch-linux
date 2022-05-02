function! s:vscodeCommentary(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    en#     ██╗ █████╗ ██╗   ██╗ █████╗    ███████╗███╗   ██╗██╗██████╗ ██████╗ ███████╗████████╗███████╗
#     ██║██╔══██╗██║   ██║██╔══██╗   ██╔════╝████╗  ██║██║██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝
#     ██║███████║██║   ██║███████║   ███████╗██╔██╗ ██║██║██████╔╝██████╔╝█████╗     ██║   ███████╗
#██   ██║██╔══██║╚██╗ ██╔╝██╔══██║   ╚════██║██║╚██╗██║██║██╔═══╝ ██╔═══╝ ██╔══╝     ██║   ╚════██║
#╚█████╔╝██║  ██║ ╚████╔╝ ██║  ██║██╗███████║██║ ╚████║██║██║     ██║     ███████╗   ██║   ███████║
# ╚════╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝     ╚══════╝   ╚═╝   ╚══════╝

priority -50

global !p
def junit(snip):
	if snip.opt("g:ultisnips_java_junit", "") == "3":
		snip += ""
	else:
		snip.rv += "@Test\n\t"

def nl(snip):
	if snip.opt("g:ultisnips_java_brace_style", "") == "nl":
		snip += ""
	else:
		snip.rv += " "
def getArgs(group):
	import re
	word = re.compile('[a-zA-Z0-9><.]+ \w+')
	return [i.split(" ") for i in word.findall(group) ]

def camel(word):
	if not word: return ''
	return word[0].upper() + word[1:]

def mixedCase(word):
	if not word: return ''
	return word[0].lower() + word[1:]
endglobal

## Inicio de JAVA snippets
## salta errores
snippet sleep "try sleep catch" b
try {
	Thread.sleep(${1:1000});
} catch (InterruptedException e){
	e.printStackTrace();
}
endsnippet

## Estructuras para instancias
snippet newi "new primitive or int" b
${1:nameClass} ${2:object} = new ${3:nameClass}();$0
endsnippet

snippet newo "new Object or variable" b
${1:Object} ${2:var} = new ${1}($3);$0
endsnippet

## Palabras reservadas
snippet f "field" b
${1:private} ${2:String} ${3:`!p snip.rv = t[2].lower()`};
endsnippet

snippet ab "abstract" b
abstract $0
endsnippet

snippet sy "synchronized" b
synchronized $0
endsnippet

snippet br "break"
break;
endsnippet

snippet inst "instanceof" b
instanceof$0
endsnippet

snippet pc "package" b
package $0
endsnippet

snippet re "return" b
return -1$0;
endsnippet

snippet as "assert" b
assert ${1:test}${2/(.+)/(?1: \: ")/}${2:Failure message}${2/(.+)/(?1:")/};
endsnippet

snippet at "assert true" b
assertTrue(${1:actual});
endsnippet

snippet af "assert false" b
assertFalse(${1:actual});
endsnippet

snippet ae "assert equals" b
assertEquals(${1:expected}, ${2:actual});
endsnippet

snippet cs "case" b
case ${1:1}: $2
	break;
endsnippet

snippet ca "catch" b
catch (${1:Exception} ${2:e})`!p nl(snip)`{
	$0
}
endsnippet

snippet cle "class extends" b
public class `!p snip.rv = snip.basename` extends ${1:parentClass}{
	$0
}
endsnippet

snippet cli "class implements" b
public class `!p snip.rv = snip.basename` implements ${1:parentClass} }{
	$0
}
endsnippet

snippet clc "clase inteligente con constructor, setters y getters" b
public class `!p snip.rv = snip.basename` {
`!p args = getArgs(t[1])
if len(args) == 0: snip.rv = ""
for i in args:
	snip.rv += "\n\tprivate " + i[0] + " " + i[1]+ ";"
if len(args) > 0:
	snip.rv += "\n"`
	public `!p snip.rv = snip.basename or "unknown"`($1) {`!p
args = getArgs(t[1])
for i in args:
	snip.rv += "\n\t\tthis." + i[1] + " = " + i[1] + ";"
if len(args) == 0:
	snip.rv += "\n"`
	}$0
`!p
args = getArgs(t[1])
if len(args) == 0: snip.rv = ""
for i in args:
	snip.rv += "\n\tpublic void set" + camel(i[1]) + "(" + i[0] + " " + i[1] + ") {\n" + "\
	\tthis." + i[1] + " = " + i[1] + ";\n\t}\n"

	snip.rv += "\n\tpublic " + i[0] + " get" + camel(i[1]) + "() {\n\
	\treturn " + i[1] + ";\n\t}\n"
`
}
endsnippet

snippet clc "clase inteligente con constructor" b
public class `!p
snip.rv = snip.basename or "untitled"` {
`!p
args = getArgs(t[1])
for i in args:
	snip.rv += "\n\tprivate " + i[0] + " " + i[1]+ ";"
if len(args) > 0:
	snip.rv += "\n"`
	public `!p snip.rv = snip.basename or "unknown"`($1) {`!p
args = getArgs(t[1])
for i in args:
	snip.rv += "\n\t\tthis.%s = %s;" % (i[1], i[1])
if len(args) == 0:
	snip.rv += "\n"`
	}
}
endsnippet

## JavaMainClass
snippet javamainclass "Plantilla JavaMainClass" b
package ${1:interfaz};

${3://import java libraries}

/**
  *@author Josué Romero
  *@param `!v strftime("%e/%B/%Y - %R")` COL
*/
public class `!p snip.rv = snip.basename` {
	
	public static void main(String[] args) {
		${2:¡Empieza a Codear!}
		${4}
	}
}
endsnippet

## JavaClass
snippet javaclass "Plantilla JavaClass" b
package ${1:mundo};

public class `!p snip.rv = snip.basename` {
	/* Atributos */
	$2

	/* Constructor */
	public `!p snip.rv = snip.basename`($3) {
		this.$4 = $4;
	}

	/* Métodos */
	$5
}
endsnippet

snippet pcl "public class" b
public class `!p snip.rv = snip.basename` {
	$0
}
endsnippet

snippet cl "class" b
class `!p snip.rv = snip.basename` {
	$0
}
endsnippet

snippet cos "atributo constante de tipo String" b
public static final String ${1:var} = "$2";$0
endsnippet

snippet co "declarar variale constante" b
public static final ${1:String} ${2:var} = $3;$0
endsnippet

snippet de "default" b
default:
	${1:System.err.println("ERROR. Debe ingrese una opción válida.");}
endsnippet

## Estructuras de condicionales
snippet elif "else if"
else if ($1)`!p nl(snip)`{
	$0${VISUAL}
}
endsnippet

snippet el "else" w
else`!p nl(snip)`{
	$0${VISUAL}
}
endsnippet

snippet if "if" b
if ($1) {
	$2
}
endsnippet

## Estructuras de bucles
snippet fore "for (each)" b
for (${1:int} e : ${2:array})`!p nl(snip)`{
	$0
}
endsnippet

snippet fori "fori" b
for (int ${1:i} = 0; $1 < ${2:10}; $1++)`!p nl(snip)`{
	$0
}
endsnippet

snippet for "for" b
for (int i = 0; i < $1; i++)`!p nl(snip)`{
	$0
}
endsnippet

## Utilidades
snippet in "interface" b
interface `!p snip.rv = snip.basename` extends ${1:Parent} }{
	$0
}
endsnippet

snippet cc "constructor call or setter body"
this.${1:var} = $1;
endsnippet

snippet list "Collections List" b
List<${1:String}> ${2:list} = new ${3:Array}List<$1>();
endsnippet

snippet map "Collections Map" b
Map<${1:String}, ${2:String}> ${3:map} = new ${4:Hash}Map<$1, $2>();
endsnippet

snippet set "Collections Set" b
Set<${1:String}> ${2:set} = new ${3:Hash}Set<$1>();
endsnippet

snippet st "String" b
String $0
endsnippet

snippet cons "Constructor" b
public `!p snip.rv = snip.basename`(${1:var local}) {
	$0
}
endsnippet

snippet cn "constructor, \w fields + assigments" b
`!p args = getArgs(t[1])
for i in args:
	snip.rv += "\n\tprivate " + i[0] + " " + i[1]+ ";"
if len(args) > 0:
	snip.rv += "\n"`
public `!p snip.rv = snip.basename or "unknown"`($1) {`!p
args = getArgs(t[1])
for i in args:
	snip.rv += "\n\t\tthis.%s = %s;" % (i[1], i[1])
if len(args) == 0:
	snip.rv += "\n"`
}
endsnippet

## Libreria
snippet im "import" b
import $0;
endsnippet
snippet jb "java.beans." i
import java.beans.$0;
endsnippet
snippet ji "java.io" i
import java.io.$0;
endsnippet
snippet jm "java.math" i
import java.math.$0;
endsnippet
snippet jn "java.net." i
import java.net.$0;
endsnippet
snippet ju "java.util."  i
import java.util.$0;
endsnippet
snippet js "javax.swing."  i
import javax.swing.$0;
endsnippet
snippet jt "java.text.DecimalFormat"  i
import java.text.DecimalFormat;$0
endsnippet

snippet main "método principal" b
public static void main(String[] args)`!p nl(snip)`{
	${1:¡A Codear!}
}
endsnippet

snippet try "try/catch" b
try {
	$1${VISUAL}
} catch(${2:Exception} ${3:e}){
	${4:e.printStackTrace();}
}
endsnippet

snippet mt "method throws" b
${1:private} ${2:void} ${3:method}($4) ${5:throws $6 }{
	$0
}
endsnippet

snippet me  "estructura de métodos" b
${1:public} ${2:void} ${3:nameMethod}($4) {
	$0
}
endsnippet

snippet me "método con JavaDoc" b
/**
 * ${7:Short Description}`!p
for i in getArgs(t[4]):
	snip.rv += "\n\t * @param " + i[1] + " usage..."`
 *`!p
if "throws" in t[5]:
	snip.rv = "\n\t * @throws " + t[6]
else:
	snip.rv = ""``!p
if not "void" in t[2]:
	snip.rv = "\n\t * @return object"
else:
	snip.rv = ""`
 **/
${1:public} ${2:void} ${3:nameMethod}($4) {
	$0
}
endsnippet

## Getter
snippet get "getter" b
public ${1:String} get${2:Name}() {
	return `!p snip.rv = mixedCase(t[2])`;
}
endsnippet

snippet set "setter" b
public void set${1:Name}(${2:String} `!p snip.rv = mixedCase(t[1])`) {
	this.`!p snip.rv = mixedCase(t[1])` = `!p snip.rv = mixedCase(t[1])`;
}
endsnippet

snippet set-get "setter and getter" b
public void set${1:Name}(${2:String} `!p snip.rv = mixedCase(t[1])`) {
	this.`!p snip.rv = mixedCase(t[1])` = `!p snip.rv = mixedCase(t[1])`;
}`!p snip.rv += "\n"`
public $2 get$1() {
	return `!p snip.rv = mixedCase(t[1])`;
}
endsnippet

## Salidad de datos por consola
snippet s "System.out.print('')" b
System.out.print("$1");$0
endsnippet

snippet ss "System.out.println('')"  b
System.out.println($1);$0
endsnippet

snippet err "System.err.println('')"  b
System.err.println($1);$0
endsnippet

snippet spf "System.out.println('')"  b
System.out.printf($1);$0
endsnippet

## Modificadores de acceso
snippet pr "private" b
private $0
endsnippet

snippet po "protected" b
protected $0
endsnippet

snippet pu "public" b
public $0
endsnippet

snippet st "static"
static $0
endsnippet

# Estructuras Switch
snippet sw "switch" b
switch ($1)`!p nl(snip)`{
	case 1: $2
		break;
	case 2: $2
		break;
	case 3: $2
		break;
	default:
		System.err.println("ERROR. Debe ingresar una opción válida.");
}
endsnippet

snippet sy "synchronized"
synchronized$0
endsnippet

snippet tc "test case"
public class ${1:`!p snip.rv = snip.basename or "untitled"`} extends ${2:TestCase}`!p nl(snip)`{
	$0
}
endsnippet

snippet t "test" b
`!p junit(snip)`public void test${1:Name}() {
	$0
}
endsnippet

snippet tt "test throws" b
`!p junit(snip)`public void test${1:Name}() ${2:throws Exception }{
	$0
}
endsnippet

snippet th "throw" b
throw new $0
endsnippet

snippet wh "while" b
while ($1)`!p nl(snip)`{
	$0
}
endsnippet

## Otro snippets fundamentales
snippet ar "declarar un arreglo" b
${1:int} ${2:name}[] = new $1[${3:10}];$0
endsnippet

snippet arr "definir un arreglo"
${1:int} ${2:name}[] = new ${1:int}[] {$3};$0
endsnippet

snippet sc "Scanner sc = new Scanner(System.in)" b
Scanner sc = new Scanner(System.in);$0
endsnippet

snippet df "DecimalFormat df = new DecimalFormat(###,###.##)" b
DecimalFormat df = new DecimalFormat("###,###.##");$0
endsnippet

snippet joi "JOptionPane.showInputDialog()" b
JOptionPane.showInputDialog("$1")
endsnippet

snippet jom "JOptionPane.showMessageDialog()" b
JOptionPane.showMessageDialog(null, "$1");$0
endsnippet

snippet .n ".nextInt()" b
.nextInt();$0
endsnippet

snippet .n ".nextFloat()" b
.nextFloat();$0
endsnippet

snippet .n ".nextLine()" b
.nextLine();$0
endsnippet

snippet .n ".nextDouble()" b
.nextDouble();$0
endsnippet

snippet .n ".nextByte()" b
.nextByte();$0
endsnippet

snippet .n ".nextShort()" b
.nextShort();$0
endsnippet

snippet parseo "{Type}.parse{Type}()" b
${1:Integer}.parse${2:Int}($0);
endsnippet

snippet .get "getIntance()" b
getInstance();$0
endsnippet

snippet .get "getClass" b
getClass();
endsnippet

snippet .eq "equals(Object)" b
.equals();$0
endsnippet

snippet .toString "toString" b
public String toString() {
	return "$1";	
}
endsnippet

snippet pcla "public abstract class nameClass" b
public abstract class`!p snip.rv = snip.basename` extends ${1:parentClass} {
	
	public abstract void get${2:Name}();$0
}
endsnippet

snippet ritar "Print invers array" b
System.out.print("\nArreglo Inverso: [");
for (int $1 = ($2.length-1); $1 >= 0; $1--) {
	System.out.print($2[$1] + ", ");

	if ($1 > 0) {
		System.out.print($2[$1] + ", ");
	} else {
		System.out.print($2[$1] + "]");
	}
}
endsnippet

snippet itar "Print iterations of array" b
System.out.print("\nArreglo Original: [");
for (int $1 = 0; $1 < $2.length; $1++) {
	System.out.print($2[$1] + ", ");

	if ($1 > ($2.length - 1)) {
		System.out.print($2[$1] + ", ");
	} else {
		System.out.print($2[$1] + "]");
	}
}
endsnippet

snippet wl "Surround with ReadWriteLock.writeLock" b
$1.writeLock().lock();
try {
	$2
} finally {
	$1.writeLock().unlock();
}
endsnippet

snippet st "String" b
String $1 = " ";$0
endsnippetdif

    call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
endfunction

function! s:openWhichKeyInVisualMode()
    normal! gv
    let visualmode = visualmode()
    if visualmode == "V"
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
    endif
endfunction

" Better Navigation
nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

" Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
xnoremap <expr> <C-/> <SID>vscodeCommentary()
nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'

nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
xnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>

xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>
xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>
