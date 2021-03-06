function [J_opt, u_opt_ind] = ValueIteration(P, G)
% VALUEITERATION Value iteration
% Solve a stochastic shortest path problem by Value Iteration.
%
%   [J_opt, u_opt_ind] = ValueIteration(P, G) computes the optimal cost and
%   the optimal control input for each state of the state space.
%
%   Input arguments:
%       P:
%           A (K x K x L)-matrix containing the transition probabilities
%           between all states in the state space for all control inputs.
%           The entry P(i, j, l) represents the transition probability
%           from state i to state j if control input l is applied.
%       G:
%           A (K x L)-matrix containing the stage costs of all states in
%           the state space for all control inputs. The entry G(i, l)
%           represents the cost if we are in state i and apply control
%           input l.
%
%   Output arguments:
%       J_opt:
%       	A (K x 1)-matrix containing the optimal cost-to-go for each
%       	element of the state space.
%       u_opt_ind:
%       	A (K x 1)-matrix containing the index of the optimal control
%       	input for each element of the state space. Mapping of the
%       	terminal state is arbitrary (for example: HOVER).

%% declare global variables
global K HOVER
global TERMINAL_STATE_INDEX

%% initialize variables
tol = 1e-6; % error tolerance
error = intmax; % initial error
J_opt = zeros(K, 1); % optimal cost-to-go vector
J_prev = zeros(K, 1); % previous optimal cost-to-go vector
J_opt_temp = zeros(K, 5); % store temporary cost-to-go matrix
u_opt_ind = HOVER * ones(K, 1); % optimal control vector
nonTerminalState = [1:TERMINAL_STATE_INDEX-1 TERMINAL_STATE_INDEX+1:K];

%% start iteration
while( error > tol )
    % construct J_opt_temp: the k-th column indicates the cost-to-go vector after applying control k
    for k  = 1:5
        J_opt_temp(nonTerminalState,k) = G(nonTerminalState,k) + P(nonTerminalState,nonTerminalState,k) * J_opt(nonTerminalState);
    end
    % compute optimal cost-to-go and optimal control
    [J_opt, u_opt_ind] = min(J_opt_temp, [], 2);
    % update error
    error = max(abs(J_opt - J_prev));
    % store optimal cost-to-go after this iteration
    J_prev = J_opt;
end

end