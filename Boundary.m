  function [dstar,rtheta,HK] = Boundary(NACA,Rn,AoA)
  
  %Function will be used to find the boundary layer properties for all
  %reynolds numbers
NACA = NACA; %Type of Airfoil
Rey = num2str(Rn); %Reynolds Number
AoA = num2str(AoA);
%File Name
Bound_File = 'bound.csv';

% Create the airfoil
fid = fopen('xfoil_input.csv','w');
fprintf(fid,['NACA ' NACA '\n']);
fprintf(fid,'PPAR\n');
fprintf(fid,'\n\n');

% Find the Boundary layer data in XFoil
fprintf(fid,'OPER\n');
fprintf(fid,'Visc\n');
fprintf(fid,[Rey '\n']);
fprintf(fid,'Alfa\n');
fprintf(fid,[AoA '\n']);
fprintf(fid,'BL \n');
fprintf(fid,'Dump \n');
fprintf(fid, 'bound.csv \n\n');
% Close file
fclose(fid);
% Run XFoil using input file
cmd = 'xfoil.exe < xfoil_input.csv';
[~,~] = system(cmd);
Bound_File = 'bound.csv';
fidData = fopen(Bound_File);
[qww,qw,data] = xlsread('bound.csv');

fclose(fidData);
 delete(Bound_File);
 
%extracting data for the trailing edge only
data = data(2:end,:);
x = cell2mat(textscan(char(data),'%f'));
data = cell2mat(data);
data = str2num(data);
chord = data(66,1);
thick = data(66,2);
dstar = data(66,5);
rtheta = data(66,7);
HK = data(66,end);
[dstar,rtheta,HK];
  end

