import 'dart:io';

void main() {
  //สร้างตัวแปร array list ที่เป็น string ที่ชื่อ lines  ไว้เก็บข้อมูลaddressจากการอ่านไฟล์ virtual_addr.txt
  List<String> lines = File('virtual_addr.txt').readAsLinesSync(); // อ่าน

  //สร้างตัวแปร Array List ของ pageTable 1&2 ที่เป็น string  มาเก็บข้อมูลของ Table_1 และ Table_2
  List<String> pageTable1 = [];
  List<String> pageTable2 = [];

  // สร้างตัวแปร boolean ไว้ใช้ในการเช็คข้อมูลของ Table_1 และ Table_2 ต
  bool isTable1 = false;
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
        //เช็คว่าเงื่อนไข isTable1 เป็นจริง?
        //ถ้า isTable1 เป็นจริง
        //หมายความว่า กำลังอ่านข้อมูล จากTable_1 อยู่ ให้เพิ่มข้อมูลline เข้าไปใน pageTable1
        pageTable1.add(line);
      } else {
        //ถ้าไม่เข้าเงื่อนไขด้านบน แสดงว่า   isTable1 เป็น false
        //เก็บข้อมูล line ที่อยู่ในtable2 ลงใน pageTable2
        pageTable2.add(line);
      }
    }
  });

  // Calculate physical address

  //รับ input virtual address  เข้ามา ในตัวแปร input
  stdout.write('Enter 32 bits  virtual address : ');
  String? input = stdin.readLineSync();

  try {
    //   ดักจับข้อผิดพลาด
    if (input == null) {
      throw Exception('input is must not be null');
    }
    if (input.length != 32) {
      throw Exception('input length should be 32 bits.');
    }

    // example input '00100010100000000010100000000101'  ;

    //แบ่งข้อมูลจาก input ออกเป็น 3 ส่วน ด้วยการใช้ substring ในการแยก
    // 10 bitแรก ไปเก็บในตัวแปร pt1
    String pt1 = input.substring(0, 10);
    // 10 bitต่อมา  ไปเก็บในตัวแปร pt2
    String pt2 = input.substring(10, 20);
    //และ 12 bit ที่เหลือ  ไปเก็บในตัวแปร offset
    String offset = input.substring(20);

    //สร้างตัวแปรไว้เก็บ index ที่แปลงจากเลขฐาน2 เป็นเลขฐาน10 ด้วยฟังก์ชั่น parse
    int index1 = int.parse(pt1, radix: 2);
    int index2 = int.parse(pt2, radix: 2);

    if (index1 >= pageTable1.length || index2 >= pageTable2.length) {
      throw Exception('index out of bounds. !');
    }

    //รวม pageTable1 , pageTable2 ,offset ให้เป็น physical address
    String physicalAddress = pageTable1[index1] + pageTable2[index2] + offset;

    //แสดงผล ouput  
    print(
        'Page Table Level 1 =  $pt1 : $index1   \nPage Table Level 2 =  $pt2 : $index2  \n     Offset  =  $offset');
    print('Physical Address     : $physicalAddress');
    print(
        '                     : ( ${pageTable1[index1]}:${pageTable2[index2]}:$offset) ');
  } catch (e) {
    //แสดงข้อผิดพลาดที่ถูกโยนมา
    print(e.toString());
  }
}
