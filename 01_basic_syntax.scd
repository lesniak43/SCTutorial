
// VARIABLES

// variables hold things - that's it
// check out the currently empty variable 'a'

a; // run, watch the Post window

// variable 'a' currently holds 'nil', which here means "nothing"

a = 43; // run, clear post window, run the above command again

// now 'a' holds 43

// if you want a longer name of your variable, the name must start with '~'
a = 43; // ok
~abc = 44; // ok
abc = 45; // error!

a = ~abc; // what happens here? check the contents of 'a' and '~abc'


// VARIABLE 's'

// by default, variable 's' holds the local server
s; // should print "localhost"

// EXERCISE 1
// experiment with the following commands:
s.boot;
s.reboot;
s.scope;
s.freqscope;
s.plotTree;

// you can overwrite 's' with anything you want
s = "Hello world!";
// but now you cannot run the commands from Exercise 1! (check it out for yourself)
// to reset, run:
s = Server.local;


// SEMICOLON, POSTLN, DOT

// you can run multiple commands in a single line, as long as you separate them with ';'
a = 1; b = "Dog"; c = true;
// note that only the last part gets posted - to check out the content of the variables, use '.postln'
b.postln; a.postln;
c.postln;
// SuperCollider always prints only the last thing that happened during a code execution, and those messages are prepended with '->'
// on the other hand, every message that you explicitly requested with '.postln' will be printed, each in a separate line

// 'postln' is a METHOD, and to apply the method to the content of the variable we write: VARIABLE.METHOD(ARGUMENTS)
// here no arguments were necessary, so the whole '(ARGUMENTS)' part could be skipped


// NUMBER, STRING, SYMBOL, ARRAY
n = 1;           // an integer
n = -1;          // negative number
n = 2 + 2 * 2;   // note that SuperCollider is bad at math and multiplies only after adding 2+2
n = 2 + (2 * 2); // better
v = 1.43;        // a float
v = "Cat";       // a string, a sequence of characters
v = 'Cat';       // a symbol, NOT a sequence of characters, but a unique entity identified by its name
v = \Cat;        // same as v = 'Cat';
w = [1, 2+2*2, 1.43, "Cat", 'Cat', \Cat];
                 // an Array of 6 elements
w[1].postln;     // print the "first" element (count from zero!)
w[1] = n;        // replace the first element, it should be equal to 6 now (if you run 'n = 2 + (2 * 2);')
w.postln;        // check the content
w[3].postln; w[4].postln; w[5].postln;
                 // which cats are identical?
w[3] == w[4];    // this posts 'false' - w[3] is a string and w[4] is a symbol
w[3] == "Cat";   // this is 'true', both are strings
w[3] === "Cat";  // this is 'false', the strings are equal (==) but are NOT identical (===)
w[4] == w[5];    // 'true', symbols have the same name
w[4] === w[5];   // also 'true', because symbols are unique, thus symbols with the same name must be identical


// FUNCTION
// a function is a reusable part of code...
{ a = 5; a = a + 2; a.postln; a = a * 2; a.postln; 43; };
// ...but to actually execute the code we need the method 'value'
{ a = 5; a = a + 2; a.postln; a = a * 2; a.postln; 43; }.value;
// note that the function body is enclosed with braces, and there are six semicolons inside, one per command
// the final semicolon after '}' ends the command that CREATES the function

// the multiline notation is usually more clear
(
{
	a = 5;
	a = a + 2;
	a.postln;
	a = a * 2;
	a.postln;
	43;
}.value;
)

// to actually use the function more than once we will store it in a variable
f = { a = 5; a = a + 2; a.postln; a = a * 2; a.postln; 43; };
// note the lack of '.value' - we want to store the function, not the result of evaluation!

f; // a Function
g = f.value; // evaluate 'f', store the result in 'g'
// so what is the result of function evaluation?
g.postln;
// it turns out that it is always the result of the last command

// EXERCISE 2
// write a function that returns the symbol \Cat, store the function in variable 'f'
f = YOUR_CODE_GOES_HERE...
// check out the result
f.value === \Cat; // should be 'true'


// FUNCTION - ARGUMENTS, LOCAL VARIABLES
// functions can accept arguments
(
f = { arg a, second, wolf=5;
	var sum;
	sum = a + second;
	wolf * sum;
};
)
f.value(5, 10, 2); // (5 + 10) * 2
// the first line must start with the keyword 'arg', followed by names of the arguments
// argument 'wolf' will have a default value of 5
// 'var sum;' - this line creates a local variable 'sum' by using a keyword 'var'
// local variables exist only inside the function...
sum; // error!
// ...and can have longer names
// the function basically calculates (a + second) * wolf, and the variable 'sum' holds the partial result
f.value(1, 2); // (1 + 2) * 5, you don't have to pass the third argument, as it has a default value
f.value(1); // error! 'second' is nil, and SuperCollider cannot add 1+nil (see the Post window for yourself!)
f.value(wolf: 5, a: 1, second: 2); // you can use arguments' names to pass the values in any order
f.value(second: 2, a: 1);
// 'value' is so common that there is a syntax shortcut that allows you to skip it (but keep the dot!)
f.(2,3);

// an alternative syntax
(
f = { |a, second, wolf=5| // note the lack of keyword 'arg' and the trailing semicolon
	var sum = a + second; // you can declare the variable 'sum' and assign a value to it using a single command
	wolf * sum;
};
)


// CLASSES, OBJECTS
// everything you need to know (for now):
//   Classes are used to create Objects (instances)
//   Classes and Objects are more "powerful" than functions, they can have more methods, and hold their own variables
a = SinOsc;
a.postln; // SinOsc - a Class
b = a.new(); // create a new instance (Object) of Class stored inside 'a', put the result inside 'b'
b.postln; // a SinOsc - note the article "a", 'b' holds an Object, which is an instance of SinOsc
b.isUGen() // the object can respond to many different methods