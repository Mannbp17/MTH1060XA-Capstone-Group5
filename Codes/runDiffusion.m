
function results = runDiffusion(params)

% Simulate information diffusion through a social network.

rng(params.seed);

N = params.N;

%% 1. CREATE SOCIAL NETWORK

A = createSocialNetwork(N, params.networkType, ...
    params.k, params.rewiringProbability);

%% 2. CREATE SOCIAL MEDIA USERS

agents = cell(N, 1);

for i = 1:N

    agents{i} = SocialAgent(i, params.trustLevel, ...
        0.6 + 0.2 * rand);

end

%% 3. SELECT INITIAL INFORMATION SOURCE

seedNode = params.seedNode;

agents{seedNode}.HasSeen = true;
agents{seedNode}.ExposureTime = 0;

% Initially, no user has shared the information.
hasShared = false(N, 1);

%% 4. TRACK INFORMATION SPREAD

spread = zeros(params.maxSteps + 1, 1);
spread(1) = 1;

cascade = [];

%% 5. SIMULATE INFORMATION DIFFUSION

for t = 1:params.maxSteps

    newlyExposed = [];

    % Find users who have seen the information but have not shared it.
    activeUsers = find(cellfun(@(x) x.HasSeen, agents) ...
        & ~hasShared);

    for i = activeUsers'

        % Identify the user's connected neighbours.
        neighbours = find(A(i, :) == 1);

        for j = neighbours

            % Only expose users who have not seen the information
            % and have not already been exposed during this time step.
            if ~agents{j}.HasSeen && ~ismember(j, newlyExposed)

                % Calculate the probability of information sharing.
                probability = params.virality * ...
                    agents{j}.Trust * ...
                    agents{i}.SharingPropensity;

                probability = min(max(probability, 0), 1);

                % Determine whether the information is shared.
                if rand < probability

                    newlyExposed(end + 1) = j;

                    agents{j}.ParentID = i;
                    agents{j}.ExposureTime = t;

                    cascade(end + 1, :) = [i, j];

                end
            end
        end

        % Mark the current user as having shared the information.
        hasShared(i) = true;

    end

    %% ACTIVATE NEWLY EXPOSED USERS

    newlyExposed = unique(newlyExposed);

    for idx = 1:numel(newlyExposed)

        j = newlyExposed(idx);

        agents{j}.HasSeen = true;

    end

    % Record the total number of users reached at this time step.
    spread(t + 1) = sum(cellfun(@(x) x.HasSeen, agents));

end

%% 6. RETURN SIMULATION RESULTS

results.spread = spread;
results.cascade = cascade;
results.network = A;
results.agents = agents;

results.totalReached = spread(end);
results.reachPercentage = (spread(end) / N) * 100;

end
