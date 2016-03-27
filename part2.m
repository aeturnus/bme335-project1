%% Parts 2 & 3: Defining Quadrants & Quadrant Based Classifier
%A and B domain boundaries must be constant for both T1 and T2 cells
%Trial and error gave same ability to predict T1 and T2 (appx 67%)
%when A is bounded by 0.65 and B is bounded by 0.6

%T1 Cells:
PQT1 = zeros(2,2);

[b_t, a_t] = optimize_thresholds(a,b,pdf_1,pdf_2); % boundary vars
a_t = a(a_t);
b_t = b(b_t);
%Quadrant 1: High A, low B --> High T1
xt = length(a);
while xt > a_t*length(a)
    yt = 1;
    while yt < b_t*length(b)
           PQT1(1,1) = PQT1(1,1) + pdf_1(yt,xt);
           yt = yt + 1;
    end
        xt = xt - 1;
end
%Quadrant 2: High A, high B --> inconclusive
xt = length(a);
while xt > a_t*length(a)
    yt = length(b);
    while yt > b_t*length(b)
           PQT1(1,2) = PQT1(1,2) + pdf_1(yt,xt);
           yt = yt - 1;
    end
        xt = xt - 1;
end
%Quadrant 3: Low A, low b --> inconclusive
xt = 1;
while xt < a_t*length(a)
    yt = 1;
    while yt < b_t*length(b)
           PQT1(2,1) = PQT1(2,1) + pdf_1(yt,xt);
           yt = yt + 1;
    end
        xt = xt + 1;
end
%Quadrant 4: Low A, high b --> High T2
xt = 1;
while xt < a_t*length(a)
    yt = length(b);
    while yt > b_t*length(b)
           PQT1(2,2) = PQT1(2,2) + pdf_1(yt,xt);
           yt = yt - 1;
    end
        xt = xt + 1;
end


%T2 Cells:
PQT2 = zeros(2,2);
%Quadrant 1: Low B, high A --> High T1
yt = 1;
while yt < b_t*length(b)
    xt = length(a);
    while xt > a_t*length(a)
           PQT2(1,1) = PQT2(1,1) + pdf_2(yt,xt);
           xt = xt - 1;
    end
        yt = yt + 1;
end
%Quadrant 2: High B, High A --> Inconclusive
yt = length(b);
while yt > b_t*length(b)
    xt = length(a);
    while xt > a_t*length(a)
           PQT2(1,2) = PQT2(1,2) + pdf_2(yt,xt);
           xt = xt - 1;
    end
        yt = yt - 1;
end
%Quadrant 3: Low B, Low A --> Inconclusive
yt = 1;
while yt < b_t*length(b)
    xt = 1;
    while xt < a_t*length(a)
           PQT2(2,1) = PQT2(2,1) + pdf_2(yt,xt);
           xt = xt + 1;
    end
        yt = yt + 1;
end
%Quadrant 4: High B, low A --> High T2
yt = length(b);
while yt > b_t*length(b)
    xt = 1;
    while xt < a_t*length(a)
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
t1 = (0:1:100);
t2 = (0:1:100);
et1 = t1*(PQT1(1,2) + PQT1(2,1) + PQT1(2,2));
et2 = t2*(PQT2(1,2) + PQT2(2,1) + PQT2(1,1));
ct1 = t1*PQT1(1,1);
ct2 = t2*PQT2(2,2);
it1 = t1*(PQT1(1,2) + PQT1(2,1));
it2 = t2*(PQT2(1,2) + PQT2(2,1));
mt1 = t1*PQT1(2,2);
mt2 = t2*PQT2(1,1);
figure;
subplot(2,2,1);
plot(t1, et1, 'r', 'LineWidth', 2);
hold on;
plot(t2, et2, 'b', 'LineWidth', 2);
xlabel('Number of Cells');
ylabel('Not Correctly Classified Cells');
legend('E[Q1''|T1]', 'E[Q4''|T2]');
title('Classification Error for P(Q|T)');
subplot(2,2,2);
plot(t1, mt1, 'r', 'LineWidth', 2);
hold on;
plot(t2, mt2, 'b', 'LineWidth', 2);
xlabel('Number of Cells');
ylabel('Misclassified Cells');
legend('E[Q4|T1]', 'E[Q1|T2]');
title('Misclassification for P(Q|T)');
subplot(2,2,3);
plot(t1, it1, 'r', 'LineWidth', 2);
hold on;
plot(t2, it2, 'b', 'LineWidth', 2);
xlabel('Number of Cells');
ylabel('Inconclusive Cells');
legend('E[Q2|T1 U Q3|T1]', 'E[Q2|T2 U Q3|T2]');
title('Inconclusive Classification for P(Q|T)');
subplot(2,2,4);
plot(t1, ct1, 'r', 'LineWidth', 2);
hold on;
plot(t2, ct2, 'b', 'LineWidth', 2);
xlabel('Number of Cells');
ylabel('Correctly Classified Cells');
legend('E[Q1|T1]', 'E[Q4|T2]');
title('Correct Classification for P(Q|T)');
