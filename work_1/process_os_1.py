def fcfs_scheduling(processes):
    # เริ่มต้นเวลาที่ 0
    current_time = 0
    response_times = {}  # เก็บเวลา response ของแต่ละ process
    output = []  # เก็บผลลัพธ์ที่จะเขียนลงในไฟล์

    for process_name, instruction_time in processes:
        # เวลา response คือเวลาที่ process ถูกนำเข้ามาเป็นครั้งแรก
        response_times[process_name] = current_time

        # นับเวลาที่ใช้ในการประมวลผล instruction ของ process
        running_time = current_time
        current_time += instruction_time

        # เก็บผลลัพธ์ในรูปแบบที่กำหนด
        output.append(f"{process_name}\n{running_time} - {current_time}\n{response_times[process_name]}\n")

    # เขียนผลลัพธ์ลงในไฟล์ fcfs_schedule.txt
    try:
        with open('output_python/schedule_fcfs.txt', 'w') as file:
            file.write(''.join(output))
            print('---schedule_fcfs.txt was created!---')
    except IOError as e:
        print('Error writing file:', e)


#รับ parameters process กับ quantum time
def round_robin_scheduling(processes, quantum_time):
    current_time = 0 
    response_times = {}
    output = []
    running_counter = {}

    while processes:
        # pop  process แรกออกมาจากคิว
        process_name, instruction_time = processes.pop(0)

        if process_name not in response_times:
            # เวลา response คือเวลาที่ process ถูกนำเข้ามาเป็นครั้งแรก
            response_times[process_name] = current_time

        running_time = current_time
        
        
        #หา Running Counter ของแต่ละprocess

            # เช็คว่า process ไหน ไม่เคยทำงานมาก่อน ให้กำหนดรอบในการทำงานแค่  1 รอบ   
        if process_name not in running_counter:
            running_counter[process_name] = 1
        else:
            # ถ้า process   เคยทำงานมาก่อนแล้ว  ให้เพิ่มจำนวนครั้งของprocess นั้นๆ
            running_counter[process_name] += 1
        
        if instruction_time > quantum_time:
            # ถ้า instruction ของ process มีเวลามากกว่า quantum time
            # ให้ประมวลผล instruction ในระยะเวลาของ quantum time
            current_time += quantum_time
            instruction_time -= quantum_time
            
            processes.append((process_name, instruction_time))
            output.append(f"{process_name}\n{running_counter[process_name]}\n{running_time} - {current_time} {quantum_time} QT\n{response_times[process_name]}\n")
        else:
            # ถ้า instruction ของ process มีเวลาน้อยกว่าหรือเท่ากับ quantum time
            # ให้ประมวลผล instruction ในระยะเวลาทั้งหมดของ process
            current_time += instruction_time
            output.append(f"{process_name}\n{running_counter[process_name]}\n{running_time} - {current_time}\n{response_times[process_name]}\n")

    # เขียนผลลัพธ์ลงในไฟล์ rr_schedule.txt
    try:
        with open('output_python/schedule_rr.txt', 'w') as file:
            file.write(''.join(output))
            print('---schedule_rr.txt was created!---')
    except IOError as e:
        print('Error writing file:', e)


def read_processes_from_file(file_name):
    processes = []  #สร้างตัวแปร มาเก็บ process
    with open(file_name, "r") as file:  # เปิดไฟล์ process
        lines = file.readlines()  # อ่านบรรทัดทั้งหมดของไฟล์และเก็บไว้ในรายการ
        for line in lines:  # วนลูปทุกบรรทัด
            line = line.strip()  # ลบช่องว่างหน้าและหลังของบรรทัด
            if line:  # ตรวจสอบว่าแต่ละบรรทัดนั้นว่างหรือไม่
                process_name, instruction_time = line.split()  # แยกข้อความในบรรทัดด้วยช่องว่างและเก็บไปที่ตัวแปร
                processes.append((process_name, int(instruction_time)))  # เพิ่มคู่อันดับของชื่อprocessและintruction time เข้าไปใน processes
    return processes  # return processes กลับไป



processes = read_processes_from_file("process.txt")
fcfs_scheduling(processes)
round_robin_scheduling(processes, quantum_time=10)
