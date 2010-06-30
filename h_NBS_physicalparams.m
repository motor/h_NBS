% Dear Robert,
% Sorry for the delay. Your question was indeed received and is being processed but was buried in the email inbox.
% Some quick comments (may be duplicate to the ones I sent you before):
% - Direction vector gives the coil direction during stimulation, see page 81 in "NBS user manual" for coordinate axes directions 
% (z-axis running towards the subject nose, y-axis running towards the top of the head). Please check the manual, because the axis definitions 
% can be confounding. If you are doing 180 degree coil rotations on the top of the head, you should look at the x and z axes changes 
% of the direction vector.
% - Origin of the coil coordinate system is in the bottom of the coil, not in the center of the stimulus
% - The direction vector points to the direction of the stimulation (page 82, table 11 in NBS user manual)
% - Normal vector points away from the head, along the coil handle
% - Some users have reported problems in opening the text file in Excel, sometimes linefeed handling is not working properly. One has to pay 
% attention to this issue when opening the files. Notepad opens the file correctly without mixing the linefeed, 
% compare your excel file to notepad (Note that you have to stretch the window quite a lot to see the entire lines properly).
% We will try to replicate the coordinate issue here, as you suggest there may be a bug in the generation of the text file. I will tell you when we know more about the matter. And once again, sorry for the delay.
% Best regards,
% 
% Tuomas Neuvonen
% Email: tuomas.neuvonen@nexstim.com
% Web: http://www.nexstim.com
% 
% 
% 
% ***
% Dear Tuomas,
% 
% first of all, thank you very much for your last reply concerning the eXimia coordinate system.
% Based on your descriptions I tried to calculate the stimulation directions from the exportfiles (.nbe). You told me that the coil directions written to the .nbe file are given as vectors in the coordinate system chosen for the exportfile. Thus, I did some simple calculation on the direction vectors given there and tried to match them to our original data. Just using trigonometrical calculations did not  yet reveal any results that would match the original data. Thus, I would  like to address some issues regarding the calculation:
% Here is an example of two stimuli applied to opposite directions (e.g.  0° and 180°, respectively):
% 
% Coil                      Coil
% Normal                    Dir.
% x         y       z       x       y       z
% 0,5667	0,8237	0,0202	0,1949	0,1102	0,9746
% 0,4577	0,8891	0,0093	0,2105	0,1186	0,9704
% 
% I first expected the coil direction to be calculated as vectors with their base in the center of the stimulus given (thus, center of the stimulus being x/y/z = 0/0/0) and the end being given by the x/y/z  value.
% As x/y/z values are always positive I decided to relate the coil  dir.
% values to the coil normal by simple subtraction (coil normal - coil  dir.
% for each stimulus). Trigonometrical calculation (sine function) for  the x-y-plane (NBS coordinates) reveals some results that are in perfect aggreement with some of our origninal data but some are not. In the example shown above one could estimate a stimulation direction (with 0° being sagitally oriented) of 10° (first) and 190° (second).
% Example calculation for first stimuli:
% 0,5667 (normal) - 0,1949 (dir) = 0,3718 ;x-axis
% 0,0202 - 0,9746 = -0,9544 ;
% z-axis (y-axis in NBS system?!) 
% hypotenuse = 0,80456 
% sine = 0,88682 
% degree = 62,476 r
% esult for second stimulus: 72,212
% 
% In a x-y- plane the x/y values should be invers, e.g. x > 0 / y > 0 and  x < 0 / y < 0, respectively, which is not the case (here both would be x
% > 0 and y < 0), even after substracting the coil dir. from the coil normal. Additionally, for many other stimuli simple substraction does  not even reveal any reasonable information about the quadrant a direction vector should be in (i.e., x/y being >0 or <0). This information should be crucial to decide whether the direction is 80° or 100° as the sine would the same for both.
% Is there anything I did not take into account or that I should consider to calculate directions in degrees? I just cannot find a reason why trigonometrical calculation works pretty fine for some stimuli but fails for others. I would be very grateful to receive an answer to this issue. I would be very pleased if you could provide an example of a useful approach to calculate the direction.
% With best regards, Robert.

figure, hold on
for i=1:length(Dir)
    vectarrow(Loc(i,:), Dir(i,:),'sdf')
end
