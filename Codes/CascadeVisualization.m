
clear;
clc;
close all;

%% 1. SET SIMULATION PARAMETERS

params.N = 100;
params.networkType = 'random';
params.k = 6;
params.rewiringProbability = 0.1;

params.trustLevel = 0.8;
params.virality = 0.7;

params.maxSteps = 20;
params.seedNode = 1;
params.seed = 42;

%% 2. RUN SIMULATION

results = runDiffusion(params);

%% 3. CREATE CASCADE NETWORK

if isempty(results.cascade)

    error('No information-sharing events occurred.');

end

G = digraph(results.cascade(:, 1), ...
    results.cascade(:, 2), [], params.N);

%% 4. PREPARE NODE COLOURS

exposureTimes = zeros(params.N, 1);

for i = 1:params.N

    exposureTimes(i) = results.agents{i}.ExposureTime;

end


%% 5. VISUALISE INFORMATION CASCADE

figure('Color', 'white', 'Position', [100 100 1100 750]);

p = plot(G, 'Layout', 'layered');

% Colour nodes according to their exposure time.
p.NodeCData = exposureTimes;

p.MarkerSize = 7;
p.EdgeColor = [0.35 0.35 0.35];
p.LineWidth = 1.2;
p.ArrowSize = 10;
p.NodeLabel = {};

colormap(parula);
colorbar;

title('Information Sharing Cascade', ...
    'FontSize', 16, ...
    'FontWeight', 'bold', ...
    'Color', 'black');

%% 6. HIGHLIGHT ORIGINAL INFORMATION SOURCE

% Give the original source a larger marker.
p.MarkerSize = 7;
highlight(p, params.seedNode, 'MarkerSize', 12);


%% 7. DISPLAY RESULTS

fprintf('\nINFORMATION CASCADE ANALYSIS\n');
fprintf('----------------------------\n');

fprintf('Initial information source: User %d\n', ...
    params.seedNode);

fprintf('Total users reached: %d\n', ...
    results.totalReached);

fprintf('Total sharing connections: %d\n', ...
    numedges(G));

%% 8. SAVE CASCADE FIGURE

scriptFolder = fileparts(mfilename('fullpath'));

resultsFolder = fullfile(scriptFolder, '..', 'Results');

if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

saveas(gcf, fullfile(resultsFolder, ...
    'Information_Cascade.png'));

save(fullfile(resultsFolder, ...
    'Cascade_Results.mat'), 'G', 'results', 'params');

fprintf('\nCascade visualization saved successfully.\n');
