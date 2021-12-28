
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo_list/src/utils/my_date_utils.dart';

void main() {
  setUp(() {});

  group("Test MyDateUtils method truncatedCompare", () {
    test("Compare 2 DateTimes without param toField should compare"
        " to the field 'second'.", () {
        final d1 = DateTime(2021, 9, 15, 9, 0, 30);
        final d2 = DateTime(2021, 9, 15, 9, 0, 45);
        final result1 = MyDateUtils.truncatedCompare(d1, d2);
        expect(true, result1 < 0);

        final d3 = DateTime(2021, 9, 16, 10, 5, 20);
        final d4 = DateTime(2021, 9, 16, 10, 5, 20);
        final result2 = MyDateUtils.truncatedCompare(d3, d4);
        expect(true, result2 == 0);

        final d5 = DateTime(2021, 9, 17, 18, 0, 26);
        final d6 = DateTime(2021, 9, 17, 13, 30, 30);
        final result3 = MyDateUtils.truncatedCompare(d5, d6);
        expect(true, result3 > 0);
      });

    test("Compare 2 DateTimes with toField == DateField.DAY should compare"
        " to the field 'day'.", () {
        final d1 = DateTime(2021, 8, 15, 9, 0, 30);
        final d2 = DateTime(2021, 8, 15, 10, 20, 45);

        expect(true, MyDateUtils.truncatedCompare(d1, d2, DateField.DAY) == 0);

        final d3 = DateTime(2021, 11, 1, 9, 0, 30);
        final d4 = DateTime(2021, 11, 2, 9, 0, 30);

        expect(true, MyDateUtils.truncatedCompare(d3, d4, DateField.DAY) < 0);
    });

    test("Compare 2 DateTimes with toField == DateField.HOUR should compare"
        " to the field 'hour'.", () {
        final d1 = DateTime(2021, 8, 15, 10, 0, 30);
        final d2 = DateTime(2021, 8, 15, 10, 30, 15);

        expect(true, MyDateUtils.truncatedCompare(d1, d2, DateField.HOUR) == 0);

        final d3 = DateTime(2021, 11, 1, 9, 0, 30);
        final d4 = DateTime(2021, 11, 2, 9, 0, 30);

        expect(true, MyDateUtils.truncatedCompare(d3, d4, DateField.HOUR) < 0);
    });

  });
}