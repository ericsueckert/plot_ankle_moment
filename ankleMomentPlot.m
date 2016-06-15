clear all;
close all;
clc

%Load file (All header should be removed!)
data = load('ankle_angle_and_moment_r.txt');

%stiffness levels of rubber bands in Nm/degrees
stiff1 = 0.234;
stiff2 = 0.8069;
stiff3 = 1.848;
stiff4 = 3.94;
mass = 72.6;

index=data(:,1); 
e=length(index); %final data (end)

t=data(:,2); %time

ankle = data(:,4); %Dorsiflexors
ankle_angles = data(:,3);


%calculate data number in each gait cycle
%%%%%%%%%%%%%%%%%%%%%%%%%  Input gait initiation and termination time time  %%%%%%%%%%%%%%%%%%%%%%%%%%
gait_time_r = [0.600; 1.850];
gait_time = [1.250; 2.450]; %input time at gait initiate time, first column is gait initiation, last column is gait termination

for i=1:length(gait_time_r);
    [start_time(i),j] = ind2sub(size(t), find(t == gait_time_r(i, 1))); %store the data number in start_time variable
end
start_time = start_time';

%normalized time
for i = 1:length(start_time)-1; %6?? ?? ?? timeset ??
    N_time(:,i) = linspace(t(start_time(i),1), t(start_time(i + 1),1), 101)';
end



%interpolation

for i = 1:length(start_time)-1;
     i_ankle(:,i) = interp1(t(start_time(i):start_time(i + 1),1), ankle(start_time(i):start_time(i + 1),1), N_time(:,i));
     i_ankle_angles(:,i)=interp1(t(start_time(i):start_time(i+1),1), ankle_angles(start_time(i):start_time(i+1),1), N_time(:,i));
end
i_ankle = (i_ankle *(-1)) / mass;
i_stiffness_moment_1 = (i_ankle_angles * stiff1) / mass;
i_stiffness_moment_2 = (i_ankle_angles * stiff2) / mass;
i_stiffness_moment_3 = (i_ankle_angles * stiff3) / mass;
i_stiffness_moment_4 = (i_ankle_angles * stiff4) / mass;

%Plot%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx=0:1:100; 

figure(1)

% Plotting and formatting
    plot(xx, i_ankle(:,1),'k')    
    hold on
    plot(xx, i_stiffness_moment_1(:,1),'r')
    plot(xx, i_stiffness_moment_2(:,1),'b')
    plot(xx, i_stiffness_moment_3(:,1),'g')
    plot(xx, i_stiffness_moment_4(:,1),'m')
    title('Ankle Moment (Right)')
    xlabel('Percent of Gait Cycle (%)');
    ylabel('Ankle Moment per Kilogram (Nm/K)');
    legend('Ankle Moment', '0.234 Nm/deg', '0.8069 Nm/deg','1.848 Nm/deg','3.94 Nm/deg');
    
export = [];
export(:, 1) = 1:101;
export(:, 2) = i_ankle(:,1);
export(:, 3) = i_stiffness_moment_1;
export(:, 4) = i_stiffness_moment_2;
export(:, 5) = i_stiffness_moment_3;
export(:, 6) = i_stiffness_moment_4;

    
xlswrite('Ankle_moment_data_r', export);
   
