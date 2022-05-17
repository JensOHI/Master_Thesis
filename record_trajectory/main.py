import scipy
from scipy.spatial.transform import Rotation as R
import numpy as np
import time

from rtde_control import RTDEControlInterface
from rtde_receive import RTDEReceiveInterface
from rtde_io import RTDEIOInterface

def convertForceInBase2TCP(rtde_receive, ftInBase):
        tcpPose = rtde_receive.getActualTCPPose()
        rot = R.from_rotvec(tcpPose[3:6])
        rMatrix = scipy.linalg.inv(rot.as_matrix())
        return rMatrix @ ftInBase[0:3]

def record_trajectory(rtde_control, rtde_receive):
    tcps = []
    forces = []
    joint_positions = []
    frequency=1/500
    try:
        rtde_control.teachMode()
        while True:
            startTime = time.time()

            tcps.append(rtde_receive.getActualTCPPose())
            forces.append(convertForceInBase2TCP(rtde_receive, rtde_receive.getActualTCPForce()))
            joint_positions.append(rtde_control.getActualJointPositionsHistory(0))

            diffTime = time.time() - startTime
            if (diffTime < frequency):
                time.sleep(frequency - diffTime)
    except KeyboardInterrupt:
        pass
    rtde_control.endTeachMode()
    return tcps, forces, joint_positions


if __name__=="__main__":
    ip = "192.168.0.10"
    rtde_control = RTDEControlInterface(ip)
    rtde_receive = RTDEReceiveInterface(ip)
    rtde_io = RTDEIOInterface(ip)
    is_in_free_drive = False
    tcps = []
    forces = []
    joint_positions = []
    while True:
        print("\n\n"+"-"*20)
        print("f: Toggles free drive.\nr: records the demonstration.\nctrl+C: Stops the recording.\ns: Saves the last recording.\nq: Quits the program.")
        print("-"*20+"\n\n")
        try:
            key = input("Press a key ... then press enter: ")[0].lower()
        except:
            pass

        if key == "f":
            if is_in_free_drive:
                rtde_control.endTeachMode()
            else:
                rtde_control.teachMode()
            is_in_free_drive = not is_in_free_drive            
        elif key == "r":
            tcps, forces, joint_positions = record_trajectory(rtde_control, rtde_receive)
        elif key == "s":
            if len(tcps) == 0 or len(forces) == 0 or len(joint_positions) == 0:
                print("No recording exists!")
            else:
                filename = input("Input filename: ")
                with open(filename+".csv", 'x') as file:
                    header = "pos_x, pos_y, pos_z, ori_x, ori_y, ori_z, f_x, f_y, f_z, q_base, q_shoulder, q_elbow, q_wrist1, q_wrist2, q_wrist3"
                    body = "\n".join(", ".join(str(e) for e in tcp)+", " +", ".join(str(e) for e in force) + ", " + ", ".join(str(e) for e in joint_position) for tcp, force, joint_position in zip(tcps, forces, joint_positions))
                    # print(header+"\n"+body)
                    file.write(header+"\n"+body)

                        



        elif key == "q":
            exit()