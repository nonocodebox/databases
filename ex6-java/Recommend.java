/**
 * This class handles k-connected recommendations.
 * 
 */

import java.sql.*;
import java.util.HashSet;

public class Recommend
{
	private class DeviceInfo
	{
		public int did;
		public int dtype;

		public DeviceInfo(int did, int dtype)
		{
			this.did = did;
			this.dtype = dtype;
		}

		public boolean equals(Object obj)
		{
			// No need to check obj class since DeviceInfo is a private class.
			if ((obj == null))
			{
				return false;
			}

			if ((((DeviceInfo)obj).did == this.did) && (((DeviceInfo)obj).dtype == this.dtype))
			{
				return true;
			}

			return false;
		}

		public int hashCode()
		{
			return this.did + this.dtype;
		}
	}

	private Connection connection;
	public void init(String username)
	{
		if (connection != null)
		{
			return;
		}

		try
		{
			Class.forName("org.postgresql.Driver");
			connection = DriverManager.getConnection("jdbc:postgresql://pgserver/public?user=" + username);

		}
		catch(Exception e)
		{
			close();
		}
	}

	public void close()
	{
		try
		{
			if (connection != null && !connection.isClosed())
			{
				connection.close();
			}
		}
		catch (SQLException e)
		{
			// do nothing.
		}

		connection = null;
	}

	/**
	 * get users that currently have devices in set.
	 * @param set set of j connected s.t j <= k.
	 * @return set of users
	 * @throws SQLException sql exceptions
	 */
	private HashSet<Integer> getCommonUsers(HashSet<DeviceInfo> set) throws SQLException
	{
		String query = 	"SELECT userid " +
						"FROM Ownerships " +
						"WHERE did = ? AND ownershipDropped = 0";
		PreparedStatement psUser = connection.prepareStatement(query);
		try
		{
			HashSet<Integer> commonUsers = new HashSet<Integer>();

			for (DeviceInfo d: set)
			{
				psUser.setInt(1, d.did);
				ResultSet usersRes = psUser.executeQuery();

				try
				{
					while(usersRes.next())
					{
						commonUsers.add(usersRes.getInt("userid"));
					}
				}
				finally
				{
					usersRes.close();
				}
			}

			return commonUsers;
		}
		finally
		{
			psUser.close();
		}
	}

	/**
	 * giving set of users' id return their currently owned devices.
	 * @param commonUsers set of users' id
	 * @return set of their devices.
	 * @throws SQLException sql exceptions
	 */
	private HashSet<DeviceInfo> getCommonDevices(HashSet<Integer> commonUsers) throws SQLException
	{
		String query =  "SELECT did, dtype " +
						"FROM Ownerships NATURAL JOIN Devices " +
						"WHERE userid = ? AND ownershipDropped = 0";
		PreparedStatement psDevice = connection.prepareStatement(query);

		try
		{
			HashSet<DeviceInfo> commonDevices = new HashSet<DeviceInfo>();

			for (int uid: commonUsers)
			{
				psDevice.setInt(1, uid);
				ResultSet devicesRes = psDevice.executeQuery();

				try
				{
					while (devicesRes.next())
					{
						DeviceInfo uid_device = new DeviceInfo(devicesRes.getInt("did"), devicesRes.getInt("dtype"));
						commonDevices.add(uid_device);
					}
				}
				finally
				{
					devicesRes.close();
				}
			}

			return commonDevices;
		}

		finally
		{
			psDevice.close();
		}
	}

	/**
	 * filters userid's devices and devices that their type != dtype.
	 */
	private HashSet<Integer> notUsersSameType(HashSet<DeviceInfo> result, HashSet<DeviceInfo> users, int dtype)
    {
        HashSet<Integer> recommendations = new HashSet<Integer>();
        for (DeviceInfo d: result)
        {
            if (users.contains(d) || d.dtype != dtype)
            {
                continue;
            }

            recommendations.add(d.did);
        }

        return recommendations;
    }

	private static int [] convertInteget2Int(Integer[] input)
	{
		int [] output = new int [input.length];
		for(int i = 0; i < input.length; i++)
		{
			output[i] = input[i].intValue();
		}

		return output;
	}

	public int[] getRecommendation(int dtype, int userid, int k)
	{
		PreparedStatement pstmt = null;

		try
		{
			HashSet<DeviceInfo> set = new HashSet<DeviceInfo>();
			HashSet<DeviceInfo> user = new HashSet<DeviceInfo>();
			String query =  "SELECT did, dtype " +
							"FROM Ownerships NATURAL JOIN Devices " +
							"WHERE userid = ? AND ownershipDropped = 0";

			pstmt = connection.prepareStatement(query);
			pstmt.setInt(1, userid);

			ResultSet userDevicesRes = pstmt.executeQuery();

			try
			{
				while(userDevicesRes.next())
				{
					DeviceInfo newDevice = new DeviceInfo(userDevicesRes.getInt("did"), userDevicesRes.getInt("dtype"));
					set.add(newDevice);
					user.add(newDevice);
				}

				/* Now set contains all newDevice's devices. */

				// each iteration j we "collect" j connected users.
				for(int i = 0; i < k; i++)
				{
					set.addAll(getCommonDevices(getCommonUsers(set)));
				}

				HashSet<Integer> result_hash = notUsersSameType(set, user, dtype);
				Integer[] result_int = new Integer[result_hash.size()];
				result_int = result_hash.toArray(result_int);

				return convertInteget2Int(result_int);
			}

			finally
			{
				userDevicesRes.close();
			}
		}
		catch(Exception e)
		{
			close();
			return null;
		}
		finally
		{
			try
			{
				if (pstmt != null)
				{
					pstmt.close();
				}
			}
			catch (Exception e)
			{
				// do nothing.
			}
		}
	}
}
