import 'dart:io';

void main() {
  //สร้างตัวแปร array list ที่เป็น string ที่ชื่อ lines  ไว้เก็บข้อมูลaddressจากการอ่านไฟล์ virtual_addr.txt
  List<String> lines = File('virtual_addr.txt').readAsLinesSync(); // อ่าน

  // Initialize page tables
  List<String> pageTable1 =
      []; //สร้างตัวแปร pageTable 1&2 เป็น Array List ที่มีtype เป็น String
  List<String> pageTable2 = [];

  // สร้างตัวแปร boolean ไว้ใช้กับ เมธอด startWith
  bool isTable1 = false; //default : false
  lines.forEach((line) {
    //วนรูปตามจำนวน lines
    //ถ้า line เริ่มต้นด้วย Table_1  ให้กำหนดค่า isTable1 เป็น true
    if (line.startsWith('Table_1')) {
      isTable1 = true;
    } //ถ้า line เริ่มต้นด้วย Table_2 ให้กำหนดค่า isTable1 เป็น false
    else if (line.startsWith('Table_2')) {
      isTable1 = false;
    } else {
      //ถ้าบรรทัดไม่ได้ขึ้นต้นด้วย Table_1 และ Table_2
      if (isTable1) {
        //เช็คว่า isTable1 เป็น true หรือไม่
        //ถ้า isTable1 เป็น true
        //หมายความว่า ถ้าอ่านข้อมูล จากTable_1  จะเพิ่ม line เข้าไปใน pageTable1
        pageTable1.add(line);
      } else {
        //ถ้า  isTable1 เป็น false
        //หมายความว่า ถ้าอ่านข้อมูล จากTable_2  จะเพิ่ม line เข้าไปใน pageTable2
        pageTable2.add(line);
      }
    }
  });

  // creat var input for input virtual address from keyboard dart
  // Calculate physical address

  stdout.write('Enter a virtual address: ');
  String? input = stdin.readLineSync();

  try {
    //  ถ้า input เป็น  null ให้โยนข้อผิดพลาดไปแสดงผลทางหน้าจอ
    if (input == null) {
      throw Exception('input is must not be null');
    }
    // ถ้าความยาวของinputมีมากกว่า 32 ให้โยนข้อผิดพลาดไปแสดงผลทางหน้าจอ
    if (input.length < 32) {
      throw Exception('input length should be at least 32 characters.');
    }

    // example input '00000000100000000010100000000101';
    //ตัด 10 bitแรกจากตัวแปร input ไปเก็บในตัวแปร pt1 ด้วย function substring
    String pt1 = input.substring(0, 10);
    //ตัด 10 bitถัดไป จากตัวแปร input ไปเก็บในตัวแปร pt2 ด้วย substring
    String pt2 = input.substring(10, 20);
    //ตัด 12 bit สุดท้าย จากตัวแปร input  ไปเก็บในตัวแปร offset  substring
    String offset = input.substring(20);

    //สร้างตัวแปรไว้เก็บตำแหน่งของ page ที่แปลงจากเลขฐาน2 เป็นเลขฐาน10 ด้วยfunction parse
    int index1 = int.parse(pt1, radix: 2);
    int index2 = int.parse(pt2, radix: 2);

    // ถ้าค่าindex1และindex2  มีค่ามากกว่าหรือเท่ากับความยาวของ pageTable1 และ PageTable2
    // ให้โยนข้อผิดพลาดไปแสดงผลทางหน้าจอ
    if (index1 >= pageTable1.length || index2 >= pageTable2.length) {
      throw Exception('Invalid index out of bounds.');
    }

    //สร้างตัวแปร  physicalAddress เพื่อรวม pageTable1 , pageTable2 ,offset เข้าไว้ด้วยกัน (นำมาต่อกัน) และเก็บไ้ไว้ใน physical address 
    String physicalAddress = pageTable1[index1] + pageTable2[index2] + offset;
    String physicalAddress_log ='${pageTable1[index1]}:${pageTable2[index2]}:$offset';

    //แสดงผล ouput ที่เป็น physicalAddress 
    print( 'Page Table 1 =  $pt1 : $index1   \nPage Table 2 =  $pt2 : $index2  \n     Offset  =  $offset');
    print('Physical Address     : $physicalAddress');
    print('                     : ( $physicalAddress_log )');
  } catch (e) {
    //แสดงข้อผิดพลาดที่ถูกโยนมา
    print(e.toString());
  }
}
