package haxe.exercise;

import js.Browser.*;
import js.html.*;
using StringTools;

class Main {
	static function main() {
		var question:Question = new haxe.exercise.questions.TypeQuestion();
		
		var prompt = document.getElementById('question');
		var input:InputElement = cast document.getElementById('answer');
		var button = document.getElementById('submit');
		var result = document.getElementById('result');
		
		var divider = '-----------------------------------------------------';
		prompt.innerHTML = '<b>${question.title()}</b><br>Question: ${question.prompt()}<br><pre>$divider\n${question.code().htmlEscape()}\n$divider</pre>';
		
		button.onclick = () -> result.innerHTML = switch question.answer() {
			case FreeText(f):
				try {
					if(f(input.value))
						'<span class="correct">Correct!</span>';
					else
						'<span class="incorrect">Incorrect!</span>';
				} catch(e:Dynamic) {
					'<span class="incorrect">Error: $e</span>';
				}
			case _:
				throw 'TODO';
		}
	}
}