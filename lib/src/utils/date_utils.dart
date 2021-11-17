
enum DateField {
  YEAR,
  MONTH,
  DAY,
  HOUR,
  MINUTE,
  SECOND
}

class MyDateUtils {
  int truncatedCompare(DateTime d1, DateTime d2, [DateField toField = DateField.SECOND]) {
    int result = d1.year.compareTo(d2.year);

    if (toField == DateField.YEAR) {
      return result;
    } else {
      if (result != 0) { return result; }
      
      result = d1.month.compareTo(d2.month);
      if (toField == DateField.MONTH) {
        return result;
      } else {
        if (result != 0) { return result; }
        
        result = d1.day.compareTo(d2.day);
        if (toField == DateField.DAY) {
          return result;
        } else {
          if (result != 0) { return result; }

          result = d1.hour.compareTo(d2.hour);
          if (toField == DateField.HOUR) {
            return result;
          } else {
            if (result != 0) { return result; }

            result = d1.minute.compareTo(d2.minute);
            if (toField == DateField.MINUTE) {
              return result;
            } else {
              if (result != 0) { return result; }

              return d1.second.compareTo(d2.second);                
            }
          }
        }
      }
    }
  }
}