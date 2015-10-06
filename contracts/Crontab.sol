contract DateTime {
        /*
         *  Date and Time utilities for ethereum contracts
         *
         *  address: 0x1a6184cd4c5bea62b0116de7962ee7315b7bcbce
         */
        struct DateTime {
                uint16 year;
                uint8 month;
                uint8 day;
                uint8 hour;
                uint8 minute;
                uint8 second;
                uint8 weekday;
        }

        uint constant DAY_IN_SECONDS = 86400;
        uint constant YEAR_IN_SECONDS = 31536000;
        uint constant LEAP_YEAR_IN_SECONDS = 31622400;

        uint constant HOUR_IN_SECONDS = 3600;
        uint constant MINUTE_IN_SECONDS = 60;

        uint16 constant ORIGIN_YEAR = 1970;

        function isLeapYear(uint16 year) constant returns (bool) {
                if (year % 4 != 0) {
                        return false;
                }
                if (year % 100 != 0) {
                        return true;
                }
                if (year % 400 != 0) {
                        return false;
                }
                return true;
        }

        function leapYearsBefore(uint year) constant returns (uint) {
                year -= 1;
                return year / 4 - year / 100 + year / 400;
        }

        function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                        return 31;
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11) {
                        return 30;
                }
                else if (isLeapYear(year)) {
                        return 29;
                }
                else {
                        return 28;
                }
        }

        function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
                uint secondsAccountedFor = 0;
                uint buf;
                uint8 i;

                dt.year = ORIGIN_YEAR;

                // Year
                dt.year = getYear(timestamp);
                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

                // Month
                uint secondsInMonth;
                for (i = 1; i <= 12; i++) {
                        secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
                        if (secondsInMonth + secondsAccountedFor > timestamp) {
                                dt.month = i + 1;
                                break;
                        }
                        secondsAccountedFor += secondsInMonth;
                }

                // Day
                for (i = 1; i < getDaysInMonth(dt.month, dt.year); i++) {
                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.day = i + 1;
                                break;
                        }
                        secondsAccountedFor += DAY_IN_SECONDS;
                }

                // Hour
                for (i = 0; i < 24; i++) {
                        if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.hour = i;
                                break;
                        }
                        secondsAccountedFor += HOUR_IN_SECONDS;
                }

                // Minute
                for (i = 0; i < 60; i++) {
                        if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.minute = i;
                                break;
                        }
                        secondsAccountedFor += MINUTE_IN_SECONDS;
                }

                if (timestamp - secondsAccountedFor > 60) {
                        __throw();
                }

                // Second
                dt.second = uint8(timestamp - secondsAccountedFor);

                // Day of week.
                buf = timestamp / DAY_IN_SECONDS;
                dt.weekday = uint8((buf + 3) % 7);
        }

        function getYear(uint timestamp) constant returns (uint16) {
                uint secondsAccountedFor = 0;
                uint16 year;
                uint numLeapYears;

                // Year
                year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

                while (secondsAccountedFor > timestamp) {
                        if (isLeapYear(uint16(year - 1))) {
                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                secondsAccountedFor -= YEAR_IN_SECONDS;
                        }
                        year -= 1;
                }
                return year;
        }

        function getMonth(uint timestamp) constant returns (uint8) {
                return parseTimestamp(timestamp).month;
        }

        function getDay(uint timestamp) constant returns (uint8) {
                return parseTimestamp(timestamp).day;
        }

        function getHour(uint timestamp) constant returns (uint8) {
                return uint8((timestamp / 60 / 60) % 24);
        }

        function getMinute(uint timestamp) constant returns (uint8) {
                return uint8((timestamp / 60) % 60);
        }

        function getSecond(uint timestamp) constant returns (uint8) {
                return uint8(timestamp % 60);
        }

        function getWeekday(uint timestamp) constant returns (uint8) {
                return uint8((timestamp / DAY_IN_SECONDS + 3) % 7);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
                return toTimestamp(year, month, day, 0, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, minute, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
                uint16 i;

                // Year
                for (i = ORIGIN_YEAR; i < year; i++) {
                        if (isLeapYear(i)) {
                                timestamp += LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                timestamp += YEAR_IN_SECONDS;
                        }
                }

                // Month
                uint8[12] monthDayCounts;
                monthDayCounts[0] = 31;
                if (isLeapYear(year)) {
                        monthDayCounts[1] = 29;
                }
                else {
                        monthDayCounts[1] = 28;
                }
                monthDayCounts[2] = 31;
                monthDayCounts[3] = 30;
                monthDayCounts[4] = 31;
                monthDayCounts[5] = 30;
                monthDayCounts[6] = 31;
                monthDayCounts[7] = 31;
                monthDayCounts[8] = 30;
                monthDayCounts[9] = 31;
                monthDayCounts[10] = 30;
                monthDayCounts[11] = 31;

                for (i = 1; i < month; i++) {
                        timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
                }

                // Day
                timestamp += DAY_IN_SECONDS * (day - 1);

                // Hour
                timestamp += HOUR_IN_SECONDS * (hour);

                // Minute
                timestamp += MINUTE_IN_SECONDS * (minute);

                // Second
                timestamp += second;

                return timestamp;
        }

        function __throw() {
                uint[] arst;
                arst[1];
        }
}


contract Crontab is DateTime {
        /*
         *  Crontab parsing implementation.
         *  - https://en.wikipedia.org/wiki/Cron#CRON_expression
         */

        byte constant STAR = '*';

        function _now() constant returns (uint) {
                return now;
        }

        function next(bytes2 ct_second, bytes2 ct_minute, bytes2 ct_hour, bytes2 ct_day, bytes2 ct_month, bytes2 ct_weekday, bytes2 ct_year) constant returns (uint) {
                /*
                 *  Given the 7 possible parts of a crontab entry, return the
                 *  next timestamp that this entry should be executed.
                 *
                 *  Currently only supports `*` or a single number.
                 */
                uint extraSeconds;
                uint16 buf;

                DateTime ct_next;

                buf = uint16(getSecond(now));
                ct_next.second = uint8(nextMatch(buf, ct_second, 59));

                if (ct_next.second < buf) {
                        extraSeconds += 60 - (buf - ct_next.second);
                }

                buf = uint16(getMinute(now + extraSeconds));
                ct_next.minute = uint8(nextMatch(buf, ct_minute, 59));

                if (ct_next.minute < buf) {
                        extraSeconds += MINUTE_IN_SECONDS * (60 - (buf - ct_next.minute));
                }

                buf = uint16(getHour(now + extraSeconds));
                ct_next.hour = uint8(nextMatch(buf, ct_hour, 59));

                if (ct_next.hour < buf) {
                        extraSeconds += HOUR_IN_SECONDS * (24 - (buf - ct_next.hour));
                }

                buf = uint16(getDay(now + extraSeconds));
                uint8 _month = getMonth(now + extraSeconds);
                uint16 _year = getYear(now + extraSeconds);
                ct_next.day = uint8(nextMatch(buf, ct_day, getDaysInMonth(_month, _year), false));
                if (ct_next.day == 0x0) {
                        // Rolled over to the next month.
                        if (_month == 12) {
                                _month = 1;
                                _year += 1;
                        }
                        else {
                                _month += 1;
                        }
                        ct_next.day = uint8(nextMatch(1, ct_day, min(buf - 1, getDaysInMonth(_month, _year)), false));
                }

                if (ct_next.day < buf) {
                        extraSeconds += DAY_IN_SECONDS * (getDaysInMonth(getMonth(now + extraSeconds), getYear(now + extraSeconds)) - buf + ct_next.day);
                }

                buf = uint8(getMonth(now + extraSeconds));
                ct_next.month = uint8(nextMatch(buf, ct_month, 12, false));

                if (ct_next.month == 0x0) {
                        if (buf == 12) {
                                _month = 1;
                        }
                        else {
                                _month = uint8(buf + 1);
                        }
                        ct_next.month = uint8(nextMatch(_month, ct_month, buf - 1, false));
                }

                if (ct_next.month < buf) {
                        buf = getYear(now + extraSeconds) + 1;
                }
                else {
                        buf = getYear(now + extraSeconds);
                }

                ct_next.year = nextMatch(buf, ct_year, 2099, false);
                if (ct_next.year == 0x0) {
                        return 0x0;
                }

                return toTimestamp(ct_next.year, ct_next.month, ct_next.day, ct_next.hour, ct_next.minute, ct_next.second);
        }

        function min(uint a, uint b) constant returns (uint) {
                if (a <= b) {
                        return a;
                }
                return b;
        }

        function _patternToNumber(bytes4 pattern) constant returns (uint16 res){
                byte _byte;

                _byte = byte(uint(pattern) / (2 ** 24));
                if (_byte != 0x0) {
                        res = 10 * res +  uint16(uint8(_byte) - 48);
                }

                _byte = byte(uint(pattern) / (2 ** 16));
                if (_byte != 0x0) {
                        res = 10 * res +  uint16(uint8(_byte) - 48);
                }

                _byte = byte(uint(pattern) / (2 ** 8));
                if (_byte != 0x0) {
                        res = 10 * res + uint16(uint8(_byte) - 48);
                }

                _byte = byte(uint(pattern));
                if (_byte != 0x0) {
                        res = 10 * res + uint16(uint8(_byte) - 48);
                }

                return res;
        }

        function nextMatch(uint16 startValue, bytes2 pattern, uint maximum) returns (uint16) {
                return nextMatch(startValue, pattern, maximum, true);
        }

        function nextMatch(uint16 startValue, bytes2 pattern, uint maximum, bool allowRollover) returns (uint16) {
                if (pattern == "*") {
                        return startValue;
                }

                uint16 i;
                uint16 patternValue = _patternToNumber(pattern);

                for (i = startValue; i <= maximum; i++) {
                        if (i == patternValue) {
                                return i;
                        }
                }
                if (allowRollover) {
                        for (i = 0; i < startValue; i++) {
                                if (i == patternValue) {
                                        return i;
                                }
                        }
                }
                return 0x0;
        }
}
