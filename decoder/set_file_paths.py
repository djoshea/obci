from PrairieStream import PyPrairieControl
from datetime import datetime

hyphenDate = datetime.today().strftime("%Y-%m-%d")
numDate = datetime.today().strftime("%Y%m%d")
subject = "Xavier"
#subject= "Testing"
hdd = "F"

useTSeries = True

if 'pc'in locals():
    pc.disconnect()

pc = PyPrairieControl()
# pc.setVerbose(stream=True, udp=True)
# pc.setVerbose(udp=True)

if not pc.connect():
    raise RuntimeError("couldn't connect")

try:
    if not pc.setSavePath(f"{hdd}:\\DataRoot\\rig1\\{subject}\\{hyphenDate}\\2P\\CenterOutReach\\site001"):
        raise RuntimeError("Error setting save path")

    if not pc.setSingleImageName(f"SingleImage_{numDate}"):
        raise RuntimeError("Error setting single image name")

    if not pc.setTSeriesName(f"Tseries_{numDate}_{subject}_CenterOutReach"):
        raise RuntimeError("Error setting tseries name")

    print("Finished setting paths")

except Exception as exc:
    pc.disconnect()
    raise exc

finally:
     pc.disconnect()
