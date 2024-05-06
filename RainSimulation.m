%Main tasks for this computer model:
%The interest was on trying to give a reasonable description of the
%dynamics of water when struck by a little raindrop in the middle of
%the street, a pond or anywhere. First, the water particles will be
%abstracted as discrete points in the 2D plane. The main idea is that once
%a raindrop randomly chooses an impact point to hit, a little circle
%centered there will experiment a force and starting at rest , every water
%particle in the circle will escape outwards in all directions, at the same speed.
%More concretely, their distance from the impact point will be governed by
%the equation R'' = A*exp(-t)-u*R' , u = Drag coefficient, A = max force
%with initial conditions R(0) = eps, R'(0) = 0. This is a linear drag
%model, first order ODE for the radial velocity R', with a decaying exponential
%forcing in time.
%To add more realism and use knowledge from Stochastic Processes as well, I
%will let the number of raindrops at a particular instant be a Poisson
%Process with rate lambda. Also, I will let the positions of these randomly
%ocurring raindrops to be uniformly distributed in a grid. Adding this
%randomness to the simulation should not overcomplicate the model; however,
%for every instance when a raindrop occurs and chooses where to occur , its
%position will contain a realised but previously random nunmer (the initial
%position), which is interesting.
clear
% format long
%% governing equation parameters :
A = 2 ; %max acceleration
u = 0.3; %drag coefficient
%----------
J = 256; 
dtheta = (2*pi)/J; %spacing between consecutive angles
for i=0:J-1 %vector of points in the unit circle
    Unity(i+1,1) = cos(i*dtheta);
    Unity(i+1,2) = sin(i*dtheta);
end
R0 = eps;%initial distance from hit position

%Poisson process simulation:
duration = 10; %duration of the simulation
lambda = 10; %#droplets falling per unit time on average, since the model is stochastic
N = poissrnd(lambda*duration); %observed number of droplets for this current execution
for i=1:N
    Waiting_Times(i) = unifrnd(0,duration);
    Hits(i,1) = unifrnd(-2.5,2.5);
    Hits(i,2) = unifrnd(-2.5,2.5);
end
Waiting_Times = sort(Waiting_Times);
Waiting_Times = round(Waiting_Times,2);
t = 0;
dt = 0.01; %time step size
started = 0; %counter of droplets that have hit the ground already
Particles = zeros(J*N,2); %matrix for the particle's positions (the #rows is random, but on average will be J*lambda*duration)
S = scatter([],[],'filled');

%movie generation: uncomment to make a video
% %create the video writer
writerObj = VideoWriter('StartingRain.mp4');
writerObj.FrameRate = 100; %0.01 time step
% open the video writer 
open(writerObj);
while (t <= duration) 
    frame = getframe(gcf);
    writeVideo(writerObj,frame);
    %first, look for new droplets:
    if started < N
        while (Waiting_Times(1,started+1) == round(t,2))
            started = started +1; %increment and due to rounding, perhaps the next occurs at same time, so keep checking
            if started == N 
                break
            end
        end
    end
    %next, update the particle's positions around the started droplets
    for i=1:started %total iterations (worst case) = N*J , on average it will be duration*lambda*J
        %the ith particle information is collected in rows [(i-1)*J+1,i*J]
         for j=1:J
             Particles(((i-1)*J)+j,1) = Hits(i,1) + R(t-Waiting_Times(1,i),A,u,R0)*Unity(j,1);
             Particles(((i-1)*J)+j,2) = Hits(i,2) + R(t-Waiting_Times(1,i),A,u,R0)*Unity(j,2);
         end
    end
    set(S,'Xdata',Particles(1:J*started,1)');
    set(S,'Ydata',Particles(1:J*started,2)');
    S.MarkerFaceAlpha = 0.006;
    axis([-2.5 2.5 -2.5 2.5]);
    title(sprintf('Time: %0.2f units', t));
    grid on
    drawnow();
    t = t + dt;
end
%close the video writer object
close(writerObj);
%Simulating the dynamics of raining process:
figure
%plot of a raining process :
for a=1:length(Waiting_Times)
    if a == 1|| a== N
        if a == 1
            plot([0 Waiting_Times(1)],[0 0],"red");
        else
            plot([Waiting_Times(N-1) Waiting_Times(N)],[N-1 N-1],"red");
            plot([Waiting_Times(N) duration],[N N],"red");
        end 
    else
    plot([Waiting_Times(a-1) Waiting_Times(a)],[a-1 a-1],"red");
    hold on;
    end
end
yline(lambda*duration,'green'); %expected number of droplets
hold on;
plot([0 duration],[0 lambda*duration],'blue');
grid on;
axis([0 duration 0 length(Waiting_Times)]);
ax = gca;
ax.YTick = [0:N];
xlabel("units of time");
ylabel("# of droplets");
title("raining process");
%hit marks of the raining process over the simulated region
figure 
scatter(Hits(:,1)',Hits(:,2)');
title("Positions of the droplets");
xlabel("x");
ylabel("y");
grid on;



function r = R(t,A,u,R0)
 r = R0+A/u+(A/(1-u))*(exp(-t)-(exp(-u*t)/u));
end
function h = RandHit(l)
%l is the length of the grid for the simulation used 
h = -l+2*l.*rand(2,1);
end



