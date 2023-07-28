import 'dart:io';

void main() {
  // Read data from virtual_addr.txt
  List<String> lines = File('virtual_addr.txt').readAsLinesSync();

  // Initialize page tables
  List<String> pageTable1 = [];
  List<String> pageTable2 = [];

  // Split the input into two page tables
 bool isTable1 = true;
lines.forEach((line) {
  if (line.startsWith('Table_1')) {
    isTable1 = true;
  } else if (line.startsWith('Table_2')) {
    isTable1 = false;
  } else {
    if (isTable1) {
      pageTable1.add(line);
    } else {
      pageTable2.add(line);
    }
  }
});

  // creat var input for input virtual address from keyboard dart
  // Calculate physical address

  String input = '00000000100000000011100000000101'; // Example input: 10 bits PT1 + 10 bits PT2 + 12 bits Offset virtual address
  String pt1 = input.substring(0, 10); // Get the first 10 bits as PT1
  String pt2 = input.substring(10, 20); // Get the next 10 bits as PT2
  String offset = input.substring(20); // Get the last 12 bits as Offset

  // Convert binary PT1 and PT2 to decimal
  int index1 = int.parse(pt1, radix: 2);
  int index2 = int.parse(pt2, radix: 2);

  // Check if the indexes are within the page tables' bounds
  if (index1 >= pageTable1.length || index2 >= pageTable2.length) {
    print('Invalid index. Out of bounds.');
    return;
  }

  // Get the physical addresses from page tables
  String physicalAddress = pageTable1[index1] + pageTable2[index2] + offset;
  String physicalAddress_log =
      '${pageTable1[index1]}:${pageTable2[index2]}:$offset';

  print('input virtual address: $input');
  //Page Table 1   $pt1 ชี้ไปที่ page $index1   \nPage Table 2 =  $pt2 ชี้ไปที่ page $index2  \n
  print(
      'Page Table 1 =  $pt1 : $index1   \nPage Table 2 =  $pt2 : $index2  \n     Offset  =  $offset');
  print('Physical Address     : $physicalAddress');
  print('Physical Address Log : $physicalAddress_log');
}
