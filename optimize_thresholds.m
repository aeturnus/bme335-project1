%% Parts 2 & 3: Defining Quadrants & Quadrant Based Classifier
%A and B domain boundaries must be constant for both T1 and T2 cells
%Trial and error gave same ability to predict T1 and T2 (appx 67%)
%when A is bounded by 0.65 and B is bounded by 0.6

sums = zeros(length(b),length(a));
sumsT1 = zeros(length(b),length(a));
sumsT2 = zeros(length(b),length(a));
%Quadrant 1: High A, low B --> High T1
%Quadrant 4: High B, low A --> High T2

% Will test boundaries for quadrant 1 and 4 and get the values
for testA = 1: length(a)
    for testB = 1: length(b)
        sumT1 = 0;
        xt = length(a);
        while xt > a(testA)*length(a)
            yt = 1;
            while yt < b(testB)*length(b)
                sumT1 = sumT1 + pdf_1(yt,xt);
                yt = yt + 1;
            end
            xt = xt - 1;
        end
        sumsT1(testB,testA) = sumT1;

        sumT2 = 0;
        yt = length(a);
        while yt > b(testB)*length(b)
            xt = 1;
            while xt < a(testA)*length(a)
                sumT2 = sumT2 + pdf_2(yt,xt);
                xt = xt + 1;
            end
            yt = yt - 1;
        end
        sumsT2(testB,testA) = sumT2;

        sums(testB,testA) = sumT1+sumT2;
    end
end

% find A and B thresholds that will maximize the probability of either T1 or T2
[maxT,iT] = max(sums(:)); % get largest value in linear index
[maxB, maxA] = ind2sub(size(sums),iT);
fprintf('Highest probability of classifying as T1 or T2 occurs at a threshold of:\na_t = %g\nb_t=%g\nNaive sum of p(T1) and p(T2): %g\n',a(maxA),b(maxB),maxT);

