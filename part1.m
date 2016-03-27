%% Part 1: Preliminary Study
% Parameters
alp = 11.6;
bet = 5.3;

% a is the concentration of A from 0 to 1 in intervals of 0.01
a = linspace(0,1,(1-0)/delta+1);
% b is the concentration of B from 0 to 1 in intervals of 0.01
b = linspace(0,1,(1-0)/delta+1);


pdf_1 = []; %pdf matrix of the first equation
pdf_2 = []; %pdf matrix of the second equation
for x = 1:length(a)
    for y = 1: length(b)
        % calculate values of each pdf matrix
        pdf_1(y,x) = alp * ( 0.05 + a(x)^2 ) * ( (b(y)-1)^4 + 0.025 );
        pdf_2(y,x) = bet * ( 1 - a(x)^2 ) * ( 0.05 + b(y)^4 + (a(x)^2) * (b(y)^2) /2 );
        pdf_1(y,x) = pdf_1(y,x) * delta * delta;
        pdf_2(y,x) = pdf_2(y,x) * delta * delta;
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
plot(a,mCDFaT2);
hold on;
plot(b,mCDFbT2, 'r');
ylabel('T2');
title('Marginal CDFs for T2 cells');
legend('a', 'b');