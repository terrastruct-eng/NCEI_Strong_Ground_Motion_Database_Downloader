% Script to import ground motion data from the NOAA
% Written by Fernando Gutiérrez-Urzúa
% f.urzua@ucl.ac.uk

% Build a recursive function that investigates within a folder if other
% folders are available and extracts relevant files to write them in a
% similar fashion in the local PC

%% Clear the workspace and command window
clear
clc

%% Run the script

% Define the parent directory URL (change for the folder you want)
folder_url = 'https://www.ngdc.noaa.gov/hazard/data/cdroms/EQ_StrongMotion_v3/';

% Local folder
local_mirror = './EQ_StrongMotion_v3/';

% Call recursive function
explore_folder(local_mirror,folder_url)


