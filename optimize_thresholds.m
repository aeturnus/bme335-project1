% This will print out the threshold values to maximize getting either T1 or T2

scores = zeros(length(b),length(a));
scoresT1 = zeros(length(b),length(a));
scoresT2 = zeros(length(b),length(a));
%Quadrant 1: High A, low B --> High T1
%Quadrant 4: High B, low A --> High T2

% Will test boundaries for quadrant 1 and 4 and get the values
for testA = 1: length(a)
    for testB = 1: length(b)
        scoreT1 = 0;
        scoreT2 = 0;
        penaltyT1 = 0;
        penaltyT2 = 0;


        xt = length(a);
        while xt > a(testA)*length(a)
            yt = 1;
            while yt < b(testB)*length(b)
                scoreT1 = scoreT1 + pdf_1(yt,xt);
                penaltyT1 = penaltyT1 + pdf_2(yt,xt);   % probability of T2 reduces score of T1
                yt = yt + 1;
            end
            xt = xt - 1;
        end

        yt = length(a);
        while yt > b(testB)*length(b)
            xt = 1;
            while xt < a(testA)*length(a)
                scoreT2 = scoreT2 + pdf_2(yt,xt);
                penaltyT2 = penaltyT2 + pdf_1(yt,xt);   % probability of T1 reduces score of T2
                xt = xt + 1;
            end
            yt = yt - 1;
        end
        
        scoresT1(testB,testA) = scoreT1 - penaltyT1;
        scoresT2(testB,testA) = scoreT2 - penaltyT2;

        scores(testB,testA) = scoresT1(testB,testA) + scoresT2(testB,testA);  % hold the total score for a threshold pair
    end
end

% find A and B thresholds that will maximize the probability of either T1 or T2
[maxT,iT] = max(sums(:)); % get largest value in linear index
[maxB, maxA] = ind2sub(size(sums),iT);
fprintf('Highest probability of classifying as T1 or T2 occurs at a threshold of:\na_t = %g\nb_t=%g\nScore: %g\n',a(maxA),b(maxB),maxT);

