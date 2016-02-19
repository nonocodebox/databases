DROP VIEW IF EXISTS DevicePopularity;

DROP TRIGGER IF EXISTS delDeviceTrackTrig ON DeviceTracking;
DROP TRIGGER IF EXISTS delOwnershipsTrig ON Ownerships;
DROP TRIGGER IF EXISTS delDevicesTrig ON Devices;
DROP TRIGGER IF EXISTS ownershipsDroppedTrig ON DeviceTracking;
DROP TRIGGER IF EXISTS dateChkTrig ON DeviceTracking;
DROP TRIGGER IF EXISTS popularDeviceTrackTrig ON DeviceTracking;
DROP TRIGGER IF EXISTS popularOwnerTrig ON Ownerships;

DROP FUNCTION IF EXISTS popularDevTrackFunc();
DROP FUNCTION IF EXISTS popularOwnerFunc();
DROP FUNCTION IF EXISTS dateChkFunc();
DROP FUNCTION IF EXISTS ownershipsDroppedFunc();
DROP FUNCTION IF EXISTS disableDeleteFunc();
DROP FUNCTION IF EXISTS getFirmPopularity(firmid integer);
DROP FUNCTION IF EXISTS getPopularity(deviceid integer);
DROP FUNCTION IF EXISTS getMonthPassed(trackingid integer);