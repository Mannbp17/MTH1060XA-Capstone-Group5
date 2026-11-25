
clear;
clc;
close all;

%% 1. DEFINE SCENARIOS

networkTypes = {'random', 'small-world'};

trustLevels = [0.30, 0.80];
trustLabels = {'Low', 'High'};

viralityLevels = [0.30, 0.70];
contentTypes = {'Low-virality', 'High-virality'};

scenarioCount = 8;
numberOfRuns = 10;

meanReachedUsers = zeros(scenarioCount, 1);
meanReachPercentages = zeros(scenarioCount, 1);
stdReachPercentages = zeros(scenarioCount, 1);

spreadMatrix = zeros(21, scenarioCount);
scenarioLabels = cell(scenarioCount, 1);

% Store results from every individual run.
allReachPercentages = zeros(scenarioCount, numberOfRuns);

%% 2. SET BASE SIMULATION PARAMETERS

params.N = 100;
params.k = 6;
params.rewiringProbability = 0.1;
params.maxSteps = 20;
params.seedNode = 1;

baseSeed = 42;

%% 3. RUN ALL SCENARIOS

scenario = 0;

for n = 1:numel(networkTypes)

    for t = 1:numel(trustLevels)

        for v = 1:numel(viralityLevels)

            scenario = scenario + 1;

            params.networkType = networkTypes{n};
            params.trustLevel = trustLevels(t);
            params.virality = viralityLevels(v);

            % Store results from the 10 simulation runs.
            reachedRuns = zeros(numberOfRuns, 1);
            spreadRuns = zeros(21, numberOfRuns);

            scenarioLabels{scenario} = sprintf( ...
                '%s | %s trust | %s content', ...
                networkTypes{n}, trustLabels{t}, ...
                contentTypes{v});

            fprintf('\nScenario %d: %s\n', ...
                scenario, scenarioLabels{scenario});

            %% RUN THE SCENARIO 10 TIMES

            for r = 1:numberOfRuns

                % Use a different random seed for each run.
                params.seed = baseSeed + r - 1;

                results = runDiffusion(params);

                reachedRuns(r) = results.totalReached;

                spreadRuns(:, r) = results.spread;

                allReachPercentages(scenario, r) = ...
                    results.reachPercentage;

            end

            %% CALCULATE AVERAGE RESULTS

            meanReachedUsers(scenario) = mean(reachedRuns);

            meanReachPercentages(scenario) = ...
                mean(allReachPercentages(scenario, :));

            stdReachPercentages(scenario) = ...
                std(allReachPercentages(scenario, :));

            spreadMatrix(:, scenario) = mean(spreadRuns, 2);

            fprintf('Number of simulation runs: %d\n', ...
                numberOfRuns);

            fprintf('Average users reached: %.2f out of %d\n', ...
                meanReachedUsers(scenario), params.N);

            fprintf('Average reach percentage: %.2f%%\n', ...
                meanReachPercentages(scenario));

            fprintf('Standard deviation: %.2f%%\n', ...
                stdReachPercentages(scenario));

        end
    end
end

%% 4. CREATE RESULTS TABLE

resultsTable = table( ...
    scenarioLabels, ...
    meanReachedUsers, ...
    meanReachPercentages, ...
    stdReachPercentages, ...
    'VariableNames', ...
    {'Scenario', 'AverageUsersReached', ...
    'AverageReachPercentage', 'StandardDeviation'});

disp(' ');
disp('AVERAGE SCENARIO COMPARISON RESULTS');
disp(resultsTable);

%% 5. PLOT AVERAGE REACH PERCENTAGES

figure('Color', 'white', 'Position', [100 100 1200 700]);

bar(meanReachPercentages, ...
    'FaceColor', [0.20 0.55 0.85], ...
    'EdgeColor', [0.10 0.25 0.45], ...
    'LineWidth', 1.2);

hold on;

% Show variation across the 10 runs.
errorbar(1:scenarioCount, meanReachPercentages, ...
    stdReachPercentages, 'k.', 'LineWidth', 1.5);

hold off;

xlabel('Simulation Scenarios', ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'black');

ylabel('Average Users Reached (%)', ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'black');

title('Average Information Reach Across Scenarios', ...
    'FontSize', 16, 'FontWeight', 'bold', 'Color', 'black');

xticks(1:scenarioCount);
xticklabels(scenarioLabels);
xtickangle(35);

ylim([0 100]);

ax = gca;
ax.FontSize = 11;
ax.FontWeight = 'bold';
ax.XColor = 'black';
ax.YColor = 'black';
ax.LineWidth = 1.2;
ax.GridColor = [0.35 0.35 0.35];
ax.GridAlpha = 0.45;

grid on;
box on;

%% 6. PLOT AVERAGE INFORMATION SPREAD OVER TIME

figure('Color', 'white', 'Position', [100 100 1200 700]);

hold on;

lineColors = lines(scenarioCount);

for i = 1:scenarioCount

    plot(0:params.maxSteps, spreadMatrix(:, i), ...
        'LineWidth', 2.5, ...
        'Color', lineColors(i, :));

end

hold off;

xlabel('Time Steps', ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'black');

ylabel('Average Number of Users Reached', ...
    'FontSize', 13, 'FontWeight', 'bold', 'Color', 'black');

title('Average Information Diffusion Across Scenarios', ...
    'FontSize', 16, 'FontWeight', 'bold', 'Color', 'black');

legend(scenarioLabels, ...
    'Location', 'eastoutside', ...
    'FontSize', 9, ...
    'TextColor', 'black');

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.XColor = 'black';
ax.YColor = 'black';
ax.LineWidth = 1.2;
ax.GridColor = [0.35 0.35 0.35];
ax.GridAlpha = 0.45;

grid on;
box on;

%% 7. SAVE RESULTS

scriptFolder = fileparts(mfilename('fullpath'));

resultsFolder = fullfile(scriptFolder, '..', 'Results');

if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

writetable(resultsTable, ...
    fullfile(resultsFolder, 'Scenario_Comparison.csv'));

save(fullfile(resultsFolder, 'Scenario_Comparison.mat'), ...
    'resultsTable', 'spreadMatrix', 'scenarioLabels', ...
    'allReachPercentages', 'meanReachPercentages', ...
    'stdReachPercentages', 'numberOfRuns');

figures = findall(0, 'Type', 'figure');

for i = 1:numel(figures)

    saveas(figures(i), fullfile(resultsFolder, ...
        sprintf('Scenario_Figure_%d.png', i)));

end

fprintf('\nAll repeated simulation results and figures saved successfully.\n');
