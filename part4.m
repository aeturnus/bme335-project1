%% Part 4: The Bayesian classifier

%uniformative prior that considers P(T1) = P(T2) = .5
PT1 = 1/3;
PT2 = 1-PT1;

%Total Probability Theorem:
%  P(Q1) = P(Q1|T1)P(T1) + P(Q1|T2)P(T2)
PQ = zeros(2,2);
PQ =   PQT1(:,:)*PT1 + PQT2(:,:)*PT2;

% Baye's Rule: P(A|B) = [P(B|A)P(A)]/P(B)
%  P(T1|Qx) = [P(Qx|T1)P(T1)]/P(Qx)
PT1Q = zeros(2,2); %P(T1|Qx)
PT1Q = (PQT1(:,:)*PT1)./PQ(:,:);

%  P(T2|Qx) = [P(Qx|T2)P(T2)]/P(Qx)
PT2Q = zeros(2,2); %P(T2|Qx)
PT2Q = (PQT2(:,:)*PT2)./PQ(:,:);
%
%
%How good is the Bayesian classifier?
%
%