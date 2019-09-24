from cydecodelogic import OnlineDecoder
from cyprairiestream import PyPrairieControl
from datetime import datetime

useTSeries = True

if 'pc' not in locals():
    pc = PyPrairieControl()

# pc.setVerbose(stream=True, udp=True)
# pc.setVerbose(udp=True)

if not pc.connect():
    raise RuntimeError("couldn't connect")

try:
    pc.setUseTSeries(useTSeries)

    od = OnlineDecoder(pc)
    od.run()

except Exception as exc:
    pc.stopPolling()
    raise exc

finally:
     pc.stopPolling()

