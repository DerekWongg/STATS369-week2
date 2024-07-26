# STATS369-week2

## Idea of algorithm
1. Two part of scoring: project score(60%) + adjustment score(40%):
    - project score: score * 0.6
    - adjustment score: ranking of project in class * adjusment factor
      - ranking of project: ranking / number of projects
      - adjustment factor: -100% for 1, -20% for 2, 0% for 3, 20% for 4, 40% for 5
    - pros:
      - consider both overall and self performance, getting rewarded or penalised for 5s and 1s
    - cons:
      - will be benificial for students who rate each other 5/5
    - Scenario 1:  Group Score: 70%; Individual teammate appraisal scores: 3, 3, 3, 3, 3 with rank of 10/23 in class
        - mark for each person will be 70 * 0.6 + 10 * 0 = 42
    - Scenario 2:  Group Score: 70%; Individual teammate appraisal scores: 5, 5, 5, 5, 5. with rank of 10/23 in class
        - mark for each person will be 70 * 0.6 + 10 * 1.4 = 84
    

## Roles:

- Coding & graphic(1): Derek
- Script for present(1): Tony
- Video processing & task submission & quiz(1): Yu
- Report(1): Sophia

## Method of delievery: 

- each of us record our part and put togather (need one extra position for video editting)

## Reference for idea
[Grading Methods for Group Work](https://www.cmu.edu/teaching/assessment/assesslearning/groupWorkGradingMethods.html)

## Possible cases to be considered (from the chatroom)
- Scenario 1:  Group Score: 70%; Individual teammate appraisal scores: 3, 3, 3, 3, 3. 
- Scenario 2:  Group Score: 70%; Individual teammate appraisal scores: 5, 5, 5, 5, 5.
- Scenario 3:  Group Score: 80%; Individual teammate appraisal scores: 3, 3, 3, 3, 3.
- Scenario 4:  Group Score: 70%; Individual teammate appraisal scores: 1, 2, 3, 4, 5.
- Scenario 5:  Group Score: 90%; Individual teammate appraisal scores: 1, 4, 4, 5.

## Points to evaluate the project
Clarity: Considering how the team presented their method in their video and report, did they present their idea and approach clearly?
Communication: How do you rate the non-technical aspects of this team's communication, for example their description of the underlying principles, strengths and weaknesses of their method?


## Present
- principle
- algorithm
- code
- graph


## Timeline
Algorithm number settled: Sat noon
Coding part done: Sat Midnight
Report: Sun midnight
Script: Sun midnight
Video: Mon midnight
