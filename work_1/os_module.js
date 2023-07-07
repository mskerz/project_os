const fs = require('fs');
const { get } = require('http');
const os = require('os');

// เรียกใช้งานฟังก์ชัน fcfsScheduling() และ roundRobinScheduling()

// ...

// ฟังก์ชันในการเรียกใช้งาน module 'os'
function getOS() {
  const osInformation = {
    platform: os.platform(),
    release: os.release(),
    totalMemory: os.totalmem()/10^9,
    freeMemory: os.freemem(),
  };

  return osInformation;
}

// ตัวอย่างการใช้งานฟังก์ชัน getOperatingSystemInformation()
const os_info = getOS();
console.log(os_info);
