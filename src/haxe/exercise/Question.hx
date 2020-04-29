package haxe.exercise;

interface Question {
	function title():String;
	function prompt():String;
	function code():String;
	function answer():Answer;
}

enum Answer {
	FreeText(checker:String->Bool);
	MultipleChoices(answer:String, others:Array<String>);
	TrueOrFalse(v:Bool);
}