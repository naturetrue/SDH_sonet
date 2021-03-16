clearvars; clc;

Data=[51 52, 53; 54, 55, 56];
Overhead=[0; 0];
Payload=[Overhead, Data];


Frame=zeros(4,6);
Frame=replaceRowWise(Frame,1:6*4,1:6*4,1:6*4);

aux=Frame(2:4,3:6);
aux=replaceRowWise(aux,2:9,Payload,1:8);
Frame(2:4,3:6)=aux;
 

