CREATE FUNCTION disableDeleteFunc() RETURNS trigger AS $$
BEGIN
return null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delDeviceTrackTrig
BEFORE
DELETE ON DeviceTracking
FOR EACH ROW
EXECUTE PROCEDURE disableDeleteFunc();

CREATE TRIGGER delOwnershipsTrig
BEFORE
DELETE ON Ownerships
FOR EACH ROW
EXECUTE PROCEDURE disableDeleteFunc();

CREATE TRIGGER delDevicesTrig
BEFORE
DELETE ON Devices
FOR EACH ROW
EXECUTE PROCEDURE disableDeleteFunc();