<div align="center">
    <picture>
        <img alt="mockup" src="https://github.com/nikodittmar/MyRaceTimer-v2/assets/77522904/1feb3f7d-4abc-47d0-b588-754015217c04" width="260">
    </picture>
    <br>
    <br>
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://github.com/nikodittmar/MyRaceTimer-v2/assets/77522904/c8f12afc-84ed-45f2-badd-b9a53e345caa">
        <source media="(prefers-color-scheme: light)" srcset="https://github.com/nikodittmar/MyRaceTimer-v2/assets/77522904/751d18ed-02f5-4ad1-87a7-49f8054d9060">
        <img alt="Logo" src="./READMEImages/MRTLogoWhite.png" width="320">
    </picture>
</div>
<br>
MyRaceTimer is an iPhone app that makes timing mountain bike races/timed trials easier than ever before. Originally created for use in the Joaquin Miller Park Enduro, the app has since gone off to be used in many other events such as the Briones Winter Enduro. Currently, MyRaceTimer is undergoing beta testing before it is ready to be released.

## Background 
Before MyRaceTimer, there existed two ways of timing mountain bike races/timed trials: chip and manual timing. Chip timing involves the use of specialized RFID chips and gates which record the start and finish times of each racer. This information would then be loaded onto a computer to calculate the results. Unfortunately, while very accurate, due to all of the specialized equipment needed, chip timing is extremely expensive and difficult to set up putting it out of reach for most mountain biking events. These events would be left to the second method of race timing, manual timing. 

Manual timing works by manually writing down racer start and finish times on paper using a stopwatch. While this solution may seem easy at first, when it comes time to calculate results, many downsides become immediately apparent. To calculate results, the following steps are required:

1. Calculate the time between the recorded start and finish time for each racer on each timed segment.
2. Add up each racer’s time for each timed segment to get their overall time.
3. Handle DNFs (did not finish), DNSs (did not start), and penalties.
4. Sort all of the racers overall times to find the winners.

Even for small events with few racers, the amount of calculations and steps required to calculate the results makes it incredibly tedious and too error-prone to be successful. For most events, an alternative solution is needed.

Luckily, MyRaceTimer combines the best of both worlds for chip and manual timing. As an iPhone app, MyRaceTimer has the same computational accuracy of chip timing. Also, because the recordings are not on paper and are “born digital”, the app can automatically calculate the race results with perfect precision solving the issue of manual timing. Finally, because everyone has a phone, MyRaceTimer eliminates the need for any specialized and expensive equipment. 

| ![MyRaceTimerComparison](https://github.com/nikodittmar/MyRaceTimer-v2/assets/77522904/623c1618-53fc-429b-aab2-5005b6605689) | 
|:--:| 
| *MyRaceTimer compared to Chip Timing and Manual Timing* |

## Usage
To begin, each racer should be assigned a number. This number should be printed out onto a number plate that is affixed to the bike and that is clearly visible. Number plates can be created at any local print shop or special ordered from online retailers such as Race Result or Memory Pilot. Due to the nature of mountain biking, it is a good idea to make the number plates out of a water and mud resistant material.

For each stage, there must be two phones running seperate instaces of MyRaceTimer. One phone will be designated as the stage start and the other will be the stage finish. The stage start phone will be responsible for recording the racer start times while the stage finish phone will be responsible for recording the racer finish times. During the timing of the race, both apps are running independently and are not connected to each other in any way. Due to this face, MyRaceTimer is unable to provide live results. Unless the stage start location is the same as the stage finish location, seperate timing staff will need to operate each instance of the app. Below is a diagram of the MyRaceTimer timing setup for a single stage. 

| ![MRTDiagram](https://github.com/nikodittmar/MyRaceTimer-v2/assets/77522904/9d61bee8-4670-4d5e-b283-25db84730594) | 
|:--:| 
| *MyRaceTimer Stage Diagram* |

Phones can be reused to time races with multiple stages. However, a seperate set of phones will be required for each stage that is running concurrently. To figure out the amount of phones or instaces of MyRaceTimer required to time a race, multiply the highest amount of stages that will run concurrently by two. When the race is finished, all of the phones used for timing will share their individual sets of recordings with to one central phone. Only one phone is required to calculate the race results. Recording sets can be sent over text, email, or airdrop in the case of no internet.  

## Timing Procedure

### Stage Start
1. Ensure that MyRaceTimer is in start mode.
2. Press "Add Plate Number" for each racer that is about to start. This will create a recording without a plate number or timestamp.
3. Using the number pad, enter in the plate numbers for each racer that is about to start.
4. As the racer(s) crosses the start line , press "Record Time". This will add a timestamp to all recordings missing one.
5. Repeat until everyone has started.

### Stage Finish
1. Ensure that MyRaceTimer is in finish mode.
2. Press "Record Time" every time a racer passes the finish line. This will create a recording without a plate number.
3. Use the number pad to input the finished racer's raceplate number.
4. Repeat until all racers have finished.

Note: Record time can be pressed multiple times without entering in the last recording's raceplate number if more than one racer finishes in quick succession.

## Timing Screen Diagram

![MyRaceTimerTimingScreen](https://github.com/nikodittmar/MyRaceTimer-v2/assets/77522904/7249a4fd-c873-49a0-9976-49577442b4d0)


Note: MyRaceTimer-v2 is the same as app as MyRaceTimer, however it was rebuilt from the ground up using test driven development.
