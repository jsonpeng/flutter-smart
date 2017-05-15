import 'dart:convert';

void main(){
var jsonData ='[{NodeId: 1, BasicDeviceClass: 2, GenericDeviceClass: 2, SpecificDeviceClass: 7, CommandClass: 00000000}, {NodeId: 4, BasicDeviceClass: 4, GenericDeviceClass: 16, SpecificDeviceClass: 1, CommandClass: 00000000}, {NodeId: 17, BasicDeviceClass: 4, GenericDeviceClass: 33, SpecificDeviceClass: 1, CommandClass: 00000000}, {NodeId: 20, BasicDeviceClass: 4, GenericDeviceClass: 16, SpecificDeviceClass: 1, CommandClass: 00000000}, {NodeId: 21, BasicDeviceClass: 4, GenericDeviceClass: 16, SpecificDeviceClass: 1, CommandClass: 00000000}]';
var aa=JSON.decode(jsonData);
print(aa);

}
