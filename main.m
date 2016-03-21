clc
%a is the concentration of A from 0 to 1 in intervals of 0.01
a = linspace(0,1,101);
%b is the concentration of B from 0 to 1 in intervals of 0.01
b = linspace(0,1,101);

pdf_1 = [];%pdf matrix of the first equation
pdf_2 = [];%pdf matrix of the second equation
for x = 1:length(a)
    for y = 1: length(b)
        %calculate values of each pdf matrix
        pdf_1(x,y) = 11.6 * (0.05 + (a(x)^2)) * (((b(y)-1)^4)+0.025);
        pdf_2(x,y) = 5.3* (1 - (a(x)^2)) * (0.05 + (b(y)^4) + (a(x)*b(y)/2));
    end
end
%plot first pdf 
surf(a,b,pdf_1);
hold on
%plot second pdf
surf(a,b,pdf_2);
hold on