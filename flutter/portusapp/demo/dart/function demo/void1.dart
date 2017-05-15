void main(){
    printNameA("XiaoMing");
    printNameB("XiaoMing");
    printNameC("XiaoMing");
}

// 规范语法
void printNameA(String name){
    print("My name is $name.");
}

// 通俗语法
printNameB(name){
    print("My name is $name.");
}

// 速写语法
void printNameC(String name) => print("My name is $name.");

