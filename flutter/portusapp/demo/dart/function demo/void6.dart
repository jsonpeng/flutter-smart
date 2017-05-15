void main(){
Function add2=makeAdder(2);

Function add4=makeAdder(4);

print(add2(3));
print(add4(3));

}


Function makeAdder(int addBy){
return (int i)=>addBy+i;
}


