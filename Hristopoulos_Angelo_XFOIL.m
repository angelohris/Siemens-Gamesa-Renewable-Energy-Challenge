%Coding Challenge for Internship Position at 
% Siemens Gamesa Renewable Energy
%created By Angelo Hristopoulos on June 04 2020
%Code used for aerodyanamic analysis for NACA 64-618 airfoil

%% Create Xfoil files
clear;
clc;
close all;
% Must delete all
%COnstants 
NACA = '6618'; %Type of Airfoil
AoA = '-10'; %First angle of attack
AoA2 = '20'; %Last angle of attack
AoA3 = '1'; %STEP Size between angles of attack

Rey = '3000000'; %Reynolds Number

%Angles of CP data
CP_Alpha1  = '0';
CP_Alpha2  = '4';
CP_Alpha3  = '8';
CP_Alpha4  = '12';

%Number of nodes
numNodes = '100';

%File Names
Airfoil_File = 'Air.csv';
Data_File = 'Data.csv';
CP_File = 'CP.csv';


% Create the airfoil
fid = fopen('xfoil_input.csv','w');
fprintf(fid,['NACA ' NACA '\n']);
fprintf(fid,'PPAR\n');
fprintf(fid,['N ' numNodes '\n']);
fprintf(fid,'\n\n');

% Save the airfoil data points
fprintf(fid,['PSAV ' Airfoil_File '\n']);

% Find the POLAR by creating script for XFOIL
fprintf(fid,'OPER\n');
fprintf(fid,'Visc\n');
fprintf(fid,[Rey '\n']);
% fprintf(fid,'M\n');
% fprintf(fid,'.1\n');
fprintf(fid,'Pacc\n');
fprintf(fid, [Data_File '\n\n']);
fprintf(fid,['ASEQ' AoA '\n']);
fprintf(fid,[AoA2 '\n']);
fprintf(fid,[AoA3 '\n']);

% Find CP by creating script for XFOIL
fprintf(fid,['Alfa ' CP_Alpha1 '\n']);  %Change for the wanted Angle 
fprintf(fid,['CPWR ' CP_File]);

% Close file
fclose(fid);
% Run XFoil using input file
cmd = 'xfoil.exe < xfoil_input.csv';
[status,result] = system(cmd);
%% READ DATA FILE: AIRFOIL
 %Load in and extract the data for CL,CD,CP,CDP
Airfoil_File = 'Air.csv';
fidAirfoil = fopen(Airfoil_File);  
CP_Data = textscan(fidAirfoil,'%f %f','CollectOutput',1,...
'Delimiter','','HeaderLines',0);
fclose(fidAirfoil);
delete(Airfoil_File);

% Separate boundary points
XB = CP_Data{1}(:,1);
YB = CP_Data{1}(:,2);   
%% READ DATA FILE and plotting: AOA,CL,CD,CM,CDp for chosen Reynolds Number
Data_File = 'Data.csv'; 
fidData = fopen(Data_File);
[~,~,data] = xlsread('Data.csv');

fclose(fidData);
delete(Data_File);
%Extract Data
data = data(13:end,:);
x = cell2mat(textscan(char(data),'%f'));
data = cell2mat(data);
data = str2num(data);

%AOA
Alpha = data(:,1);
%CL
CL = data(:,2);
%CD
CD = data(:,3);
%CDp
CDp = data(:,4);
%CM
CM = data(:,5);
%CL/CD
CLD = CL./CD;

% Plotting Data
figure
scatter(Alpha,CL,'*')
xlim([-10,20])
title('CL vs Angle of Attack')
ylabel('CL')
xlabel('Angle of Attack')

figure
plot(Alpha,CD,'*')
xlim([-10,20])
title('CD vs Angle of Attack')
ylabel('CD')
xlabel('Angle of Attack')

figure
plot(Alpha,CM,'*')
xlim([-10,20])
title('CM vs Angle of Attack')
ylabel('CM')
xlabel('Angle of Attack')

figure
plot(Alpha,CLD,'*')
xlim([-10,20])
title('Cl/CD vs Angle of Attack')
ylabel('CL/CD')
xlabel('Angle of Attack')
 %% PLOT DATA CP
 %Load in and extract the data
 CP_file = 'CP.csv';
fidCP = fopen(CP_file);
CP_Data = textscan(fidCP,'%f %f %f','HeaderLines',3,...
                            'CollectOutput',1,...
                            'Delimiter','');
fclose(fidCP);
delete(CP_file);
% Separate Cp data
X  = CP_Data{1,1}(:,1);
Y  = CP_Data{1,1}(:,2);
Cp = CP_Data{1,1}(:,3);

% Split Xfoil results into (U)pper and (L)ower
Cp_Upper = Cp(YB > 0);
Cp_Lower = Cp(YB < 0);
X_Upper  = X(YB > 0);
X_Lower  = X(YB < 0);

figure;
hold on
scatter(X_Upper,Cp_Upper,'r');
scatter(X_Lower,Cp_Lower,'b');
xlabel('X Coordinate');
ylabel('Cp');
ylim('auto');
title('CP vs X/C at Angle of Attack 0')
ylabel('CP')
xlabel('X/C')
legend('Lower','Upper')

%% Boundary Layer
%Reynolds numbers
 RN3 = 3000000;
 RN10 = 10000000;
 RN15 = 15000000;

 %Retrieving data for the Boundary layer 
 AoA = -10:20;
 for i =1:length(AoA)
[dstar(i),Momentum(i),Shape(i)] = Boundary(NACA,RN3,AoA(i));
 end
 
  for i =1:length(AoA)
[dstar2(i),Momentum2(i),Shape2(i)] = Boundary(NACA,RN10,AoA(i));
  end
 
   for i =1:length(AoA)
[dstar3(i),Momentum3(i),Shape3(i)] = Boundary(NACA,RN15,AoA(i));
 end
 %Plotting graphs for the Boundary layer properties of displacement,
 %momentum and shape factor
 figure
plot(AoA,dstar)
title({'Boundary Layer displacement thickness at Trailing Edge vs AoA','with Reynolds number of 3 million'})
xlabel('Angle')
ylabel('Boundary Layer displacement thickness')

 figure
plot(AoA,Momentum)
title('Momentum thickness vs AoA with Reynolds number of 3 million' )
xlabel('Angle')
ylabel('Boundary Layer Momementum thickness')
 figure
plot(AoA,Shape)
title('Shape vs AoA with Reynolds number of 3 million')
xlabel('Angle')
ylabel('Shape Factor')

figure
plot(AoA,dstar2)
title({'Boundary Layer displacement thickness at Trailing Edge vs AoA','with Reynolds number of 10 million'})
xlabel('Angle')
ylabel('Boundary Layer displacement thickness')

 figure
plot(AoA,Momentum2)
title('Momentum thickness vs AoA with Reynolds number of 10 million' )
xlabel('Angle')
ylabel('Boundary Layer Momementum thickness')
 figure
plot(AoA,Shape2)
title('Shape vs AoA with Reynolds number of 10 million')
xlabel('Angle')
ylabel('Shape Factor')


figure
plot(AoA,dstar3)
title({'Boundary Layer displacement thickness at Trailing Edge vs AoA','with Reynolds number of 15 million'})
xlabel('Angle')
ylabel('Boundary Layer displacement thickness')

 figure
plot(AoA,Momentum3)
title('Momentum thickness vs AoA with Reynolds number of 15 million' )
xlabel('Angle')
ylabel('Boundary Layer Momementum thickness')
 figure
plot(AoA,Shape3)
title('Shape vs AoA with Reynolds number of 15 million')
xlabel('Angle')
ylabel('Shape Factor')