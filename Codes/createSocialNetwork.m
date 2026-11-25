
function A = createSocialNetwork(N, networkType, k, rewiringProbability)

% Create an adjacency matrix for a social network.

A = zeros(N);

switch lower(networkType)

    case 'random'
        connectionProbability = k / (N - 1);
        A = triu(rand(N) < connectionProbability, 1);
        A = A + A';

    case 'small-world'
        % Begin with a ring lattice.
        halfK = floor(k / 2);

        for i = 1:N
            for j = 1:halfK
                neighbour = mod(i - 1 + j, N) + 1;
                A(i, neighbour) = 1;
                A(neighbour, i) = 1;
            end
        end

        % Rewire some connections.
        for i = 1:N
            for j = 1:halfK

                neighbour = mod(i - 1 + j, N) + 1;

                if rand < rewiringProbability

                    A(i, neighbour) = 0;
                    A(neighbour, i) = 0;

                    candidates = find(A(i,:) == 0);
                    candidates(candidates == i) = [];

                    if ~isempty(candidates)
                        newNeighbour = candidates(randi(length(candidates)));
                        A(i, newNeighbour) = 1;
                        A(newNeighbour, i) = 1;
                    else
                        A(i, neighbour) = 1;
                        A(neighbour, i) = 1;
                    end
                end
            end
        end

    otherwise
        error('Unknown network type.');
end

end
