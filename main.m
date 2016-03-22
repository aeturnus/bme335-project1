clc; clear all; close all;
%% Part 1: Preliminary Study
% a is the concentration of A from 0 to 1 in intervals of 0.01
a = linspace(0,1,(1-0)/0.01+1);
% b is the concentration of B from 0 to 1 in intervals of 0.01
b = linspace(0,1,(1-0)/0.01+1);

alp = 11.6;
bet = 5.3;

pdf_1 = []; %pdf matrix of the first equation
pdf_2 = []; %pdf matrix of the second equation
for x = 1:length(a)
    for y = 1: length(b)
        % calculate values of each pdf matrix
        pdf_1(y,x) = alp * ( 0.05 + a(x)^2 ) * ( (b(y)-1)^4 + 0.025 );
        pdf_2(y,x) = bet * ( 1 - a(x)^2 ) * ( 0.05 + b(y)^4 + (a(x)^2) * (b(y)^2) /2 );
        pdf_1(y,x) = pdf_1(y,x) * 0.01 * 0.01;
        pdf_2(y,x) = pdf_2(y,x) * 0.01 * 0.01;
    end
end

%Create Marginals
for x = 1:length(a)
    mPDFaT1(x) = sum(pdf_1(:,x)); %Marginal PDF for A in T1 cells
    
    %Marginal CDF for A in T1 cells
    if x < 2
        mCDFaT1(x) = mPDFaT1(x);
    else
    mCDFaT1(x) = mCDFaT1(x-1) + mPDFaT1(x);
    end
    
    mPDFaT2(x) = sum(pdf_2(:,x)); %Marginal PDF for A in T2 cells
    
    %Marginal CDF for A in T2 cells
    if x < 2
        mCDFaT2(x) = mPDFaT2(x);
    else
    mCDFaT2(x) = mCDFaT2(x-1) + mPDFaT2(x);
    end
end

for y = 1:length(b)
    mPDFbT1(y) = sum(pdf_1(y,:)); %Marginal PDF for B in T1 cells
    
    %Marginal CDF for B in T1 cells
    if y < 2
        mCDFbT1(y) = mPDFbT1(y);
    else
    mCDFbT1(y) = mCDFbT1(y-1) + mPDFbT1(y);
    end
    
    mPDFbT2(y) = sum(pdf_2(y,:)); %Marginal PDF for B in T2 cells
   
    %Marginal CDF for B in T2 cells
    if y < 2
        mCDFbT2(y) = mPDFbT2(y);
    else
    mCDFbT2(y) = mCDFbT2(y-1) + mPDFbT2(y);
    end
    
end


%plot first pdf 
subplot(1,2,1);
surf(a,b,pdf_1);
title('T1 pdf');
xlabel('a');
ylabel('b');
hold on
%plot second pdf
subplot(1,2,2);
surf(a,b,pdf_2);
title('T2 pdf');
xlabel('a');
ylabel('b');
hold on

%plot marginal pdfs
figure;
subplot(2,1,1);
plot(a,mPDFaT1);
hold on;
plot(b,mPDFbT1, 'r');
ylabel('T1');
title('Marginal PDFs T1 cells');
legend('a', 'b');
subplot(2,1,2);
plot(b,mPDFbT2);
hold on;
plot(a,mPDFaT2, 'r');
ylabel('T2');
title('Marginal PDFs for T2 cells');
legend('b', 'a');

%plot marginal CDFs
figure;
subplot(2,1,1);
plot(a,mCDFaT1);
hold on;
plot(b,mCDFbT1, 'r');
ylabel('T1');
title('Marginal CDFs T1 cells');
legend('a', 'b');
subplot(2,1,2);
plot(b,mCDFbT2);
hold on;
plot(a,mCDFaT2, 'r');
ylabel('T2');
title('Marginal CDFs for T2 cells');
legend('b', 'a');

%% Parts 2 & 3: Defining Quadrants & Quadrant Based Classifier
%A and B domain boundaries must be constant for both T1 and T2 cells
%Trial and error gave same ability to predict T1 and T2 (appx 67%)
%when A is bounded by 0.65 and B is bounded by 0.6

%T1 Cells:
PQT1 = zeros(2,2);

%Quadrant 1: High A, low B --> High T1
xt = length(a);
while xt > 0.65*length(a)
    yt = 1;
    while yt < 0.6*length(b)
           PQT1(1,1) = PQT1(1,1) + pdf_1(yt,xt);
           yt = yt + 1;
    end
        xt = xt - 1;
end
%Quadrant 2: High A, high B --> inconclusive
xt = length(a);
while xt > 0.65*length(a)
    yt = length(b);
    while yt > 0.6*length(b)
           PQT1(1,2) = PQT1(1,2) + pdf_1(yt,xt);
           yt = yt - 1;
    end
        xt = xt - 1;
end
%Quadrant 3: Low A, low b --> inconclusive
xt = 1;
while xt < 0.65*length(a)
    yt = 1;
    while yt < 0.6*length(b)
           PQT1(2,1) = PQT1(2,1) + pdf_1(yt,xt);
           yt = yt + 1;
    end
        xt = xt + 1;
end
%Quadrant 4: Low A, high b --> High T2
xt = 1;
while xt < 0.65*length(a)
    yt = length(b);
    while yt > 0.6*length(b)
           PQT1(2,2) = PQT1(2,2) + pdf_1(yt,xt);
           yt = yt - 1;
    end
        xt = xt + 1;
end


%T2 Cells:
PQT2 = zeros(2,2);

%Quadrant 1: Low B, high A --> High T1
yt = 1;
while yt < 0.6*length(b)
    xt = length(a);
    while xt > 0.65*length(a)
           PQT2(1,1) = PQT2(1,1) + pdf_2(yt,xt);
           xt = xt - 1;
    end
        yt = yt + 1;
end
%Quadrant 2: High B, High A --> Inconclusive
yt = length(b);
while yt > 0.6*length(b)
    xt = length(a);
    while xt > 0.65*length(a)
           PQT2(1,2) = PQT2(1,2) + pdf_2(yt,xt);
           xt = xt - 1;
    end
        yt = yt - 1;
end
%Quadrant 3: Low B, Low A --> Inconclusive
yt = 1;
while yt < 0.6*length(b)
    xt = 1;
    while xt < 0.65*length(a)
           PQT2(2,1) = PQT2(2,1) + pdf_2(yt,xt);
           xt = xt + 1;
    end
        yt = yt + 1;
end
%Quadrant 4: High B, low A --> High T2
yt = length(b);
while yt > 0.6*length(b)
    xt = 1;
    while xt < 0.65*length(a)
           PQT2(2,2) = PQT2(2,2) + pdf_2(yt,xt);
           xt = xt + 1;
    end
        yt = yt - 1;
end
%
%
%How good/or bad would the classifier perform
%for samples with different T1:T2 ratios?
%
%

%% Part 4: The Bayesian classifier

%uniformative prior that considers P(T1) = P(T2) = .5
PT1 = .5;
PT2 = .5;

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
