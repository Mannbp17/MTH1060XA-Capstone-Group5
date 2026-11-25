
clear;
clc;
close all;

%% SIMULATION PARAMETERS

params.N = 100;
params.networkType = 'random';
params.k = 6;
params.rewiringProbability = 0.1;

params.trustLevel = 0.8;
params.virality = 0.7;

params.maxSteps = 20;
params.seedNode = 1;
params.seed = 42;

%% RUN SIMULATION

results = runDiffusion(params);

%% DISPLAY RESULTS

fprintf('SOCIAL MEDIA INFORMATION DIFFUSION\n');
fprintf('----------------------------------\n');

fprintf('Network type: %s\n', params.networkType);
fprintf('Trust level: %.2f\n', params.trustLevel);
fprintf('Virality: %.2f\n', params.virality);

fprintf('Total users reached: %d out of %d\n', ...
    results.totalReached, params.N);

fprintf('Reach percentage: %.2f%%\n', ...
    results.reachPercentage);

%% PLOT INFORMATION SPREAD

figure('Color', 'white', 'Position', [100 100 900 600]);

plot(0:params.maxSteps, results.spread, ...
    'b-o', 'LineWidth', 2, 'MarkerSize', 5);

xlabel('Time Steps', ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'black');

ylabel('Number of Users Reached', ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'black');

title('Information Diffusion in a Social Network', ...
    'FontSize', 15, 'FontWeight', 'bold', 'Color', 'black');

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.XColor = 'black';
ax.YColor = 'black';

grid on;
box on;

%% CREATE RESULTS FOLDER IF NECESSARY

scriptFolder = fileparts(mfilename('fullpath'));

resultsFolder = fullfile(scriptFolder, '..', 'Results');

if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

%% SAVE OUTPUTS

saveas(gcf, fullfile(resultsFolder, ...
    'Information_Diffusion.png'));

save(fullfile(resultsFolder, 'Simulation_Results.mat'), ...
    'params', 'results');

fprintf('\nResults saved successfully.\n');
