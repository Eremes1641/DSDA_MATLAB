# DSDA
This is a simple example of Discrete-Time Sliding Mode Control with Disturbance Compensation and Auxiliary state.

# How to Run the Example
Please follow the steps below to open the example code:
1. Open `Project.prj`
2. Open `main/main_DSDA.m`
3. Run the file

If can't open `Project.prj` follow the steps below to create a new project:
1. Delete `Project.prj` file and `resources` folder
2. Set MATLAB's current folder at repo folder
3. Click `New` -> `Project` -> `From folder`
4. Click `Create`
5. Add `subFuntion` to the project path by right-clicking -> `Project Path` -> `Add to the Prject Path (Including Subfolders)`

If don't want to use `Project.prj` to manage files, follow the steps below:
1. Open `main without project/main_DSDA.m`
2. Run the file
3. If MATLAB popup a dialog window. Select `Change Folder` instead of `Add to Path`

# Reference
[1] Ji-Seok Han, Tae-Il Kim, Tae-Ho Oh, Sang-Hoon Lee and Dong-Il “Dan” Cho, 
"Effective Disturbance Compensation Method Under Control Saturation in Discrete-Time Sliding Mode Control," 
in IEEE Transactions on Industrial Electronics, vol. 67, no. 7, pp. 5696-5707, July 2020, doi: 10.1109/TIE.2019.2931213.

[2] Yongsoon Eun, Jung-Ho Kim, Kwangsoo Kim, Dong-Il Cho
"Discrete-time variable structure controller with a decoupled disturbance compensator and its application to a CNC servomechanism." 
IEEE Transactions on Control Systems Technology 7.4 (1999): 414-423.
