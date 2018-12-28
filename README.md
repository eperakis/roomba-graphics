# roomba-graphics
Created a virtual roomba that avoids obstacles and cleans the floor as part of the CS 3451 Graphics Class at GT.
1. Start from the Main file
2. Documentation as to what each feature does is available below:


Step 7

1.	How you advance the robot

In order to advance the robot I created a vector that is the path my Roomba moves on which begins at Y(O[a]) and ends at Y(a), where Y(O[a]) is the circumcenter of the triangle the corner across from ‘a’ is in and Y(a) is the circumcenter of the triangle of corner ‘a’. This path is on the voronoi edge which satisfies the requirement of moving the Roomba on the voronoi edges. I then created a step - which is the distance the Roomba moves with every step - which I initialized at 1 (to go slower) or 2 (to go faster). 
In order to start the movement, I start my Roomba at Y(O[a]) and then I check whether the distance between its position and the end of my path (Y(a)) is less than 1 step, in which case I stop moving. If the distance is more than a step, then I have created an int variable called “dist” which tracks how far I’ve moved, so I add 1 step to “dist” and then move my Roomba to the position Y(O[a]) + dist. I do all this with the following code:

2.	How you detect that you arrived at a junction

In order to detect that I’ve arrived at a junction, I check whether the distance between the Roomba (I track the location of the roomba with the variable “roomba”) and Y(a) (which is the end of my path) is less than 1 step, as mentioned above, in which case I have arrived at the junction and can just change the location of my Roomba to Y(a).

3.	How you select which branch of N to follow next

In order to select which branch of N to follow I have an if-statement that checks which branch is closest to my target and then I pick that branch. In order to pick the closest branch, I first check whether the current position (Y(a)) is closer to the target than the circumcenter of the triangle at the left corner (Y(l(a))) or right corner (Y(r(a))), in which case I don’t move the Roomba since I’m already at the closest spot to the target:
I then check whether the circumcenter of the triangle at the corner opposite to ‘a’ (Y(O[a])) is closer to the target T than the circumcenter of the triangle at the left or right corners:
I then check whether the circumcenter of the triangle at the left corner is closer to the target than the right one - in which case I would move left: 
And finally I check whether the circumcenter of the triangle at the right corner is closer to the target than the left one - in which case I would move right:
After I’ve decided which branch I should follow, I change my Roomba’s position to Y(a) and then change my ‘a’ corner to either O[a], l(a), or r(a) accordingly.

Step 8

Step 8 allows the user to experience both the manual and automated Roomba. In LIVE mode - which is when they first press ‘8’ the user can control the Roomba manually by holding the leash and can see which parts have been cleaned as they turn red. Once the user presses ‘L’ the floor goes back to dirty and they enter the non-Live mode which includes the automated Roomba that goes around and cleans the whole floor efficiently by itself. You can see which parts of the floor have been cleaned as they turn cyan. At the top the user can see how much distance they have traveled with the automated Roomba, and how much with the manual. The distance is simply measured by how many steps the Roomba took. Right below they can see which Roomba won by completing fewer steps.

Step 9

In this step I’m finding the closest distance between the Roomba and the different pillars in order for the array to hit the pillar that is at the closest distance (find the smallest, positive d). I use the quadratic formula in order to calculate the distance ‘d’. More specifically I use the following formula (the math was discussed in class):
I check whether [pow(b,2) - 4*a*k >= 0] and if that’s the case then I find 2 possible x positions that the array could hit that pillar at - x1 and x2 - by using the quadratic formula. I check which one is greater than zero and pick that as my x. I then draw the rays which are beams that start at the location of the Roomba and go along vector V1 = V(cos(i),sin(i),0), for distance x1 and x2. I then save the id of this index in order to note in the array of hitPillars that that specific pillar was hit by the ray. I do all this for 100 rays.
The next step is coloring the pillars differently depending on whether they have been hit and whether the Roomba has touched them. When they have been seen by a ray I make them turn white. When they have been touched by the Roomba they turn cyan at the top. When they have been seen I keep track of them by making them red. In order to change the pillar colors I use 2 functions (showHit() and showClean()) which use for-loops to check whether a pillar has been hit by a ray or has been touched by the Roomba. 
