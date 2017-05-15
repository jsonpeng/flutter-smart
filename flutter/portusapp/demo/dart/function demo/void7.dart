void main(){
  var x;
  x=foo;
print(foo == x);


x=SomeClass.bar;
print(SomeClass.bar == x);

var v=new SomeClass();
var w=new SomeClass();
var y=w;
x=w.baz;
print(y.baz == x);
print(v.baz != w.baz);

}

foo(){}


class SomeClass{

  static void bar(){}
  void baz(){}
}
