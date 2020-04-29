package haxe.exercise.questions;

import byte.ByteData;
import haxe.exercise.Question;
import haxe.macro.Printer;
import haxe.macro.Expr;

class TypeQuestion implements Question {
	public static final COMPLEX_TYPE_PLACEHOLDER:ComplexType = TPath({pack: [], name: '_', params: [], sub: null});
	
	public final ANSWER:ComplexType;
	public static final LIST:Array<ComplexType> = [
		macro:Outcome<String, Error>,
		macro:String,
		macro:String->String,
		macro:Int,
		macro:Int->String,
		macro:Int->Outcome<Int, Error>,
		macro:Future<Int>,
		macro:Future<String>,
		macro:Future<Future<String>>,
		macro:Future<Outcome<String, Error>>,
	];
	
	public final index:Int;
	
	public function new() {
		index = Std.random(LIST.length);
		ANSWER = LIST[index];
	}
	
	public function title():String {
		return 'Type #${index+1}';
	}
	
	public function prompt():String {
		return 'In the following code snippet, what is the type of the variable `f` (as indicated by the placeholder symbol `_`)?';
	}
	
	public function code():String {
		var printer = new Printer();
		
		var types = [
			macro class Error {},
			enumify(macro class Outcome<A, B> {
				function Success(v:A);
				function Failure(v:B);
			}),
			macro class Future<A> {
				public function map<B>(f:A->B):Future<B>;
			},
		];
		
		var exprs = [
			{macro var future:Future<Int>;},
			{macro var f:$COMPLEX_TYPE_PLACEHOLDER;},
			{macro var result:Future<$ANSWER> = future.map(f);},
		];
		
		var buf = new StringBuf();
		
		for(type in types) {
			buf.add(printer.printTypeDefinition(type));
			buf.add('\n\n');
		}
		
		for(expr in exprs) {
			buf.add(printer.printExpr(expr));
			buf.add(';\n');
		}
		
		return buf.toString();
	}
	
	public function answer():Answer {
		return FreeText(v -> {
			var v = 'var x:$v';
			
			var expr = new haxeparser.HaxeParser(ByteData.ofString(v), 'Answer').expr();
			var printer = new Printer();
			
			try {
				switch expr.expr {
					case EVars([{type: v}]):
						printer.printComplexType(ANSWER) == printer.printComplexType(v);
					case _:
						false;
				}
			} catch(e:Dynamic) {
				false;
			}
		});
	}
	
	function enumify(def:TypeDefinition) {
		def.kind = TDEnum;
		return def;
	}
	
	function alias(def:TypeDefinition, to) {
		def.kind = TDAlias(to);
		return def;
	}
}