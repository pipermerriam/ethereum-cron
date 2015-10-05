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
                DEC,
        }
        enum Weekdays {
                SUN,
                MON,
                TUE,
                WED,
                THU,
                FRI,
                SAT,
        }

        bytes constant YEARLY  = '0 0 0 1 1 *';
        bytes constant MONTHLY = '0 0 0 1 * *';
        bytes constant WEEKLY  = '0 0 0 * * 0';
        bytes constant DAILY   = '0 0 0 * * *';
        bytes constant HOURLY  = '0 0 * * * *';

        function next(bytes32 second, bytes32 minute, bytes32 hour, bytes32 day, bytes32 month, bytes32 isoWeekday, bytes32 year) constant returns (uint) {
        }
}
