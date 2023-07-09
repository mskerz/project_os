const fs = require('fs');  // import module ในการจัดการไฟล์ ที่ชื่อ 'fs'
// FCFS Scheduling
function fcfsScheduling(processes) {
    // เริ่มต้นเวลาที่ 0
    let currentTime = 0;
    const responseTimes = {}; // สร้างตัวเเปร output เพื่อเก็บเวลา response ของแต่ละ process
    const output = []; // สร้างตัวเเปร output เพื่อเก็บผลลัพธ์ที่จะเขียนลงในไฟล์
  
    processes.forEach((process) => {
      const [processName, instructionTime] = process;
      // เวลา response คือเวลาที่ process ถูกนำเข้ามาเป็นครั้งแรก
      responseTimes[processName] = currentTime;
  
      // นับเวลาที่ใช้ในการประมวลผล instruction ของ process
      const runningTime = currentTime;
      currentTime += instructionTime;
  
      // เก็บผลลัพธ์ในรูปแบบที่กำหนด
      //output.push(`${processName}\n${runningTime} - ${currentTime}\n${responseTimes[processName]}\n`);
      output.push(`${processName}\n${runningTime} - ${currentTime}\n${responseTimes[processName]}\n`);
    });
  
    // เขียนผลลัพธ์ลงในไฟล์ fcfs_schedule.txt
    

    try {//save ไฟล์
        fs.writeFileSync('fcfs_schedule.txt', output.join(''));
        console.log('---fcfs_schedule.txt was created!---');
      } catch (error) {
        console.error('Error writing file:', error);
      }
  }
  
  // รับ parameters process กับ quantum time
  function roundRobinScheduling(processes, quantumTime) {
    let currentTime = 0;
    const responseTimes = {};
    const output = [];
    const runningCounter = {};
  
    while (processes.length > 0) {
      // pop process แรกออกมาจาก queue
      const [processName, instructionTime] = processes.shift();
  
      if (!responseTimes[processName]) {
        // เวลา response คือเวลาที่ process ถูกนำเข้ามาเป็นครั้งแรก
        responseTimes[processName] = currentTime;
      }
  
      const runningTime = currentTime;
      // หา Running Counter ของแต่ละprocess
        //# เช็คว่า process ไหน ไม่เคยทำงานมาก่อน ให้กำหนดรอบในการทำงานแค่  1 รอบ   
      if (!runningCounter[processName]) {
        runningCounter[processName] = 1;


      } else { // ถ้า process   เคยทำงานมาก่อนแล้ว  ให้เพิ่มจำนวนครั้งของprocess นั้นๆ
        runningCounter[processName] += 1;
      }

      
      if (instructionTime > quantumTime) {
        // ถ้า instruction ของ process มีเวลามากกว่า quantum time
        // ให้ประมวลผล instruction ในระยะเวลา quantum time
        currentTime += quantumTime;
        
         
        
      
        //
        processes.push([processName, instructionTime - quantumTime]);
        // output.push(`${processName}\nRunning Counter: ${runningCounter[processName]}\nRunning Time: ${runningTime} - ${currentTime} (Quantum Time: ${quantumTime})\nResponse Time: ${responseTimes[processName]}\n`);
        output.push(`${processName}\nครั้งที่ - ${runningCounter[processName]}\n${runningTime} - ${currentTime}   ${quantumTime}QT\n${responseTimes[processName]}\n`);
      } else {
        // ถ้า instruction ของ process มีเวลาน้อยกว่าหรือเท่ากับ quantum time
        // ให้ประมวลผล instruction ในระยะเวลาทั้งหมดของ process
        currentTime += instructionTime;

        //output.push(`${processName}\nRunning Counter: ${runningCounter[processName]}\nRunning Time: ${runningTime} - ${currentTime} (Quantum Time: ${quantumTime})\nResponse Time: ${responseTimes[processName]}\n`);

        output.push(`${processName}\nครั้งที่ - ${runningCounter[processName]}\n${runningTime} - ${currentTime}   ${quantumTime}QT\n${responseTimes[processName]}\n`);
      }
    }
  
    
    // เขียนผลลัพธ์ลงในไฟล์ rr_schedule.txt 
    try {
        fs.writeFileSync('rr_schedule.txt', output.join(''));
        console.log('---rr_schedule.txt was created!---');
      } catch (error) {
        console.error('Error writing file:', error);
      }
    
     
  }
  

  // ฟังก์ชั่นในการอ่านไฟล์  รับพารามิเตอร์เป็นชื่อไฟล์
  function readProcessesFromFile(fileName) {

    const processes = [];
  
    const lines = fs.readFileSync(fileName, 'utf8').split('\n');
   
   
    lines.forEach((line) => {
      
      const trimmedLine = line.trim();
      if (trimmedLine !== '') {
        const [processName, instructionTime] = trimmedLine.split(' ');
        processes.push([processName, parseInt(instructionTime)]);
      }
    });
  
    return processes;
  }
  
  // สร้างตัวเเปร มารับ process จาก ฟังก์ชันอ่านไฟล์
  const processes = readProcessesFromFile('process.txt');
 // เรียกใช้ ฟังก์ชัน fcfs
  fcfsScheduling(processes);

  // เรียกใช้ ฟังก์ชัน round robin
  roundRobinScheduling(processes, 10);

  