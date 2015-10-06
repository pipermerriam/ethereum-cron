contract Crontab {
        /*
         *  Crontab parsing implementation.
         *  - https://en.wikipedia.org/wiki/Cron#CRON_expression
         */
        enum Months {
                JAN,
                FEB,
                MAR,
                APR,
                MAY,
                JUN,
                JUL,
                AUG,
                SEP,
                OCT,
                NOV,
                DEC
        }
        enum Weekdays {
                SUN,
                MON,
                TUE,
                WED,
                THU,
                FRI,
                SAT
        }

        bytes constant YEARLY  = '0 0 0 1 1 *';
        bytes constant MONTHLY = '0 0 0 1 * *';
        bytes constant WEEKLY  = '0 0 0 * * 0';
        bytes constant DAILY   = '0 0 0 * * *';
        bytes constant HOURLY  = '0 0 * * * *';

        function next(bytes32 second, bytes32 minute, bytes32 hour, bytes32 day, bytes32 month, bytes32 isoWeekday, bytes32 year) constant returns (uint) {
        }

        /*
         *  Date/Time utils
         */
        struct DateTime {
                uint16 year;
                uint8 month;
                uint8 day;
                uint8 hour;
                uint8 minute;
                uint8 second;
                uint8 dayOfWeek;
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

        function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
                uint secondsAccountedFor = 0;
                uint buf;
                uint8 i;

                dt.year = ORIGIN_YEAR;

                // Year
                while (true) {
                        if (isLeapYear(dt.year)) {
                                buf = LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                buf = YEAR_IN_SECONDS;
                        }

                        if (secondsAccountedFor + buf > timestamp) {
                                break;
                        }
                        dt.year += 1;
                        secondsAccountedFor += buf;
                }

                // Month
                uint8[12] monthDayCounts;
                monthDayCounts[0] = 31;
                if (isLeapYear(dt.year)) {
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

                uint secondsInMonth;
                for (i = 0; i < monthDayCounts.length; i++) {
                        secondsInMonth = DAY_IN_SECONDS * monthDayCounts[i];
                        if (secondsInMonth + secondsAccountedFor > timestamp) {
                                dt.month = i + 1;
                                break;
                        }
                        secondsAccountedFor += secondsInMonth;
                }

                // Day
                for (i = 0; i < monthDayCounts[dt.month - 1]; i++) {
                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.day = i + 1;
                                break;
                        }
                        secondsAccountedFor += DAY_IN_SECONDS;
                }

                // Hour
                for (i = 0; i < 24; i++) {
                        if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.hour = i + 1;
                                break;
                        }
                        secondsAccountedFor += HOUR_IN_SECONDS;
                }

                // Minute
                for (i = 0; i < 60; i++) {
                        if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.minute = i + 1;
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
                dt.dayOfWeek = uint8((buf + 3) % 7);
        }

        function getYear(uint timestamp) constant returns (uint16) {
                return parseTimestamp(timestamp).year;
        }

        function getMonth(uint timestamp) constant returns (uint16) {
                return parseTimestamp(timestamp).month;
        }

        function getDay(uint timestamp) constant returns (uint16) {
                return parseTimestamp(timestamp).day;
        }

        function getHour(uint timestamp) constant returns (uint16) {
                return parseTimestamp(timestamp).year;
        }

        function getMinute(uint timestamp) constant returns (uint16) {
                return parseTimestamp(timestamp).year;
        }

        function getSecond(uint timestamp) constant returns (uint16) {
                return parseTimestamp(timestamp).year;
        }

        function __throw() {
                uint[] arst;
                arst[1];
        }
}
