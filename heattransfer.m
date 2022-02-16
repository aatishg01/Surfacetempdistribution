clc;
%% Set boundary conditions

% Create nxn 2-D surface
size = 5; 
a = zeros(size,size);

% Set temperature of sides
a(1,:) = 100.*ones(size, 1);
a(:,1) = 100.*ones(size, 1);
a(:,size) = 150.*ones(size, 1);
a(size,:) = -150*ones(size, 1);



%% Create matrix of boundary conditions

% Constants that will be used throughout
c1 = (length(a)-2)^2; % number of nodes
c2 = length(a)-2;     % n of nxn solution matrix
c3 = length(a)-3;     % Honestly don't need this but it's legacy at this point

% Create and fill boundary matrix using boundary conditions
% See external documentation for justification
boundaries = zeros(c1,4);

% Top
for i = 1:c2
    boundaries(i,1) = -a(1, i+1);
end
count = 2;
% Bottom
for i = (c1-2):c1
    boundaries(i,4) = -a(size, count);
    count = count + 1;
end
count = 2;
% Right
for i = 1:c3+1:c1
    boundaries(i,2) = -a(count, 1);
    count = 1+count;
end
count = 2;
% Bottom
for i = c3+1:c3+1:c1
    boundaries(i,3) = -a(count, size);
    count = 1+count;
end

%% Create and fill solution matrix

% Create an nxn solution space
b = zeros(c1, c1);

% Fill in solution matrix. See external documentation for justification

% Repeated throughout
repeat = [1 -4 1];
fillin = [1, zeros(1, c3-1) , repeat, zeros(1, c3-1), 1];

% Fill in top 
count1 = round(length(fillin)/2);
count2 = 1;
for j = length(fillin)/2:-1:0
    b(count2,:) = b(count2,:) + [fillin(j:length(fillin)), zeros(1, length(b)-count1)];
    count2 = count2 + 1;
    count1 = count1 + 1;
end

% Fill in middle
count3 = 1;
while count1 < c1
    fillin(1:j);
    [zeros(1,count3), fillin, zeros(1,length(b)-count1+count3)];
    j =length(fillin);
    b(count2,:) = b(count2,:) + [zeros(1,count3), fillin, zeros(1,length(b)-count1)];
    count2 = count2 + 1;
    count1 = count1 +1;
    count3 = count3 + 1;
end

% Fill in bottom
for j = length(fillin):-1:length(fillin)/2
    fillin(1:j);
    b(count2,:) = b(count2,:) + [zeros(1,count3), fillin(1:j)];
    count2 = count2 + 1;
    count3 = count3 + 1;
end

% Insert zeros to account for sides of surface
for i = c2:c2:length(b)-1
    b(i,i+1) = 0;
end
for i = c2+1:c2:length(b)
    b(i,i-1) = 0;
end

%% Introduce boundary conditions to matrix
b = [b, ones(c1, 1)];
for i = 1:length(b)-1
    b(i,length(b)) = sum(boundaries(i,:));
end

%% Solve matrix
b
% boundaries
b = rref(b);

%% Update initial table using solved values
c = a;
count = 1;
for i = 1:length(c)-2
    for j = 1:length(c)-2
        c(i+1,j+1) = b(count, length(b));
        count = count + 1;
    end
end

%% Plot surface
c;
s = surf(c)
zlabel('Temperature, Degrees Celsius')
