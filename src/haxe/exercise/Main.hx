package haxe.exercise;

import js.Browser.*;
import js.html.*;
using StringTools;

class Main {
	static function main() {
		var set = new haxe.exercise.set.Set();
		
		var question = document.getElementById('question');
		var input:InputElement = cast document.getElementById('answer');
		var button = document.getElementById('submit');
		var result = document.getElementById('result');
		
		var divider = '-----------------------------------------------------';
		question.innerHTML = '<b>${set.title()}</b><br>Question: ${set.prompt()}<br><pre>$divider\n${set.code().htmlEscape()}\n$divider</pre>';
		
		button.onclick = () -> result.innerHTML = try {
			if(set.answer(input.value))
				'<span class="correct">Correct!</span>';
			else
				'<span class="incorrect">Incorrect!</span>';
		} catch(e:Dynamic) {
			'<span class="incorrect">Error: $e</span>';
		}
	}
}